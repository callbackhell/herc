require 'spec_helper'
describe Herc::Task do
  it "has a description" do
    description = "Make the test pass"
    Herc::Task.new(description).description.should == description
  end

  it "can be serialized as JSON" do
    description = "Make the test pass"
    Herc::Task.new(description).to_json.should == {:description => description}.to_json
  end

  it "can be instantiated from a JSON serialization" do
    description = "Make the test pass"
    Herc::Task.from_json({:description => description}.to_json).description.should == description
  end

  it "is equal to another task if it has the same description" do
    description = "make the test pass"
    t1 = Herc::Task.new(description)
    t2 = Herc::Task.new(description)
    t1.should == t2
  end

  it "has the same hash code as another task with the same description" do
    description = "make the test pass"
    t1 = Herc::Task.new(description)
    t2 = Herc::Task.new(description)
    t1.hash.should == t2.hash
  end

  it "maintains a list of all saved tasks" do
    description1 = "Make the test pass"
    description2 = "Then refactor"
    task1 = Herc::Task.new(description1)
    task2 = Herc::Task.new(description2)
    Herc::Task.all.should == []
    task1.save
    Herc::Task.all.should == [task1]
    task2.save
    Herc::Task.all.should == [task1, task2]
  end

  it "persists the tasks list in redis" do
    description = "Make the test pass"
    redis = mock
    Redis.stubs(:new).returns(redis)
    task = Herc::Task.new(description)
    redis.expects(:rpush).with('tasks', task.to_json)
    task.save
  end
end
