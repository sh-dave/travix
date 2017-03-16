package travix.commands;

import sys.io.*;

class ReleaseCommand extends Command {
  
  override function execute() {
    if(!libInstalled('travix_release')) {
      installLib('travix_release');
    }
    exec('haxelib', ['run', 'travix_release'].concat(this.args));
  }
}