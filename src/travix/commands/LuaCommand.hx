package travix.commands;

import Sys.*;

class LuaCommand extends Command {
  override function execute() {
    if(command('eval', ['which luarocks >/dev/null']) != 0) {
      foldOutput('lua-install', function() {
        if(Travix.isLinux) {
          if(command('eval', ['bash -c "[ \\"`lsb_release -s -c`\\" == \\"precise\\" ]"']) == 0) {
            // Required repo for precise to build cmake
            exec('eval', ['sudo add-apt-repository -y ppa:george-edison55/precise-backports']);
            exec('eval', ['sudo apt-get update']);
          }

          for(pack in ["lua5.2","make","cmake","unzip","libpcre3","libpcre3-dev"])
            aptGet(pack);

          var luaRocksVersion = '2.4.2';

          // Add source files so luarocks can be compiled
          exec('sudo', ['mkdir', '-p', '/usr/include/lua/5.2']);
          exec('wget', ['-q', 'http://www.lua.org/ftp/lua-5.2.0.tar.gz']);
          exec('tar', ['xf', 'lua-5.2.0.tar.gz']);
          exec('eval', ['sudo cp lua-5.2.0/src/* /usr/include/lua/5.2']);
          exec('rm', ['-rf', 'lua-5.2.0']);
          exec('rm', ['-f', 'lua-5.2.0.tar.gz']);

          // Compile luarocks
          exec('wget', ['-q', 'http://luarocks.org/releases/luarocks-$luaRocksVersion.tar.gz']);
          exec('tar', ['zxpf', 'luarocks-$luaRocksVersion.tar.gz']);

          withCwd('luarocks-$luaRocksVersion', function() {
            exec('./configure');
            exec('eval', ['make build >/dev/null']);
            exec('eval', ['sudo make install >/dev/null']);
          });

          exec('rm', ['-f', 'luarocks-$luaRocksVersion.tar.gz']);
          exec('rm', ['-rf', 'luarocks-$luaRocksVersion']);
        } else if(Travix.isMac) {
          aptGet('lua');
        }

        // Install lua libraries
        // Based on https://github.com/HaxeFoundation/haxe/blob/3a6d024019aad28ab138fbb88cade34ff2e5bf19/tests/RunCi.hx#L473
        exec('eval', ['sudo luarocks install lrexlib-pcre 2.7.2-1']);  // pinning to 2.7.2-1 because of https://github.com/rrthomas/lrexlib/issues/20
        exec('eval', ['sudo luarocks install luv 1.9.1-0']);
        exec('eval', ['sudo luarocks install luasocket 3.0rc1-2']);
        exec('eval', ['sudo luarocks install environ 0.1.0-1']);
      });
    }

    // print the effective versions
    exec("luarocks", ['--version']);
    exec("lua", ['-v']);

    build(['-lua', 'bin/lua/tests.lua'], function () {
      exec('lua', ['bin/lua/tests.lua']);
    });
  }
}
