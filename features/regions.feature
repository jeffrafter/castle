Feature: Regions
  As an administrator
  I want to be able to add and remove regions
  So that I can set up the feeds for those regions
 
  Scenario: Regions listed
    Given I am an administrator
    When I go to the "/regions" page
    Then I should see the current regions
    And I should see "New Region"