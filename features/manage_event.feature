@javascript @management
Feature: managing an event

  Background:
    Given the following events exist:
      | Name | Description | City    | State    | Country | Price | Capacity | Starts_at  | Ends_at    | slug | additional_info |
      | Test | Test Event  | Holland | Michigan | US      | 30.00 | 45       | 2012-01-01 | 2012-01-02 | test |                 |

  Scenario: Change event attributes
    Given I am logged in as "admin/password"
    And I follow "Test" within the event list
    When I fill in the following:
      | Name        | Collective Idea |
      | Description | Initial event   |
    And I press "Update"
    Then I should see "Updated Successfully"

  Scenario: Name can't be blank
    Given I am logged in as "admin/password"
    And I follow "Test" within the event list
    When I fill in "Name" with ""
    And I press "Update"
    Then I should see errors

  Scenario: No lodging information set
    Given I am logged in as "admin/password"
    And I follow "Test" within the event list
    When I fill in "Additional Info" with ""
    And I press "Update"
    And I goto the home page
    Then I should see "More information coming soon!" within important details
