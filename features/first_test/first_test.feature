Feature: First Test
  In order to get callendar
  As a user
  I want to get calendar for country

  Scenario: Get Calendar
    Given It is '2014-12-1'
    And nights for 'EG' are:
      | Date | Nights |  
      | 1    | 7      |  
      | 2    | 6,10   |  
      | 6    | 10     |  
      | 11   | 7,8    |  
    When I visit '/first' path
    And I choose 'Москва, Moscow' from 'from_city' dropdown list
    And I choose 'Египет, EG' from 'to_country' dropdown list
    And I click 'Show' button
    Then I see the proper header
    And I see the proper calendar:
      | Mo    | Tu       | Th | Fo        | Fr | Su     | Sa |  
      | 1 (7) | 2 (6,10) | 3  | 4         | 5  | 6 (10) | 7  |  
      | 8     | 9        | 10 | 11 (7, 8) | 12 | 13     | 14 |  
      | 15    | 16       | 17 | 18        | 19 | 20     | 21 |  
      | 22    | 23       | 24 | 25        | 26 | 27     | 28 |  
      | 29    | 30       | 31 |           |    |        |    |  
