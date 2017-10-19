package travix.commands;

class PythonCommand extends Command {

  override function execute() {
    build(['-python', 'bin/python/tests.py'], function () {
      if (tryToRun('python3', ['--version']).match(Failure(_, _))) {
        if (Travix.isMac)
          exec('brew', ['update']); // to prevent "Homebrew must be run under Ruby 2.3!" https://github.com/travis-ci/travis-ci/issues/8552#issuecomment-335321197
        aptGet('python3');
      }
      exec('python3', ['bin/python/tests.py']);
    });
  }
}