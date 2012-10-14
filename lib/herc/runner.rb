module Herc::Runner
  class << self
    def run(command, *args)
      case command
      when 'create_task'
        task = Herc::Task.new(args[0])
        task.save
      when 'list_tasks'
        puts Herc::Task.all.map {|t| " - #{t.description}"}.join("\n")
      when 'create_user'
        user = Herc::User.new(args[0])
        user.save
      when 'list_users'
        puts Herc::User.all.map {|u| " - #{u.name}"}.join("\n")
      end
    end
  end
end
