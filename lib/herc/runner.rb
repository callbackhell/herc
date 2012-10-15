module Herc::Runner
  class << self
    def run(command, *args)
      case command
      when 'create_task'
        task = Herc::Task.new(args[0])
        task.save
      when 'list_unassigned_tasks'
        puts Herc::Task.unassigned.each.with_index.map {|t, i| "#{i+1} - #{t.description}"}.join("\n")
      when 'create_user'
        user = Herc::User.new(args[0])
        user.save
      when 'list_users'
        puts Herc::User.all.map {|u| " - #{u.name}"}.join("\n")
      when 'assign_task'
        user = Herc::User.by_name(args[1])
        task = Herc::Task.unassigned[args[0].to_i - 1]
        user.assign_task(task)
      when 'list_tasks_for'
        user = Herc::User.by_name(args[0])
        puts user.tasks.map {|t| " - #{t.description}"}.join("\n")
      end
    end
  end
end
