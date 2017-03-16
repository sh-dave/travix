package travix.commands;

import Sys.*;

class ReleaseCommand extends Command {
  
  override function execute() {
    if(command('haxelib', ['path', 'travix_release'] != 0) {
      exec('haxelib', ['install', 'travix_release']);
    }
    exec('haxelib', ['run', 'travix_release']);
  }
}