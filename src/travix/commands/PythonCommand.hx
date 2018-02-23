package travix.commands;

import tink.cli.Rest;

class PythonCommand extends Command {

  public function install() {
    
  }

  public function buildAndRun(rest:Rest<String>) {
    build('python', ['-python', 'bin/python/tests.py'].concat(rest), function () {
      if (tryToRun('python3', ['--version']).match(Failure(_, _))) {
        installPackage('python3');
      }
      exec('python3', ['bin/python/tests.py']);
    });
  }
}
