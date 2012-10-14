require 'spec_helper'
describe Herc::Runner do
  describe "running the create_task command" do
    it "creates a new task with the given description" do
      description = "Make the test pass"
      Herc::Task.expects(:new).with(description).returns(stub(:save => true))
      Herc::Runner.run('create_task', description)
    end
    it "saves the task in the database" do
      description = "Make the test pass"
      task = mock
      task.expects(:save)
      Herc::Task.stubs(:new).returns(task)
      Herc::Runner.run('create_task', description)
    end
  end

  describe "running the list_tasks command" do
    it "outputs a list of all the tasks in the database" do
      task1 = Herc::Task.new("Make the test pass")
      task2 = Herc::Task.new("Then refactor")
      Herc::Task.stubs(:all).returns([task1,task2])
      output =" - Make the test pass\n - Then refactor"
      Herc::Runner.expects(:puts).with(output)
      Herc::Runner.run('list_tasks')
    end
  end
end
