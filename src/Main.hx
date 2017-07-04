package;

/**
 * @author Mark Knol
 */
class Main {
  public static function main() {
    haxe.Timer.measure(function() {
      var generator = new Generator();
      generator.titlePostFix = " - Haxe programming language cookbook";
      generator.basePath = "http://code.haxe.org/";
      generator.repositoryUrl = "https://github.com/HaxeFoundation/code-cookbook/";
      generator.repositoryBranch = "master";
    
      generator.build();
      generator.includeDirectory("assets/includes");
      
      Redirections.generate(generator);
    });
  }
}
