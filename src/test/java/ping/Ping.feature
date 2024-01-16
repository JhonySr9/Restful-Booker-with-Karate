Feature: Ping

  Background:
    * headers commonHeaders
    * url baseUrl
    * path 'ping'

    @Ping001
    Scenario: (GET) Ping to receive a HealthCheck
      Given method GET
      When status 201
      Then match response contains 'Created'
