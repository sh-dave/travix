package travix.commands;

import Sys.*;

class PhpCommand extends Command {

  var isPHP7Required:Bool;

  public function new(cmd, args, isPHP7Required) {
    super(cmd, args);
    this.isPHP7Required = isPHP7Required;
  }

  override function execute() {

    var haxeMajorVersion = Std.parseInt(run("haxe", ["-version"]).split(".")[0]);
    if(haxeMajorVersion > 3)
        isPHP7Required = true;

    var phpCmd:String = null;
    var phpPackage:String = null;
    var phpInstallationRequired = false;
    var phpVersionPattern:EReg = new EReg(isPHP7Required ? "PHP 7\\.*" : "PHP 5\\.*", "");

    foldOutput("php-install", function() {
      switch Sys.systemName() {
        case "Linux":
          phpCmd     = isPHP7Required ? "php7.1" : "php5.6";
          phpPackage = isPHP7Required ? "php7.1" : "php5.6";
          switch(tryToRun(phpCmd, ['--version'])) {
            case Success(out): phpInstallationRequired = !phpVersionPattern.match(out);
            case Failure(_):   phpInstallationRequired = true;
          }
          if (phpInstallationRequired) {
            installPackage('software-properties-common');  // ensure 'add-apt-repository' command is present
            exec('sudo', ['add-apt-repository', '-y', 'ppa:ondrej/php']);
            exec('sudo', ['apt-get', 'update']);
            installPackages([
              phpPackage + "-cli",
              phpPackage + "-mbstring",
              phpPackage + "-mcrypt",
              phpPackage + "-xml"
            ], [ "--allow-unauthenticated" ]);
          }
        case 'Mac':
          phpCmd = 'php';
          phpPackage = isPHP7Required ? "php71" : "php56";
          switch(tryToRun(phpCmd, ['--version'])) {
            case Success(out): phpInstallationRequired = !phpVersionPattern.match(out);
            case Failure(_):   phpInstallationRequired = true;
          }
          if (phpInstallationRequired) {
            exec('brew', ['update']); // to prevent "Homebrew must be run under Ruby 2.3!" https://github.com/travis-ci/travis-ci/issues/8552#issuecomment-335321197
            exec('brew', ['tap', 'homebrew/homebrew-php']);
            installPackage(phpPackage, ['--without-apache', '--without-snmp']);
          }
        case v:
          phpCmd = 'php';
          if (tryToRun(phpCmd, ['--version']).match(Failure(_, _))) {
            println('[ERROR] Don\'t know how to install PHP on $v');
            exit(1);
          }
      }

      // print the effective PHP version
      exec(phpCmd, ['--version']);
    });

    build(isPHP7Required ? ['-php', 'bin/php', '-D', 'php7'] : ['-php', 'bin/php'], function () {
      exec(phpCmd, ['-d', 'xdebug.max_nesting_level=9999', 'bin/php/index.php']);
    });

    // removing PHP to be able to run another PhpCommand that may need another PHP version
    if (phpInstallationRequired) foldOutput('php-uninstall', function() {
      switch Sys.systemName() {
        case 'Linux': exec('sudo', ['apt-get', '-q', '-y', 'remove', phpPackage]);
        case 'Mac':  exec('brew', ['remove', phpPackage]);
      }
    });
  }
}
