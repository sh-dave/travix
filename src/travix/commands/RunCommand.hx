package travix.commands;

using sys.io.File;
using sys.FileSystem;

class RunCommand extends Command {
  
  @:command public var cs = new RunCsCommand();
  @:command public var node = new RunNodeCommand();

  @:defaultCommand
  public function help() {
    trace('todo');
  }
}
