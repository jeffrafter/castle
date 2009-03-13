Feature: Adding
  As a registered user
  I want to add feeds
  So that I can get messages delivered to me
 
  Scenario: User subscribes to the channel by number
    Given I am a user with no subscriptions 
    And a channel 'sports' exists
    When I send the command '1'
    Then I should be subscribed to 'sports' 
    And I should receive a message that contains "Subscribed to 'sports'. To undo, reply 'saca sports'. You are subscribed to: 1) sports"
    And I should receive 5 deliveries

  Scenario: User subscribes to the channel by name
    Given I am a user with no subscriptions 
    And a channel 'sports' exists
    When I send the command 'sports'
    Then I should be subscribed to 'sports' 
    And I should receive a message that contains "Subscribed to 'sports'. To undo, reply 'saca sports'. You are subscribed to: 1) sports"
    And I should receive 5 deliveries

  Scenario: User subscribes to the channel by command and number
    Given I am a user with no subscriptions 
    And a channel 'sports' exists
    When I send the command 'add 1'
    Then I should be subscribed to 'sports' 
    And I should receive a message that contains "Subscribed to 'sports'. To undo, reply 'saca sports'. You are subscribed to: 1) sports"
    And I should receive 5 deliveries

  Scenario: User subscribes to the channel by command and name
    Given I am a user with no subscriptions 
    And a channel 'sports' exists
    When I send the command 'add sports'
    Then I should be subscribed to 'sports' 
    And I should receive a message that contains "Subscribed to 'sports'. To undo, reply 'saca sports'. You are subscribed to: 1) sports"
    And I should receive 5 deliveries

  Scenario: User is already subscribed to the channel 
    Given a channel 'sports' exists 
    And I am a user with a subscription to 'sports' 
    And I have not received the last entry from 'sports'
    When I send the command 'add sports'
    Then I should be subscribed to 'sports' 
    And I should receive a confirmation
    And I should receive 0 deliveries

  # Echoing back user input seems dangerous, can we change this to "I don't understand your last command"
  Scenario: User subscribes to an unknown channel
    Given I am a user with no subscriptions 
    And a channel 'sports' exists
    When I send the command 'add ducks'
    Then I should not be subscribed to 'sports' 
    And I should receive a message that contains "I don't understand 'ducks'. Use these channels: 1) sports"
    And I should receive 0 deliveries

  Scenario: User was subscribed to the channel but unsubscribed and has received the last message
    Given I am a user with no subscriptions 
    And a channel 'sports' exists
    And I have received the last entry from 'sports'
    When I send the command 'add sports'
    Then I should be subscribed to 'sports' 
    And I should receive a confirmation
    And I should receive 0 deliveries

  Scenario: User was subscribed to the channel but unsubscribed and has not received the last message
    Given I am a user with no subscriptions 
    And a channel 'sports' exists
    And I have not received the last entry from 'sports'
    When I send the command 'add sports'
    Then I should be subscribed to 'sports' 
    And I should receive a confirmation
    And I should receive 5 deliveries