package travix.commands;

class JavaCommand extends Command {
  
  override function execute() {
    var main = Travix.getMainClassLocalName();
    
    installLib('hxjava');
    
    build(['-java', 'bin/java'], function () {
      var outputFile = main + (isDebugBuild() ? '-Debug' : '');
      exec('java', ['-jar', 'bin/java/$outputFile.jar']);
    });
  }
}