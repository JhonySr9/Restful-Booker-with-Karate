Feature: Booking

  Background:
    * headers commonHeaders
    * url baseUrl
    * path 'booking'
    * def fakerObj =  new faker()

    # Pre-data
    * def firstnameData = fakerObj.name().firstName()
    * def lastnameData = fakerObj.name().lastName()
    * def totalpriceData = fakerObj.number().numberBetween(1000, 6000)
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

    * def randomFirstname = firstnameData
    * def randomLastname = lastnameData
    * def randomTotalprice = totalpriceData
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

  @Booking004
  Scenario: (PUT) Update a Booking check in with information from another Customer
  # Pre-conditions
    ## Log in
    * call read('classpath:authorization/Login.feature@Login001')
    * def tokenNumber = response.token
    ## Cookies
    * cookies 'Cookie: token=' + tokenNumber
    ## Create a Booking
    * call read('classpath:booking/Booking.feature@Booking002')
    * def bookingId = response.bookingid

  # Test
    Given path 'booking/' + bookingId
    When method PUT
    Then status 200
    And match response.bookingdates.checkin == randomBookingdatesCheckin
    And match response.bookingdates.checkout == randomBookingdatesCheckout

  @Booking005
  Scenario: (DELETE) Delete a Booking check (With Cookies)
  # Pre-conditions
    ## Log in
    * call read('classpath:authorization/Login.feature@Login001')
    * def tokenNumber = response.token
    ## Cookies
    * def cookieHeaderValue = 'token=' + tokenNumber
    ## Create a Booking
    * call read('classpath:booking/Booking.feature@Booking002')
    * def bookingId = response.bookingid

  # Test
    Given path 'booking/' + bookingId
    And headers { 'Cookie': '#(cookieHeaderValue)' }
    When request { 'id': '#(bookingId)' }
    And method DELETE
    Then status 201
    And match response contains 'Created'
