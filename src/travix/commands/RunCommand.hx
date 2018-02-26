package travix.commands;

import tink.cli.Rest;

class RunCommand {

  public function new() {}
  
  @:defaultCommand
  public function help() {
    trace('todo');
  }
  
  @:command
  public function cs(rest:Rest<String>)
    new CsCommand().buildAndRun(rest);
  
  @:command
  public function node(rest:Rest<String>)
    new NodeCommand().buildAndRun(rest);
  
  @:command
  public function cpp(rest:Rest<String>)
    new CppCommand().buildAndRun(rest);
  
  @:command
  public function flash(rest:Rest<String>)
    new FlashCommand().buildAndRun(rest);
  
  @:command
  public function interp(rest:Rest<String>)
    new InterpCommand().buildAndRun(rest);
  
  @:command
  public function java(rest:Rest<String>)
    new JavaCommand().buildAndRun(rest);
  
  @:command
  public function js(rest:Rest<String>)
    new JsCommand().buildAndRun(rest);
  
  @:command
  public function lua(rest:Rest<String>)
    new LuaCommand().buildAndRun(rest);
  
  @:command
  public function neko(rest:Rest<String>)
    new NekoCommand().buildAndRun(rest);
  
  @:command
  public function php(rest:Rest<String>)
    new PhpCommand(false).buildAndRun(rest);
  
  @:command
  public function php7(rest:Rest<String>)
    new PhpCommand(true).buildAndRun(rest);
  
  @:command
  public function python(rest:Rest<String>)
    new PythonCommand().buildAndRun(rest);
}
