package travix.commands;

import tink.cli.Rest;

class RunCsCommand extends Command {
  
  @:defaultCommand
  public function doIt(rest:Rest<String>) {
    var main = Travix.getMainClassLocalName();

    installLib('hxcs');

    build('cs', ['-cs', 'bin/cs/'].concat(rest), function () {
      var outputFile = main + (isDebugBuild(rest) ? '-Debug' : '');
      if (Travix.isWindows)
        exec('bin\\cs\\bin\\$outputFile.exe');
      else
        exec('mono', ['bin/cs/bin/$outputFile.exe']);
    });
  }
}