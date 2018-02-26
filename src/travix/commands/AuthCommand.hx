package travix.commands;

import tink.cli.Rest;

class AuthCommand extends Command {
  
  @:defaultCommand
  public function doIt(rest:Rest<String>) {
    if(!libInstalled('travix_auth')) {
      installLib('travix_auth');
    }
    exec('haxelib', ['run', 'travix_auth'].concat(rest));
  }
}