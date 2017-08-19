package travix.commands;

class CsCommand extends Command {

  override function execute() {

    if (Travix.isMac) {

      aptGet('mono');

    } else if (Travix.isLinux) {

      // http://www.mono-project.com/download/#download-lin
      exec('eval', ['sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF']);
      switch tryToRun('lsb_release', ['-cs']) {
        case Success('precise\n'):
          exec('eval', ['echo "deb http://download.mono-project.com/repo/ubuntu precise main" | sudo tee /etc/apt/sources.list.d/mono-official.list']);
        case Success('trusty\n'):
          exec('eval', ['echo "deb http://download.mono-project.com/repo/ubuntu trusty main" | sudo tee /etc/apt/sources.list.d/mono-official.list']);
        case Success('xenial\n'):
          exec('eval', ['echo "deb http://download.mono-project.com/repo/ubuntu xenial main" | sudo tee /etc/apt/sources.list.d/mono-official.list']);
        default:
      }
      exec('eval', ['sudo apt-get update']);

      aptGet('mono-devel');
      aptGet('mono-mcs');

      // print the effective mono version
      exec('mono', ['-V']);
    }

    var main = Travix.getMainClassLocalName();

    installLib('hxcs');

    build(['-cs', 'bin/cs/'], function () {
      var outputFile = main + (isDebugBuild() ? '-Debug' : '');
      if (Travix.isWindows)
        exec('bin\\cs\\bin\\$outputFile.exe');
      else
        exec('mono', ['bin/cs/bin/$outputFile.exe']);
    });
  }
}
