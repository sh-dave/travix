package travix.commands;

import tink.cli.Rest;

using sys.FileSystem;

class RunNodeCommand extends Command {
  
  @:defaultCommand
  public function doIt(rest:Rest<String>) {
    installLib('hxnodejs');
    
    build('node', ['-js', 'bin/node/tests.js', '-lib', 'hxnodejs'].concat(rest), function () {
      if(Travix.isCI && 'bin/node/package.json'.exists()) {
        foldOutput('npm-install', withCwd.bind('bin/node', exec.bind('npm', ['install'])));
      }
      exec('node', ['bin/node/tests.js']);
    });
  }
}