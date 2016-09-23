package;

import Generator;

/**
 * @author Mark Knol
 */
class Main {
  public static function main() {
    var generator = new Generator();
    generator.titlePostFix = " - Haxe Code Cookbook";
    generator.basePath = "http://code.haxe.org/";
    generator.repositoryUrl = "https://github.com/HaxeFoundation/code-cookbook/";
    generator.repositoryBranch = "master";
    
    generator.build();
    generator.includeDirectory("assets/includes");
    
    
    var keep:haxe.CallStack;
  }
}
