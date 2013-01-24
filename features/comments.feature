Feature: Article commenting
  
  Background:
    Given news article published

  @javascript
  Scenario: Comment as guest
    Given I am not logged in
    And I am on the article page
    Then comment text area should be readonly
    And I should see "Чтобы оставить комментарий вам нужно авторизироваться" within comment form
    And submit button should not be visible within comment form

  @javascript
  Scenario: Comment as user without additional info
    Given I am logged in as user without additional info
    And I am on the article page
    Then comment text area should be readonly
    And I should see "Заполните информацию в личном кабинете" within comment form
    And submit button should not be visible within comment form

  @javascript
  Scenario: Comment as user with additional info
    Given I am logged in as user with complete info
    And I am on the article page
    Then comment text area should not be readonly
    And submit button should be visible within comment form