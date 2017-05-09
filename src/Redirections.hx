package;
import haxe.Template;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;

/**
 * Generate redirections for moved pages.
 * 
 * @author Mark Knol
 */
class Redirections
{
	public static function generate(generator:Generator) 
	{
		var list =  [
			"category/abstract-types/rounded float.html" => "/category/abstract-types/rounded-float.html",
			"documentation/index.html" => "/",
			"category/other/step-iterator.html" => "/category/data-structures/step-iterator.html",
			"category/other/reverse-iterator.html" => "/category/data-structures/reverse-iterator.html",
			"category/other/grid-iterator.html" => "/category/data-structures/grid-iterator.html",
			"category/other/sort-array.html" => "/category/data-structures/sort-array.html",
			"category/other/using-filesystem.html" => "/category/beginner/using-filesystem.html",
			"category/beginner/everything-is-an-expression.html" => "/category/principles/everything-is-an-expression.html",
			"category/other/using-haxe-classes-in-javascript.html" => "/category/javascript/using-haxe-classes-in-javascript.html",
			"other/using-haxe-classes-in-javascript.html" => "/category/javascript/using-haxe-classes-in-javascript.html",
			"tag/clas.html" => "/tag/class.html",
			"tag/arra.html" => "/tag/array.html",
			"tag/macro-function.html" => "tag/expression-macro.html",
		];
		
		for (page in list.keys()) {
			var template = new Template(File.getContent(generator.contentPath + "redirection.mtt"));
			var content = template.execute({
				redirectionLink: list.get(page)
			});
			
			// make sure directory exists
			FileSystem.createDirectory(generator.outputPath + Path.directory(page));
			
			// save to output
			File.saveContent(generator.outputPath + page, content);
			
		}
	}
	
}
