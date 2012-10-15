Given /^an empty task database$/ do
  require 'redis'
  r = Redis.new
  r.del('tasks')
  r.del('users')
end

When /^I create a task "(.*?)"$/ do |description|
  run_simple(%{herc create_task "#{description}"})
end

Then /^I should see the task "(.*?)" in the unassigned tasks list$/ do |description|
  command = %{herc list_unassigned_tasks}
  run_simple(command)
  assert_partial_output(description, output_from(command))
end

When /^I create a user "(.*?)"$/ do |name|
  run_simple(%{herc create_user "#{name}"})
end

Then /^I should see the user "(.*?)" in the user list$/ do |name|
  command = %{herc list_users}
  run_simple(command)
  assert_partial_output(name, output_from(command))
end

Given /^a user named "(.*?)"$/ do |name|
  Herc::User.new(name).save
end

Given /^a task with description "(.*?)"$/ do |description|
  Herc::Task.new(description).save
end

When /^I assign the task "(.*?)" to "(.*?)"$/ do |description, name|
  list_command = %{herc list_unassigned_tasks}
  run_simple(list_command)
  list = output_from(list_command)
  number = list.match(/(\d+) - #{description}/)[1]
  run_simple(%{herc assign_task #{number} #{name}})
end

Then /^The task "(.*?)" should appear in "(.*?)"'s task list$/ do |description, name|
  command = %{herc list_tasks_for #{name}}
  run_simple(command)
  assert_partial_output(description, output_from(command))
end
