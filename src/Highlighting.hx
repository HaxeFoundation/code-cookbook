import haxe.Json;
import highlighter.Highlighter;
import sys.io.File;

class Highlighting {
	public static function main() {
		Sys.println("Applying syntax highlighting ...");

		// Convert CSON grammar to json for vscode-textmate
		File.saveContent("bin/javascript.json", Json.stringify(CSON.parse(File.getContent("grammars/language-javascript/grammars/javascript.cson"))));

		var grammarFiles = [
			"haxe" => "grammars/haxe-TmLanguage/haxe.tmLanguage",
			"hxml" => "grammars/haxe-TmLanguage/hxml.tmLanguage",
			"html" => "grammars/xml.tmbundle/Syntaxes/XML.plist",
			"js" => "bin/javascript.json",
			"javascript" => "bin/javascript.json",
		];

		Highlighter.loadHighlighters(grammarFiles, function(highlighters) {
			// Go over the generated HTML file and apply syntax highlighting
			var missingGrammars = Highlighter.patchFolder(Config.outputPath, highlighters, function(classList) {
				return classList.substr(12);
			});

			for (g in missingGrammars) {
				Sys.println('Missing grammar for "${g}"');
			}

			// Add CSS rules for highlighting
			var path = Config.outputPath + "/css/haxe-nav.min.css";
			var baseStyle = File.getContent(path);
			var syntaxStyle = highlighters["haxe"].runCss();
			File.saveContent(path, baseStyle + syntaxStyle);
		});
	}
}

@:jsRequire("cson-parser")
extern class CSON {
	static function parse (content:String) : Dynamic;
}
