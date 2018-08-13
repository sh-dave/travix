package travix.loggers;

class JsLogger {
  
  static var callPhantom:Dynamic = untyped js.Browser.window.callPhantom;
  
  public static function print(s:String) {
    if (callPhantom)
      callPhantom({
        cmd: 'travix:print',
        message: s,
      });
    else console.log(s);
  }
  
  public static function println(s:String) {
    if (callPhantom)
      callPhantom({
        cmd: 'travix:println',
        message: s,
      });
    else console.log(s);
  }
  
  public static function exit(code:Int) {
    if (callPhantom)
      callPhantom({
        cmd: 'travix:exit',
        exitCode: code,
      });
    else if (code != 0) throw code;//certainly not ideal, but it should work ^^
  }
  
}
