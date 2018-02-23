package travix.commands;

import tink.cli.Rest;
import Sys.*;

using StringTools;

class CppCommand extends Command {

  public function install() {
    if (getEnv('TRAVIS_HAXE_VERSION') == 'development') {
      if(Travix.isLinux) {
          installPackage('gcc-multilib');
          installPackage('g++-multilib');
      }
    }
  }

  public function buildAndRun(rest:Rest<String>) {
    if (getEnv('TRAVIS_HAXE_VERSION') == 'development') {
      if (!libInstalled('hxcpp')) {
        foldOutput('git-hxcpp', function() {
          exec('haxelib', ['git', 'hxcpp', 'https://github.com/HaxeFoundation/hxcpp.git']);
          withCwd(run('haxelib', ['path', 'hxcpp']).split('\n')[0], buildHxcpp);
        });
      }
    }
    else installLib('hxcpp');
    
    var main = Travix.getMainClassLocalName();
    build('cpp', ['-cpp', 'bin/cpp'].concat(rest), function () {
      var outputFile = main + (isDebugBuild(rest) ? '-debug' : '') + (Travix.isWindows ? '.exe' : '');
      var path = './bin/cpp/$outputFile';
      if(Travix.isWindows) path = path.replace('/', '\\');
      exec(path);
    });
  }

  function buildHxcpp() {
    withCwd('tools/hxcpp', exec.bind('haxe', ['compile.hxml']));
    withCwd('project', exec.bind('neko', ['build.n']));
  }
}
