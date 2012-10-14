Given /^an empty task database$/ do
  require 'redis'
  r = Redis.new
  r.del('tasks')
  r.del('users')
end

When /^I create a task "(.*?)"$/ do |description|
  run_simple(%{herc create_task "#{description}"})
end

Then /^I should see the task "(.*?)" in the task list$/ do |description|
  command = %{herc list_tasks}
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
