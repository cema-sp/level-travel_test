Feature: Welcome
  In order to use first and second tests
  As a user
  I use welcome page

  Scenario: Browse welcome page
    When I visit '/' path
    Then I see the proper index page
    And I see '/first' link
    And I see '/second' link
