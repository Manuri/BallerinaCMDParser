public type Command record {
    string name;
    string description;
    function (Command, map<string>) task;
    map<Command> allowedSubCommands?;
    //string[] allowedFlags;
};
