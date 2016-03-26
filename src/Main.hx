package;

import Generator;

/**
 * @author Mark Knol
 */
class Main {
	
  public static function main() {
    var generator = new Generator();
    generator.titlePostFix = " - Haxe Code Cookbook";
    generator.domain = "http://haxe-cookbook.stroep.nl/";
    generator.repositoryUrl = "https://github.com/HaxeFoundation/code-cookbook/";
    
    generator.build(true);
    generator.includeDirectory("assets/includes");
  }
}