import manurip/cmdparser;
import ballerina/io;

public function main(string... args) {
    cmdparser:Command[] createdCommands = createCommands();
	cmdparser:CommandLineParser cmdParser = new(...createdCommands);

    cmdParser.parse(args);
}

function createCommands() returns cmdparser:Command[] {
    cmdparser:Command subsubcmd = { name: "mysubsubcmd", description: "my subsubcmd description", task: helloFunc };
    map<cmdparser:Command> subsubCmds = {};
    subsubCmds[subsubcmd.name] = subsubcmd;

    cmdparser:Command subcmd = { name: "mysubcmd", description: "my subcmd description", task: helloFunc, allowedSubCommands: subsubCmds };

    map<cmdparser:Command> subCmds = {};
    subCmds[subcmd.name] = subcmd;
    cmdparser:Command cmd = { name: "mycmd", description: "my description", task: helloFunc, allowedSubCommands: subCmds };

    return [ cmd ];
}

function helloFunc(cmdparser:Command currentCommand, map<string> flags) {
  io:println(currentCommand.name);
  foreach var [i, j] in flags.entries() {
     io:println(i);
     io:println(j);
  }
}
