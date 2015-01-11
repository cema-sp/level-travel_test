Feature: Second Test
  In order to get email with countries list
  As a user
  I use second test feature

  Background:
    Given body of 'countries' response from fixture 'responses'
    And available nights for selected date:
      | Country | Nights |  
      | RU      | 5,6    |  
      | EG      | 5,7    |  
      | TR      | 7      |  

  Scenario: Fill and send countries request
    When I visit '/second' path
    # And I enter 's.a.pisarev@gmail.com' in 'email' field
    # And I enter '2014-12-30' in 'date' field
    # And I enter '7' in 'nights' field
    # And to run second test I click 'Искать' button
    # Then I see confirmation page
    # And I receive email with proper countries
