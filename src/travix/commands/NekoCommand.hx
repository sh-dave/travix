package travix.commands;

import tink.cli.Rest;

class NekoCommand extends Command {
  
  public function install() {
    
  }

  public function buildAndRun(rest:Rest<String>) {
    build('neko', ['-neko', 'bin/neko/tests.n'].concat(rest), function () {
      exec('neko', ['bin/neko/tests.n']);
    });
  }
}