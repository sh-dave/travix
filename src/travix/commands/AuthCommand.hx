package travix.commands;

import sys.io.*;

class AuthCommand extends Command {
  
  override function execute() {
    if(!libInstalled('travix_auth')) {
      installLib('travix_auth');
    }
    exec('haxelib', ['run', 'travix_auth'].concat(this.args));
  }
}