Feature: scheduling tasks
  In order to organise my team's workload
  As a manager
  I want to create and assign tasks to team members

  Scenario: Creating a task
    Given an empty task database
    When I create a task "Implement the first feature"
    Then I should see the task "Implement the first feature" in the unassigned tasks list

  Scenario: Creating a user
    Given an empty task database
    When I create a user "Tim"
    Then I should see the user "Tim" in the user list

  Scenario: Assigning a task to a user
    Given an empty task database
    And a user named "Tim"
    And a task with description "Do some work, Tim!"
    When I assign the task "Do some work, Tim!" to "Tim"
    Then The task "Do some work, Tim!" should appear in "Tim"'s task list
