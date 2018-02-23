package travix.commands;

import travix.*;

class InstallCommand extends Command {
  
	static inline var TESTS = @:privateAccess Travix.TESTS;
  
  @:defaultCommand
  public function dependencies() {
    
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
  
  @:command
  public function cs()
    new CsCommand().install();
  
  @:command
  public function node()
    new NodeCommand().install();
  
  @:command
  public function cpp()
    new CppCommand().install();
  
  @:command
  public function flash()
    new FlashCommand().install();
  
  @:command
  public function interp()
    new InterpCommand().install();
  
  @:command
  public function java()
    new JavaCommand().install();
  
  @:command
  public function js()
    new JsCommand().install();
  
  @:command
  public function lua()
    new LuaCommand().install();
  
  @:command
  public function neko()
    new NekoCommand().install();
  
  @:command
  public function php()
    new PhpCommand(false).install();
  
  @:command
  public function php7()
    new PhpCommand(true).install();
  
  @:command
  public function python()
    new PythonCommand().install();
}