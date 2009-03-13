Feature: Subscribing
  As an registered user
  I want to subscribe to a feeds
  So that I can get messages delivered to me
 
  Scenario: User has never been to subscribed to the channel 
    Given I am a user with no subscriptions 
    And a channel 'sports' exists
    When I send the command 'add sports'
    Then I should be subscribed to 'sports' 
    And I should receive a confirmation
    And I should receive 5 deliveries

  Scenario: User is already subscribed to the channel 
    Given a channel 'sports' exists 
    And I am a user with a subscription to 'sports' 
    And I have not received the last entry from 'sports'
    When I send the command 'add sports'
    Then I should be subscribed to 'sports' 
    And I should receive a confirmation
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