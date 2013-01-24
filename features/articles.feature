Feature: Articles display

  Scenario: Login with wrong email
    Given news article is published with
      | title                    |
      | Длинное название новости |
    And I am on the main page
    Then I should see "Длинное название новости"