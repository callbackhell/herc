require 'herc'
RSpec.configure do |config|
  config.mock_framework = :mocha
  config.before {
    r = Redis.new
    r.del('tasks')
  }
end
