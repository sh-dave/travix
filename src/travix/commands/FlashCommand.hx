package travix.commands;

import Sys.*;

class FlashCommand extends Command {
  
  override function execute() {

    // if we are not on Linux we only compile but do not run the tests
    if(!Travix.isLinux) {
      build(['-swf', 'bin/swf/tests.swf'], function () {});
      return;
    }

    var homePath = "$HOME";
    var flashPath = '$homePath/.macromedia/Flash_Player';

    foldOutput('flash-install', function() {
      // Some xvfb settings
      exec('export', ['AUDIODEV=null']);

      // Create a configuration file so the trace log is enabled
      exec('eval', ['echo "ErrorReportingEnable=1\\nTraceOutputFileEnable=1" > "$homePath/mm.cfg"']);

      // Add the current directory as trusted, so exit can be used.
      exec('eval', ['mkdir -m 777 -p "$flashPath/#Security/FlashPlayerTrust"']);
      exec('eval', ['echo "`pwd`" > "$flashPath/#Security/FlashPlayerTrust/travix.cfg"']);

      exec('eval', ['mkdir -m 777 -p "$flashPath/Logs"']);
      exec('eval', ['rm -f "$flashPath/Logs/flashlog.txt"']);
      exec('eval', ['touch "$flashPath/Logs/flashlog.txt"']);

      // Download and unpack the player, unless it exists already
      if (command("eval", ['test -f "$flashPath/flashplayerdebugger"']) != 0) {
        exec('eval', ['wget -nv -O flash_player_sa_linux.tar.gz https://fpdownload.macromedia.com/pub/flashplayer/updaters/26/flash_player_sa_linux_debug.x86_64.tar.gz']);
        exec('eval', ['tar -C "$flashPath" -xf flash_player_sa_linux.tar.gz --wildcards "flashplayerdebugger"']);
        exec('eval', ['rm -f flash_player_sa_linux.tar.gz']);
      }
      
      // Tail the logfile. Must use eval to start tail in background, to see the output.
      exec('eval', ['tail -f --follow=name --retry "$flashPath/Logs/flashlog.txt" &']);
    });


    build(['-swf', 'bin/swf/tests.swf', '-D', 'flash-exit'], function () {
      // The flash player has some issues with unexplained crashes,
      // but if it runs about 7 times, it should succeed one of those.
      var ok = false;
      for(i in 1 ... 8) {
        if(command('eval', ['xvfb-run -a "$flashPath/flashplayerdebugger" bin/swf/tests.swf']) == 0) {
          ok = true; break;
        }
      }

      // Kill the tail process
      exec('eval', ["ps aux | grep -ie [L]ogs/flashlog.txt | awk '{print $2}' | xargs kill -9"]);

      if(!ok) {
        // Testing didn't complete, so xvfb may have crashed even though tests are passing.
        // Special solution for Buddy: As a final measure, check flashlog.txt if tests passed.
        if(command('eval', ['grep -E "^[0-9]+ specs, 0 failures, [0-9]+ pending$$" "$flashPath/Logs/flashlog.txt"']) != 0) {
          println('Flash execution failed too many times, build failure.');
          exit(1);
        }
      }
    });
  }
}
