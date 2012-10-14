Feature: scheduling tasks
  In order to organise my team's workload
  As a manager
  I want to create and assign tasks to team members

  Scenario: Creating a task
    Given an empty task database
    When I create a task "Implement the first feature"
    Then I should see the task "Implement the first feature" in the task list
