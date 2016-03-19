package travis;

import haxe.DynamicAccess;
import haxe.Json;
import sys.io.*;
import Sys.*;

using StringTools;
using haxe.io.Path;

#if macro
import haxe.macro.Context;
#end

enum RunResult {
  Success(output:String);
  Failure(code:Int, output:String);
}

class Travis {
    
  function new() { }
 
  function doInit(?path = '.') {
    File.saveContent('$path/.travis.yml', defaultFile());
  }
  
  macro static function defaultFile() {
    return macro $v{File.getContent(Context.getPosInfos((macro null).pos).file.directory() + '/default.yml')};
  }
  
  function tryToRun(cmd:String, ?params:Array<String>) {
    var p = new Process(cmd, params);
    return
      switch p.exitCode() {
        case 0:
          Success(switch p.stdout.readAll().toString() {
            case '': p.stderr.readAll().toString(); //some commands print to stderr
            case v: v;
          });
        case v:
          Failure(v, p.stderr.readAll().toString());
      }
  }
  
  function run(cmd:String, ?params:Array<String>) {
    return
      switch tryToRun(cmd, params) {
        case Success(v): v;
        case Failure(code, out):
          var a = [cmd];
          if (params != null)
            a = a.concat(params);
            
          println('Failed to run `${params.join(" ")}`');
          print(out);
          exit(code);
          throw 'unreachable';
      }
  }
  
  function installLib(lib:String) {
    
    if (tryToRun('haxelib', ['path', lib]).match(Failure(_, _)))
      run('haxelib', ['install', lib]);
      
  }
  
  function doInstall() {
    
    var info = getInfos();
    
    run('haxelib', ['dev', info.name, '.']);
    
    switch info.dependencies {
      case null:
      case v:
        
        for (lib in v.keys())
          run('haxelib', ['install', lib, v[lib], '--always']);
    }
      
    command('haxelib', ['list']);
  }
  
  function getInfos(): { name: String, dependencies:DynamicAccess<String> }
    return haxe.Json.parse(File.getContent('haxelib.json'));
  
  function build(args:Array<String>) {
    
    run('haxe', ['-lib', getInfos().name, 'tests.hxml'].concat(args));
    
  }
    
  function doNeko() {
    
  }
  
  function doInterp() {
    
    build(['--interp']);
    //run('haxe', ['-lib', getInfos().name, 'tests.hxml', ]);
    //switch target {
      //case 'cpp': 
        //installLib('hxcpp');
      //case 'java': 
        //installLib('hxjava');
      //case 'cs': 
        //installLib('hxcs');
      //default:
    //}
  }
  
  function doHelp() {
    println('Commands');
    println('  init - initializes a project with a .travis.yml');
    println('  install - installs dependencies');
    println('  interp - run tests on interpreter');
    println('  neko - run tests on interpreter');
  }
  
  static function main() {
    
    var args = Sys.args();
    
    #if interp
      Sys.setCwd(args.pop());
    #end
    
    var url = 
      switch args.shift() {
        case null: 'help';
        case v: v;
      }
      
    var params = new Map(),
        value = '';
    
    for (a in args) {
      
      if (a.startsWith('-')) {
        params[a.substr(1)] = value;
        value = '';
      }
      else value = a;
      
    }
    
    var t = new Travis();
    
    haxe.web.Dispatch.run(url, params, t);
  }
  
}