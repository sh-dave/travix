package travix.commands;

using sys.io.File;
using sys.FileSystem;

class InstallCommand extends Command {
  
	static inline var TESTS = @:privateAccess Travix.TESTS;
  
  override function execute() {
    switch Travix.getInfos() {
      case None:
        Travix.die('$TESTS not found');
        
      case Some(info):
        run('haxelib', ['dev', info.name, '.']);
        
        switch info.dependencies {
          case null:
          case v:
            for (lib in v.keys())
              installLib(lib, v[lib]);
        }
        run('haxelib', ['install', TESTS, '--always']);  
        
        exec('haxelib', ['list']);
    }
  }
  
}