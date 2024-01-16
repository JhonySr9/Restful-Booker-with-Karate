Feature: Login

  Background:
    * headers commonHeaders
    * url baseUrl
    * path 'auth'

    # Parameters
    * def username = "admin"
    * def password = "password123"


  @Login001
  Scenario: User is able to log in successfully.
    # Test
    Given request { username: '#(username)', password: '#(password)' }
    When method POST
    Then status 200
    And match response.token == '#present'
