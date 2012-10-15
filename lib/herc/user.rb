class Herc::User

  class << self
    def all
      self.redis.hvals('users').map {|json| self.from_json(json) }
    end

    def by_name(name)
      json = self.redis.hget('users', name)
      json ? self.from_json(json) : json
    end

    def from_json(json)
      hash = JSON.parse(json)
      self.new(hash['name'])
    end

    def redis
      Redis.new
    end
  end

  def initialize(name)
    @name = name
  end

  def ==(other)
    self.name == other.name
  end

  def hash
    self.name.hash
  end

  def save
    self.class.redis.hset('users', self.name, self.to_json)
  end

  def to_json(*args)
    {:name => @name}.to_json(*args)
  end

  def assign_task(task)
    self.class.redis.rpush("tasks_#{self.name}", task.to_json)
  end

  def tasks
    self.class.redis.lrange("tasks_#{self.name}", 0, -1).map {|json| Herc::Task.from_json(json)}
  end

  attr_reader :name
end
