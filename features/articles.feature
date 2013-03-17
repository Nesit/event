Feature: Articles display

  Scenario: Login with wrong email
    Given news article is published with
      | title                    |
      | Длинное название новости |
    And I am on the main page
    Then I should see "Длинное название новости"

  Scenario: Check picture link in gallery
    Given news article published with gallery
    And I am on the article page
    Then show me the page
    Then I should see tag ".article-short"
