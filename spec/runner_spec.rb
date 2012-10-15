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
      output ="1 - Make the test pass\n2 - Then refactor"
      Herc::Runner.expects(:puts).with(output)
      Herc::Runner.run('list_tasks')
    end
  end

  describe "running the create_user command" do
    it "creates a user with the given name" do
      name = "Tim"
      Herc::User.expects(:new).with(name).returns(stub(:save => true))
      Herc::Runner.run('create_user', name)
    end
    it "saves the user in the database" do
      name = "Tim"
      user = mock
      user.expects(:save)
      Herc::User.stubs(:new).returns(user)
      Herc::Runner.run('create_user', name)
    end
  end

  describe "running the list_users command" do
    it "outputs a list of all the users in the database" do
      user1 = Herc::User.new("Tim")
      user2 = Herc::User.new("Tom")
      Herc::User.stubs(:all).returns([user1,user2])
      output =" - Tim\n - Tom"
      Herc::Runner.expects(:puts).with(output)
      Herc::Runner.run('list_users')
    end
  end
end
