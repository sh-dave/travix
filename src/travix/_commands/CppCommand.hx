package travix.commands;

import Sys.*;

using StringTools;

class CppCommand extends Command {

  override function execute() {
    var main = Travix.getMainClassLocalName();

    if (getEnv('TRAVIS_HAXE_VERSION') == 'development') {

      if(Travix.isLinux) {
          installPackage('gcc-multilib');
          installPackage('g++-multilib');
      }

      if (!libInstalled('hxcpp')) {
        foldOutput('git-hxcpp', function() {
          exec('haxelib', ['git', 'hxcpp', 'https://github.com/HaxeFoundation/hxcpp.git']);
          withCwd(run('haxelib', ['path', 'hxcpp']).split('\n')[0], buildHxcpp);
        });
      }
    }
    else installLib('hxcpp');

    build(['-cpp', 'bin/cpp'], function () {
      var outputFile = main + (isDebugBuild() ? '-debug' : '') + (Travix.isWindows ? '.exe' : '');
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
