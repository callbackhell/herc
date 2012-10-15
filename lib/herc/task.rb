require 'json'
require 'json/add/core'
require 'redis'


class Herc::Task
  class << self
    def unassigned
      redis.lrange('tasks',0, -1).map {|h| self.from_json(h) }
    end

    def redis
      Redis.new
    end

    def from_json(json)
      hash = JSON.parse(json)
      self.new(hash['description'])
    end
  end
  attr_reader :description

  def initialize(description)
    @description=description
  end

  def ==(other)
    description == other.description

  end

  def hash
    description.hash
  end

  def to_json(*a)
    { :description => @description }.to_json(*a)
  end

  def save
    self.class.redis.rpush('tasks', self.to_json)
  end
end
