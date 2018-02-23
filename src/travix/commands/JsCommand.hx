package travix.commands;

import tink.cli.Rest;

using sys.io.File;
using sys.FileSystem;

class JsCommand extends Command {

  static var phantomjsVersion = "phantomjs-2.1.1-linux-x86_64";
  static var phantomjsBinPath = '$phantomjsVersion/bin/phantomjs';

  public function install() {

    if(Travix.isTravis) {
      if(Travix.isMac) {
        installPackage('phantomjs');
      } else if(Travix.isLinux) {
        var phantomjsVersion = "phantomjs-2.1.1-linux-x86_64";

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

          exec('wget', ['https://github.com/Medium/phantomjs/releases/download/v2.1.1/$phantomjsVersion.tar.bz2']);
          exec('tar', ['xvjf', '$phantomjsVersion.tar.bz2']);

        });
      }
    }
  }

  public function buildAndRun(rest:Rest<String>) {

    build('js', ['-js', 'bin/js/tests.js'].concat(rest), function () {
      var index = 'bin/js/index.html';
      if(!index.exists()) index.saveContent(defaultIndexHtml());
      var runPhantom = 'bin/js/runPhantom.js';
      if(!runPhantom.exists()) runPhantom.saveContent(defaultPhantomScript());
      exec(phantomjsBinPath, ['-v']);
      exec(phantomjsBinPath, ['--web-security=no', runPhantom]);
    });
  }

  macro static function defaultIndexHtml() {
    return Macro.loadFile('js/index.html');
  }
  macro static function defaultPhantomScript() {
    return Macro.loadFile('js/runPhantom.js');
  }
}