package travix.commands;

class InstallCsCommand extends Command {
  @:defaultCommand
  public function doIt() {
    trace('install cs');
    if (Travix.isMac) {

      installPackage('mono');

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

      installPackage('mono-devel');
      installPackage('mono-mcs');

      // print the effective mono version
      exec('mono', ['-V']);
    }
  }
}