package;

import travis.Travis;

class Run {

  static function main() {
    Sys.exit(Sys.command('php', ['--version']));
  }
  
}