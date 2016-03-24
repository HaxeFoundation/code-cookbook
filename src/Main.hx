package;

import Generator;
import neko.Lib;

/**
 * ...
 * @author Mark Knol
 */
class Main {
	
  public static function main() {
    var generator = new Generator();
    generator.outputPath = "output/";
    generator.contentPath = "assets/content/";
    
    generator.titlePostFix = " - Haxe Code Cookbook";
    generator.domain = "http://haxe-cookbook.stroep.nl/";
    generator.repositoryUrl = "https://github.com/HaxeFoundation/code-cookbook/";
    
    generator.build(true);
    generator.includeDirectory("assets/includes");
  }
}