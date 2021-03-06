@javascript @payment
Feature: Registration
  Background:
    Given the following event exists:
      | name   | price |
      | Boston | 30.00 |
    And it is "March 1, 2012"

  Scenario: Successful registration
    Given I am on the homepage
    When I follow "Register"
    Then I should be on the "Boston" registration page

    When I fill in the following:
      | First Name         | Steve                   |
      | Last Name          | Richert                 |
      | Email              | steve.richert@gmail.com |
      | Credit Card Number | 4242424242424242        |
      | CVC                | 123                     |
    And I select "01 - January" from "Expiration Date"
    And I select "2020" from "credit_card_year"
    And I press "Register"
    And I wait for payment processing
    Then I should see "Thank you"
    And I should be on the "Boston" event page
    And I should see "Steve Richert" registered for the event
    And $30.00 should have been charged
    And an email should have been sent to "steve.richert@gmail.com"

  Scenario: Hidden registration
    Given I am on the "Boston" registration page
    When I fill in the following:
      | First Name         | Steve                   |
      | Last Name          | Richert                 |
      | Email              | steve.richert@gmail.com |
      | Credit Card Number | 4242424242424242        |
      | CVC                | 123                     |
    And I select "01 - January" from "Expiration Date"
    And I select "2020" from "credit_card_year"
    And I check "Please do not show my name in the list of attendees."
    And I press "Register"
    And I wait for payment processing
    Then I should see "Thank you"
    And I should be on the "Boston" event page
    And I should not see "Steve Richert" registered for the event
    And $30.00 should have been charged
    And an email should have been sent to "steve.richert@gmail.com"

  Scenario: Missing first name
    Given I am on the "Boston" registration page
    When I fill in the following:
      | First Name         |                         |
      | Last Name          | Richert                 |
      | Email              | steve.richert@gmail.com |
      | Credit Card Number | 4242424242424242        |
      | CVC                | 123                     |
    And I select "01 - January" from "Expiration Date"
    And I select "2020" from "credit_card_year"
    And I press "Register"
    And I wait for payment processing
    Then I should see errors
    And I should not see "Thank you"
    And $0.00 should have been charged

  Scenario: Missing last name
    Given I am on the "Boston" registration page
    When I fill in the following:
      | First Name         | Steve                   |
      | Last Name          |                         |
      | Email              | steve.richert@gmail.com |
      | Credit Card Number | 4242424242424242        |
      | CVC                | 123                     |
    And I select "01 - January" from "Expiration Date"
    And I select "2020" from "credit_card_year"
    And I press "Register"
    And I wait for payment processing
    Then I should see errors
    And I should not see "Thank you"
    And $0.00 should have been charged

  Scenario: Missing email
    Given I am on the "Boston" registration page
    When I fill in the following:
      | First Name         | Steve            |
      | Last Name          | Richert          |
      | Email              |                  |
      | Credit Card Number | 4242424242424242 |
      | CVC                | 123              |
    And I select "01 - January" from "Expiration Date"
    And I select "2020" from "credit_card_year"
    And I press "Register"
    And I wait for payment processing
    Then I should see errors
    And I should not see "Thank you"
    And $0.00 should have been charged

  Scenario: Invalid email
    Given I am on the "Boston" registration page
    When I fill in the following:
      | First Name         | Steve               |
      | Last Name          | Richert             |
      | Email              | steve.richert@gmail |
      | Credit Card Number | 4242424242424242    |
      | CVC                | 123                 |
    And I select "01 - January" from "Expiration Date"
    And I select "2020" from "credit_card_year"
    And I press "Register"
    And I wait for payment processing
    Then I should see errors
    And I should not see "Thank you"
    And $0.00 should have been charged

  Scenario: Declined credit card
    Given I am on the "Boston" registration page
    When I fill in the following:
      | First Name         | Steve                   |
      | Last Name          | Richert                 |
      | Email              | steve.richert@gmail.com |
      | Credit Card Number | 4000000000000002        |
      | CVC                | 123                     |
    And I select "01 - January" from "Expiration Date"
    And I select "2020" from "credit_card_year"
    And I press "Register"
    And I wait for payment processing
    Then I should see errors
    And I should not see "Thank you"
    And $0.00 should have been charged

  Scenario: Invalid credit card number
    Given I am on the "Boston" registration page
    When I fill in the following:
      | First Name         | Steve                   |
      | Last Name          | Richert                 |
      | Email              | steve.richert@gmail.com |
      | Credit Card Number | 4242424242424241        |
      | CVC                | 123                     |
    And I select "01 - January" from "Expiration Date"
    And I select "2020" from "credit_card_year"
    And I press "Register"
    And I wait for payment processing
    Then I should see errors
    And I should not see "Thank you"
    And $0.00 should have been charged

  Scenario: Past credit card expiration
    Given I am on the "Boston" registration page
    When I fill in the following:
      | First Name         | Steve                   |
      | Last Name          | Richert                 |
      | Email              | steve.richert@gmail.com |
      | Credit Card Number | 4242424242424242        |
      | CVC                | 123                     |
    And I select "01 - January" from "Expiration Date"
    And I select "2012" from "credit_card_year"
    And I press "Register"
    And I wait for payment processing
    Then I should see errors
    And I should not see "Thank you"
    And $0.00 should have been charged

  Scenario: Invalid CVC
    Given I am on the "Boston" registration page
    When I fill in the following:
      | First Name         | Steve                   |
      | Last Name          | Richert                 |
      | Email              | steve.richert@gmail.com |
      | Credit Card Number | 4242424242424242        |
      | CVC                | 99                      |
    And I select "01 - January" from "Expiration Date"
    And I select "2020" from "credit_card_year"
    And I press "Register"
    And I wait for payment processing
    Then I should see errors
    And I should not see "Thank you"
    And $0.00 should have been charged


  Scenario: Using a Coupon Code for $5
    Given the following coupons exist:
      | Event       | Code | Amount |
      | name:Boston | TEST | 5.00   |
    And I am on the "Boston" registration page
    When I fill in the following:
      | First Name         | Steve                   |
      | Last Name          | Richert                 |
      | Email              | steve.richert@gmail.com |
      | Coupon             | TEST                    |
      | Credit Card Number | 4242424242424242        |
      | CVC                | 999                     |
    Then I should see "$25.00"
    When I select "01 - January" from "Expiration Date"
    And I select "2020" from "credit_card_year"
    And I press "Register"
    And I wait for payment processing
    Then I should see "Thank you"
    And $25.00 should have been charged

  Scenario: Using a Coupon Code for greater then the cost should result in $0 charged
    Given the following coupons exist:
      | Event       | Code | Amount |
      | name:Boston | TEST | 35.00  |
    And I am on the "Boston" registration page
    When I fill in the following:
      | First Name         | Steve                   |
      | Last Name          | Richert                 |
      | Coupon             | TEST                    |
      | Email              | steve.richert@gmail.com |
    Then I should see "$0.00"
    And I press "Register"
    And I wait for payment processing
    Then I should see "Thank you"
    And $0.00 should have been charged
