package travix.commands;

import Sys.*;

class PhpCommand extends Command {

  var phpVersionPattern:EReg = new EReg("PHP 5\\.*","");

  override function execute() {

    var phpCmd:String = null;
    var phpPackage:String = null;
    var phpInstallationRequired = false;

    foldOutput('php-install', function() {
      switch Sys.systemName() {
        case 'Linux':
          phpCmd = 'php5.6';
          phpPackage = 'php5.6';
          switch(tryToRun(phpCmd, ['--version'])) {
            case Success(out): phpInstallationRequired = !phpVersionPattern.match(out);
            case Failure(_):   phpInstallationRequired = true;
          }
          if (phpInstallationRequired) {
            exec('sudo', ['apt-get', '-qy', 'install', 'software-properties-common']);  // ensure add-apt-repository command is present
            exec('sudo', ['add-apt-repository', '-y', 'ppa:ondrej/php']);
            exec('sudo', ['apt-get', 'update']);
            for (pgk in ['cli', 'mbstring', 'mcrypt', 'xml'])
                exec('sudo', ['apt-get', '-q', '-y', '--allow-unauthenticated', 'install', phpPackage + '-' + pgk]);
          }
        case 'Mac':
          phpCmd = 'php';
          phpPackage = 'php56';
          switch(tryToRun(phpCmd, ['--version'])) {
            case Success(out): phpInstallationRequired = !phpVersionPattern.match(out);
            case Failure(_):   phpInstallationRequired = true;
          }
          if (phpInstallationRequired) {
            exec('brew', ['tap', 'homebrew/homebrew-php']);
            exec('brew', ['install', '--without-apache', '--without-snmp', phpPackage]);
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

    build(['-php', 'bin/php'], function () {
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
