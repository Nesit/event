Feature: User authentication
  
  Background:
    Given the following user registered:
      | email            | password |
      | user@example.com | secret   |
    And I am on the main page
    And login dialog is shown

  @javascript
  Scenario: Login with wrong email
    When I fill within login form with
      | email           | password |
      | wrong@email.com | secret   |
    And I click on submit button within login form
    Then I should see "Неправильный email или пароль" within login dialog

  @javascript
  Scenario: Login with wrong password
    When I fill within login form with
      | email            | password       |
      | user@example.com | wrong-password |
    And I click on submit button within login form
    Then I should see "Неправильный email или пароль" within login dialog

  @javascript
  Scenario: Successful login
    When I fill within login form with
      | email            | password |
      | user@example.com | secret   |
    And I click on submit button within login form
    And I wait for ajax
    Then I should see "Профиль"