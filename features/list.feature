Feature: Listing
  As a registered user
  I want to list feeds
  So that I can perform commands with them
 
  Scenario: User with no subscriptions
    Given I am a user with no subscriptions 
    And a channel 'sports' exists
    When I send the command 'list'
    Then I should receive a message that contains "You are not subscribed to any channels. Available channels: 1) sports"

  Scenario: User with subscriptions
    Given a channel 'sports' exists 
    And I am a user with a subscription to 'sports' 
    When I send the command 'list'
    Then I should receive a message that contains "You are subscribed to: 1) sports"
    
  Scenario: User with subscriptions and available channels
    Given a channel 'sports' exists 
    And a channel 'ducks' exists
    And I am a user with a subscription to 'sports' 
    When I send the command 'list'
    Then I should receive a message that contains "You are subscribed to: 1) sports. Available channels: 2) ducks"