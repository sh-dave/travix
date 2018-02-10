package travix.commands;

using sys.FileSystem;

class NodeCommand extends Command {
  
  static var VERSION_RE = ~/^v?(\d{1,})\.\d{1,}\.\d{1,}$/;
  
  override function execute() {
    if (Travix.isTravis && Travix.isMac) {
        // TODO: remove this when travis decided to update their stock node version
        foldOutput('upgrade-nodejs', function() {
          switch tryToRun('node', ['-v']) {
            case Success(v) if(VERSION_RE.match(v) && Std.parseInt(VERSION_RE.matched(1)) >= 4): // do nothing
            default:
                exec('brew', ['update']);
                exec('brew', ['upgrade', 'node']);
          }
        });
    }
    installLib('hxnodejs');
    
    build(['-js', 'bin/node/tests.js', '-lib', 'hxnodejs'], function () {
      if(Travix.isCI && 'bin/node/package.json'.exists()) {
        foldOutput('npm-install', withCwd.bind('bin/node', exec.bind('npm', ['install'])));
      }
      exec('node', ['bin/node/tests.js']);
    });
  }
}