Feature: User registration via captcha
  Background:
    Given I am on the main page
    And register dialog is shown

  @javascript
  Scenario: register with wrong captcha
    When I fill within register form with
      | user[email]      | captcha       |
      | user@example.com | wrong-captcha |
    And I click on submit button within register form
    Then I should see "Неправильно введён код с картинки" within register dialog

  @javascript @wip
  Scenario: register successfully
    When I fill within register form with
      | user[email]           |
      | test-user@example.com |
    And I enter right captcha within register form
    And I click on submit button within register form
    Then I should see "Письмо с дальнейшими инструкциями отправлено на указанный адрес" within register dialog