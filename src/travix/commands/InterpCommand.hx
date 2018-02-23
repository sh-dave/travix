package travix.commands;

import tink.cli.Rest;

class InterpCommand extends Command {
  
  public function install() {
    
  }

  public function buildAndRun(rest:Rest<String>) {
    build('interp', ['--interp'].concat(rest), function () {});
  }
}