Feature: Logging in
  As a user
  I want to login with my details
  So that I can configure the server 
 
  Scenario: User is not logged in
    Given no current user
    When I access a page
    Then the login form should be shown
    And I should not be authorized
 
  Scenario: User enters wrong password
    Given a registered user with the email "francine@hullaballoo.com" with password "doughnuts" exists
    And I am on the "/login" page
    When I fill in "email" with "francine@hullaballoo.com"
    And I fill in "password" with "ticklemeelmo"
    And I press "Sign in"
    Then the login form should be shown
    And I should see "Bad email or password"
    And I should not be signed in
 
  Scenario: User is registered and enters correct password
    Given a registered user with the email "francine@hullaballoo.com" with password "doughnuts" exists
    And I am on the "/login" page
    When I fill in "email" with "francine@hullaballoo.com"
    And I fill in "password" with "doughnuts"
    And I press "Sign in"
    Then the login form should be shown
    And I should see "User has not confirmed email"
    And I should not be authorized
    And I should not be signed in
    
  Scenario: User is confirmed and enters correct password
    Given a confirmed user with the email "francine@hullaballoo.com" with password "doughnuts" exists
    And I am on the "/login" page
    When I fill in "email" with "francine@hullaballoo.com"
    And I fill in "password" with "doughnuts"
    And I press "Sign in"
    Then I should be redirected to "/"
    And I should see "Signed in successfully"    
    And I should be signed in
