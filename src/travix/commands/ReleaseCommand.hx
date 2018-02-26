package travix.commands;

import tink.cli.Rest;

class ReleaseCommand extends Command {
  
  @:defaultCommand
  public function doIt(rest:Rest<String>) {
    if(!libInstalled('travix_release')) {
      installLib('travix_release');
    }
    exec('haxelib', ['run', 'travix_release'].concat(rest));
  }
}