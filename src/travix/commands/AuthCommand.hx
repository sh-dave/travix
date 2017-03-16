package travix.commands;

import sys.io.*;

class AuthCommand extends Command {
  
  override function execute() {
    if(new Process('haxelib', ['path', 'travix_auth']).exitCode() != 0) {
      exec('haxelib', ['install', 'travix_auth']);
    }
    exec('haxelib', ['run', 'travix_auth'].concat(this.args));
  }
}