Feature: Booking

  Background:
    * headers commonHeaders
    * url baseUrl
    * path 'booking'

    # Pre-data
    * def firstnameData = read('classpath:booking/data/firstname.json')
    * def lastnameData = read('classpath:booking/data/lastname.json')
    * def totalpriceData = read('classpath:booking/data/totalprice.json')
    * def depositpaidData = read('classpath:booking/data/depositpaid.json')
    * def bookingdates_checkinData = read('classpath:booking/data/bookingdates_checkin.json')
    * def bookingdates_checkoutData = read('classpath:booking/data/bookingdates_checkout.json')
    * def additionalneedsData = read('classpath:booking/data/additionalneeds.json')


    # Functions
    * def randomNumber =
    """
    function(max) {
      return parseInt(Math.floor(Math.random() * Math.floor(max)));
    }
    """
    * def generateRandomData =
  """
  function(data) {
    var index = randomNumber(data.length);
    var result = data[index].name;
    return result;
  }
  """

    # Post-data

    * def randomFirstname = generateRandomData(firstnameData.value)
    * def randomLastname = generateRandomData(lastnameData.value)
    * def randomTotalprice = generateRandomData(totalpriceData.value)
    * def randomDepositpaid = generateRandomData(depositpaidData.value)
    * def randomBookingdatesCheckin = generateRandomData(bookingdates_checkinData.value)
    * def randomBookingdatesCheckout = generateRandomData(bookingdates_checkoutData.value)
    * def randomAdditionalneeds = generateRandomData(additionalneedsData.value)

    # Request
    * def bookingRequest = read('classpath:booking/newBooking.json')
    * request bookingRequest

  @Booking001
  Scenario: (GET) Returns the ids of all the bookings that exist
  # Test
  Given method GET
    When status 200
    Then match response.[*] == '#present'
    And match response[*].bookingid == '#notnull'

  @Booking002
  Scenario: (POST) Create a new Booking
  # Test
  Given method POST
    When status 200
    Then match response.bookingid == '#present'
    And match response.bookingid == '#number'

  @Booking003
  Scenario: (POST) Check the Booking information returned is the same that was sent
  # Test
    Given method POST
    When status 200
    And match response.booking == bookingRequest

