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

  describe "running the list_unassigned_tasks command" do
    it "outputs a list of all the unassigned tasks in the database" do
      task1 = Herc::Task.new("Make the test pass")
      task2 = Herc::Task.new("Then refactor")
      Herc::Task.stubs(:unassigned).returns([task1,task2])
      output ="1 - Make the test pass\n2 - Then refactor"
      Herc::Runner.expects(:puts).with(output)
      Herc::Runner.run('list_unassigned_tasks')
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

  describe "running the assign_task command" do
    it "gets the named user" do
      name="Tim"
      user = stub(:assign_task => nil)
      Herc::User.expects(:by_name).with("Tim").returns(user)
      Herc::Runner.run("assign_task", "1", "Tim")
    end

    it "gets the task at the given index minus 1 in the unassigned tasks list" do
      task_list = mock
      task_list.expects(:[]).with(0)
      user = stub(:assign_task => nil)
      Herc::User.stubs(:by_name).returns(user)
      Herc::Task.expects(:unassigned).returns(task_list)
      Herc::Runner.run("assign_task", "1", "Tim")
    end

    it "assigns the task to the user" do
      user = mock
      task = mock
      Herc::User.stubs(:by_name).returns(user)
      Herc::Task.stubs(:unassigned).returns([task])
      user.expects(:assign_task).with(task)
      Herc::Runner.run("assign_task", "1", "Tim")
    end
  end

  describe "running the list_tasks_for command" do
    it "gets the named user" do
      name="Tim"
      user = stub(:tasks => [])
      Herc::User.expects(:by_name).with("Tim").returns(user)
      Herc::Runner.run("list_tasks_for", "Tim")
    end

    it "outputs a list of the tasks for the given user" do
      user = mock
      user.expects(:tasks).returns([Herc::Task.new("Create more horror")])
      Herc::User.stubs(:by_name).returns(user)
      Herc::Runner.expects(:puts).with(" - Create more horror")
      Herc::Runner.run("list_tasks_for", "Tim")
    end
  end
end
