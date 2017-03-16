package travix.commands;

import sys.io.*;

class ReleaseCommand extends Command {
  
  override function execute() {
    if(new Process('haxelib', ['path', 'travix_release']).exitCode() != 0) {
      exec('haxelib', ['install', 'travix_release']);
    }
    exec('haxelib', ['run', 'travix_release'].concat(this.args));
  }
}