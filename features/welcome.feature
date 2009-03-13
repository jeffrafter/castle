Feature: Welcome
  As an new user
  I want to be welcomed 
  So that I can understand how the system works and use it
 
  Scenario: User is not known and sends a message
    Given I am an unknown user with the number '9098675309'
    When I send the command 'yodel'
    Then a new user should be created with the number '9098675309' 
    And I should receive a confirmation

  # The welcome text should also contain the help text
  Scenario: User is not registered and responds with 'yes' to the confirmation
    Given I am an known user with the number '9098675309'
    When I send the command 'yes'
    Then my number should be confirmed 
    And I should receive a message that contains 'You will receive messages from your program sponsor'

  # We could respond with a message that the user account has been deleted 
  Scenario: User is not registered and responds with 'no' to the confirmation
    Given I am an known user with the number '9098675309'
    When I send the command 'no'
    Then my number should not be confirmed 
    And I should not receive a message

  # We could instead respond with a request for clarification
  Scenario: User is not registered and responds with 'ducks' to the confirmation
    Given I am an known user with the number '9098675309'
    When I send the command 'ducks'
    Then my number should not be confirmed 
    And I should not receive a message