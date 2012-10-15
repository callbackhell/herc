require 'spec_helper'
describe Herc::User do
  it "has a name" do
    name = "Tim"
    Herc::User.new(name).name.should == name
  end

  it "can be serialized as JSON" do
    name = "Tim"
    Herc::User.new(name).to_json.should == {:name => name}.to_json
  end

  it "can create objects from a JSON serialization" do
    Herc::User.from_json({:name => "Tim"}.to_json).name.should == "Tim"
  end

  it "is equal to another user if they have the same name" do
    Herc::User.new("Tim").should == Herc::User.new("Tim")
  end

  it "is not equal to another user with a different name" do
    Herc::User.new("Tim").should_not == Herc::User.new("Tom")
  end

  it "has the same hash code as another user if they have the same name" do
    Herc::User.new("Tim").hash.should == Herc::User.new("Tim").hash
  end

  it "has a different hash code as another user if they have a different name" do
    Herc::User.new("Tim").hash.should_not == Herc::User.new("Tom").hash
  end

  it "maintains a list of all saved users" do
    name1 = "Tim"
    name2 = "Tom"
    user1 = Herc::User.new(name1)
    user2 = Herc::User.new(name2)
    Herc::User.all.should == []
    user1.save
    Herc::User.all.should == [user1]
    user2.save
    Herc::User.all.should == [user1, user2]
  end

  it "persists the user list in redis" do
    name = "Tim"
    redis = mock
    Redis.stubs(:new).returns(redis)
    user = Herc::User.new(name)
    redis.expects(:hset).with('users', user.name, user.to_json)
    user.save
  end

  it "retrieves the user list from redis" do
    results = [Herc::User.new("Tim")]
    redis = mock
    redis.expects(:hvals).with('users').returns(results.map(&:to_json))
    Redis.stubs(:new).returns(redis)
    Herc::User.all.should == results
  end

  it "retrieves users by name from redis" do
    user = Herc::User.new("Tim")
    redis = mock
    redis.expects(:hget).with('users', 'Tim').returns(user.to_json)
    Redis.stubs(:new).returns(redis)
    Herc::User.by_name("Tim").should == user
  end

  it "returns nil when retrieving users by name, if a user with the given name does not exist" do
    redis = mock
    redis.expects(:hget).with('users', 'Tim').returns(nil)
    Redis.stubs(:new).returns(redis)
    Herc::User.by_name("Tim").should be_nil
  end

  it "has a list of assigned tasks" do
    user = Herc::User.new("Tim")
    task = Herc::Task.new("Write some really bad software")
    user.assign_task(task)
    user.tasks.should include(task)
  end

  it "persists the users task list in redis" do
    redis = mock
    Redis.stubs(:new).returns(redis)
    user = Herc::User.new("Tim")
    task = Herc::Task.new("Write some really bad software")
    redis.expects(:rpush).with('tasks_Tim', task.to_json)
    user.assign_task(task)
  end

  it "retrieves the users task list from redis" do
    redis = mock
    Redis.stubs(:new).returns(redis)
    user = Herc::User.new("Tim")
    task = Herc::Task.new("Write some really bad software")
    redis.expects(:lrange).with('tasks_Tim', 0, -1).returns([task.to_json])
    user.tasks
  end
end
