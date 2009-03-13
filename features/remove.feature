Feature: Removing
  As a registered user
  I want to remove feeds
  So that I do not get messages delivered to me
 
  Scenario: User unsubscribes from the channel by command and number
    Given a channel 'sports' exists 
    And I am a user with a subscription to 'sports' 
    When I send the command 'remove 1'
    Then I should not be subscribed to 'sports' 
    And I should receive a message that contains "Unsubscribed from 'sports'. To undo, reply 'add sports'. You have no subscriptions"

  Scenario: User unsubscribes from the channel by command and name
    Given a channel 'sports' exists 
    And I am a user with a subscription to 'sports' 
    When I send the command 'remove sports'
    Then I should not be subscribed to 'sports' 
    And I should receive a message that contains "Unsubscribed from 'sports'. To undo, reply 'add sports'. You have no subscriptions"

  Scenario: User unsubscribes from a channel they are not subscribed to
    Given a channel 'sports' exists 
    And a channel 'ducks' exists 
    And I am a user with a subscription to 'ducks' 
    When I send the command 'remove sports'
    Then I should receive a message that contains "You are not subscribed to that channel. You are subscribed to: 2) ducks"

  Scenario: User unsubscribes from an unknown channel
    Given a channel 'ducks' exists 
    And I am a user with a subscription to 'ducks' 
    When I send the command 'remove sports'
    Then I should receive a message that contains "That channel does not exist. You are subscribed to: 2) ducks"