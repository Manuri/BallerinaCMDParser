import manuri/parser;
import ballerina/io;

public function main(string... args) {
    //parser:Command subsubcmd = { name: "mysubsubcmd", description: "my subsubcmd description", task: helloFunc };
    //map<parser:Command> subsubCmds = {};
    //subsubCmds[subsubcmd.name] = subsubcmd;
    //
	//parser:Command subcmd = { name: "mysubcmd", description: "my subcmd description", task: helloFunc, allowedSubCommands: subsubCmds };
    //
	//map<parser:Command> subCmds = {};
	//subCmds[subcmd.name] = subcmd;
	//parser:Command cmd = { name: "mycmd", description: "my description", task: helloFunc, allowedSubCommands: subCmds };

    parser:Command[] createdCommands = createCommands();
	parser:CommandLineParser cmdParser = new(...createdCommands);

    cmdParser.parse(args);
}

function createCommands() returns parser:Command[] {
    parser:Command subsubcmd = { name: "mysubsubcmd", description: "my subsubcmd description", task: helloFunc };
    map<parser:Command> subsubCmds = {};
    subsubCmds[subsubcmd.name] = subsubcmd;

    parser:Command subcmd = { name: "mysubcmd", description: "my subcmd description", task: helloFunc, allowedSubCommands: subsubCmds };

    map<parser:Command> subCmds = {};
    subCmds[subcmd.name] = subcmd;
    parser:Command cmd = { name: "mycmd", description: "my description", task: helloFunc, allowedSubCommands: subCmds };

    return [ cmd ];
}

function helloFunc(parser:Command currentCommand, map<string> flags) {
  io:println(currentCommand.name);
  foreach var [i, j] in flags.entries() {
     io:println(i);
     io:println(j);
  }
}
