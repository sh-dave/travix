package;

import travis.Travis;

class Run {

  static function main() {
    trace('yo');
    return Sys.command('php', ['--version']);
  }
  
}