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
    
    generator.build(true);
    generator.includeDirectory("assets/includes");
  }
}