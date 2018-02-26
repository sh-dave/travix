package travix.commands;

import tink.cli.Rest;

class JavaCommand extends Command {
  
  public function install() {
    
  }

  public function buildAndRun(rest:Rest<String>) {
    var main = Travix.getMainClassLocalName();
    
    installLib('hxjava');
    
    build('java', ['-java', 'bin/java'].concat(rest), function () {
      var outputFile = main + (isDebugBuild(rest) ? '-Debug' : '');
      exec('java', ['-jar', 'bin/java/$outputFile.jar']);
    });
  }
}