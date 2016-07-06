package;

using buddy.Should;

@colorize
class Run extends buddy.SingleSuite {
  public function new() {
    describe("Using travix", {
      #if (sys || nodejs)
      describe("On Sys targets and Node.js", {
        it("exit with status 0 if everything went well", {
          Sys.getCwd().should.not.be(null);
        });
      });
      #elseif js
      describe("On js", {
        it("should run on phantomjs", {
          js.Browser.navigator.userAgent.should.match(~/PhantomJS/);
        });
      });      
      #elseif flash
      describe("On Flash", {
        it("tracing should work as usual", {
          trace("Flash trace");
          true.should.be(true);
        });
        it("should exit like a Sys target", {
          // Will be done automatically by Buddy
          true.should.be(true);
        });
      });
      #else
      describe("On other targets", {
        it("should compile only", {
          true.should.be(true);
        });        
      });
      #end
    });
  }  
}