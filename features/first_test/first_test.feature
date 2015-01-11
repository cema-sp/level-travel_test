Feature: First Test
  In order to get callendar
  As a user
  I use first test feature

  Background:
    Given It is '2014-12-2'
    And body of 'countries' response from fixture 'responses'
    And body of 'cities' response from fixture 'responses'
    And nights for selected country in f&n API response are:
      | Date       | Nights |  
      | 2014-12-02 | 7      |  
      | 2014-12-03 | 6,10   |  
      | 2014-12-06 | 10     |  
      | 2014-12-11 | 7,8    |  

  Scenario: Get Calendar
    When I visit '/first' path
    And I choose 'Москва, Moscow' from 'from_city' dropdown list
    And I choose 'Египет, EG' from 'to_country' dropdown list
    # And to run first test I click 'Показать' button
    # Then I see the proper info
    # And I see the proper calendar table:
    #   | Mo | Tu    | We       | Th        | Fr | Sa     | Su |  
    #   |    | 2 (7) | 3 (6,10) | 4         | 5  | 6 (10) | 7  |  
    #   | 8  | 9     | 10       | 11 (7, 8) | 12 | 13     | 14 |  
    #   | 15 | 16    | 17       | 18        | 19 | 20     | 21 |  
    #   | 22 | 23    | 24       | 25        | 26 | 27     | 28 |  
    #   | 29 | 30    | 31       |           |    |        |    |  
