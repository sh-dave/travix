package ${pack.join('.')};

class $name {

  static function main() {
    trace('it works');
    #if flash
      flash.system.System.exit(0);//Don't forget to exit on flash!
    #end
  }
  
}