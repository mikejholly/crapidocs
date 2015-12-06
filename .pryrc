if defined?(PryByebug)
  cmds = %w(continue step next finish up)
  cmds.each { |cmd| Pry.commands.alias_command cmd[0], cmd }
end
