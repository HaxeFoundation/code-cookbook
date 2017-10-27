package;

/**
 * @author Mark Knol
 */
class Main {
  public static function main() {
    haxe.Timer.measure(function() {
      var generator = new Generator();
      generator.titlePostFix = " - Haxe programming language cookbook";
      generator.basePath = switch (Sys.getEnv("BASEPATH")){
        case null: "";
        case v: v;
      };
      generator.repositoryUrl = switch (Sys.getEnv("REPO_URL")) {
        case null: "https://github.com/HaxeFoundation/code-cookbook/";
        case v: v;
      }
      generator.repositoryBranch = switch (Sys.getEnv("REPO_BRANCH")) {
        case null: "master";
        case v: v;
      }
    
      generator.build();
      generator.includeDirectory("assets/includes");
      
      Redirections.generate(generator);
    });
  }
}
