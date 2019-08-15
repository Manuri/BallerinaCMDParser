import ballerina/log;

const string FLAG_PREFIX = "++";
const string FLAG_KEY_VAL_SEPERATOR = "=";

public type CommandLineParser object {
    map<Command> commands = {};

    public function __init(Command... commands) {
        foreach Command comm in commands {
            self.commands[comm.name] = comm;
        }
    }

    public function parse(string[] args) {
        error? e = self.parseInternal(args);
        if (!(e is ())) {
          log:printError(e.reason());
        }
    }

    private function parseInternal(string[] args) returns error? {
		int argsLength = args.length();

        int argIndex = 0;
        string commandName = args[argIndex];
        Command? currentCommand = self.commands.get(commandName);
        if (currentCommand is ()) {
            error e = error("There aren't any commands");
            return e;
        } else {
            argIndex = argIndex + 1;
            while(argIndex < argsLength) {
               commandName = args[argIndex];
               if (commandName.startsWith(FLAG_PREFIX)) {
                   break;
               }
               map<Command>? commandsMap = currentCommand?.allowedSubCommands;
               if (commandsMap is map<Command>) {
                 currentCommand = currentCommand?.allowedSubCommands[commandName];
                 argIndex = argIndex + 1;
               } else {
                 error e = error("Invalid token: " + commandName);
                 return e;
               }
            }
        }

        if (currentCommand is ()) {
            error e = error("There aren't any commands");
            return e;
        } else {
            commandName = args[argIndex];
            map<string> flags = {};
            while (argIndex < argsLength) {
                string flag = args[argIndex];
                if (!flag.startsWith(FLAG_PREFIX)) {
                   error e = error("Invalid token: " + flag);
                   return e;
                }
                int? equalIndex = flag.indexOf(FLAG_KEY_VAL_SEPERATOR);
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
