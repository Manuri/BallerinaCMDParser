public type CommandLineParser object {
    map<Command> commands = {};

    public function __init(Command... commands) {
        foreach Command comm in commands {
            self.commands[comm.name] = comm;
        }
    }

    public function parse(string[] args) {
		int argsLength = args.length();

        int argIndex = 0;
        string commandName = args[argIndex];
        Command? currentCommand = self.commands.get(commandName);
        if (currentCommand is ()) {
            error e = error("There aren't any commands");
            panic e;
        } else {
            argIndex = argIndex + 1;
            while(argIndex < argsLength && !args[argIndex].startsWith("++")) {
               commandName = args[argIndex];
               map<Command>? commandsMap = currentCommand?.allowedSubCommands;
               if (commandsMap is map<Command>) {
                currentCommand = currentCommand?.allowedSubCommands[commandName];
                argIndex = argIndex + 1;
               } else {
                 error e = error("Invalid sub command: " + commandName);
                 panic e;
               }
            }
        }

        if (currentCommand is ()) {
            error e = error("There aren't any commands");
            panic e;
        } else {
            commandName = args[argIndex];
            map<string> flags = {};
            boolean subCommandPresent = true;
            while (argIndex < argsLength && args[argIndex].startsWith("++")) {
                subCommandPresent = false;
                string flag = args[argIndex];
                int? equalIndex = flag.indexOf("=");
                if (equalIndex is int) {
                    string key = flag.substring(2, equalIndex - 1);
                    string val = flag.substring(equalIndex + 1, flag.length());
                    flags[key] = val;
                }
                argIndex = argIndex + 1;
            }
            currentCommand.task(currentCommand, flags);
        }
	}
};
