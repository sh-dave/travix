package travix.commands;

class InstallNodeCommand extends Command {
  
  static var VERSION_RE = ~/^v?(\d{1,})\.\d{1,}\.\d{1,}$/;
  
  @:defaultCommand
  public function doIt() {
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
  }
}