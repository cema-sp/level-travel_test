Feature: Second Test
  In order to get countries list on email
  As a user
  I use second test feature

  Scenario: Fill and send countries request
    Given avaliable countries for '2014-12-30' and '7' nights are:
      | Country |  
      | Egypt   |  
      | Turkey  |  
    When I visit '/second' path
    And I enter 's.a.pisarev@gmail.com' in 'email' field
    And I enter '2014-12-30' in 'date' field
    And I enter '7' in 'nights' field
    And I click 'Search' button
    Then I see confirmation page
    And I receive email with proper countries
