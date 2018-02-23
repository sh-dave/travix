package travix.commands;

using sys.io.File;
using sys.FileSystem;

class JsCommand extends Command {


  override function execute() {

    var phantomjs = 'phantomjs';

    if(Travix.isTravis) {
      if(Travix.isMac) {
        installPackage('phantomjs');
      } else if(Travix.isLinux) {
        var PHANTOM_JS = "phantomjs-2.1.1-linux-x86_64";

        foldOutput('phantomjs-update', function() {
          installPackages([
            'build-essential',
            'chrpath',
            'libfontconfig1',
            'libfontconfig1-dev',
            'libfreetype6',
            'libfreetype6-dev',
            'libssl-dev',
            'libxft-dev'
          ]);

          exec('wget', ['https://github.com/Medium/phantomjs/releases/download/v2.1.1/$PHANTOM_JS.tar.bz2']);
          exec('tar', ['xvjf', '$PHANTOM_JS.tar.bz2']);

          phantomjs = '$PHANTOM_JS/bin/phantomjs';
        });
      }
    }

  }

}
