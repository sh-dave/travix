package travix.commands;

import tink.cli.Rest;

using sys.io.File;
using sys.FileSystem;

class JsCommand extends Command {

  static inline var PHANTOMJS_VERISON = 'phantomjs-2.1.1-linux-x86_64';

  public function install() {

    if(Travix.isTravis) {
      if(Travix.isLinux) {
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

          exec('wget', ['https://github.com/Medium/phantomjs/releases/download/v2.1.1/$PHANTOMJS_VERISON.tar.bz2']);
          exec('tar', ['xvjf', '$PHANTOMJS_VERISON.tar.bz2']);

        });
      }
      
      if(Travix.isMac || Travix.isWindows) {
        installPackage('phantomjs');
      }
    }
  }

  public function buildAndRun(rest:Rest<String>) {

    build('js', ['-js', 'bin/js/tests.js'].concat(rest), function () {
      var index = 'bin/js/index.html';
      if(!index.exists()) index.saveContent(defaultIndexHtml());
      var runPhantom = 'bin/js/runPhantom.js';
      if(!runPhantom.exists()) runPhantom.saveContent(defaultPhantomScript());
      var phantomjsBinPath = Travix.isLinux ? '$PHANTOMJS_VERISON/bin/phantomjs' : 'phantomjs';
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