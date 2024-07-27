import haxe.Json;
import highlighter.Highlighter;
import sys.io.File;

class Highlighting {
	public static function main() {
		Sys.println("Applying syntax highlighting ...");

		// Convert CSON grammar to json for vscode-textmate
		File.saveContent("bin/javascript.json", Json.stringify(CSON.parse(File.getContent("grammars/language-javascript/grammars/javascript.cson"))));

		var haxeGrammar = new Highlighter("grammars/haxe-TmLanguage/haxe.tmLanguage");
		var hxmlGrammar = new Highlighter("grammars/haxe-TmLanguage/hxml.tmLanguage");
		var xmlGrammar = new Highlighter("grammars/xml.tmbundle/Syntaxes/XML.plist");
		var jsGrammar = new Highlighter("bin/javascript.json");

		var grammars = [
			"haxe" => haxeGrammar,
			"hxml" => hxmlGrammar,
			"html" => xmlGrammar,
			"js" => jsGrammar,
			"javascript" => jsGrammar,
		];

		// Go over the generated HTML file and apply syntax highlighting
		var missingGrammars = Highlighter.patchFolder(Config.outputPath, grammars, function (classList) {
			return classList.substr(12);
		});

		for (g in missingGrammars) {
			Sys.println('Missing grammar for "${g}"');
		}

		// Add CSS rules for highlighting
		var path = Config.outputPath + "/css/haxe-nav.min.css";
		var baseStyle = File.getContent(path);
		var syntaxStyle = haxeGrammar.runCss();
		File.saveContent(path, baseStyle + syntaxStyle);
	}
}

@:jsRequire("cson-parser")
extern class CSON {
	static function parse (content:String) : Dynamic;
}
