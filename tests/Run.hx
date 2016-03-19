package;

import travis.Travis;

class Run {

  static function main() {
    return Sys.command('php', ['--version']);
  }
  
}