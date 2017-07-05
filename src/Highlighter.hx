package;
import js.Browser.document;
import js.html.Element;
using StringTools;

/**
 * @author Mark Knol
 */
class Highlighter {
  public static function main() {
    for (el in document.getElementsByTagName("code")) {
      if (hasClass(el, "prettyprint")) {
        if (!hasClass(el, "highlighted")) {
          if (hasClass(el, "haxe") || hasClass(el, "js") || hasClass(el, "javascript")) {
            el.innerHTML = syntaxHighlight(el.innerHTML);
            el.className += " highlighted";
          } else if (hasClass(el, "hxml")) {
            el.innerHTML = syntaxHighlightHXML(el.innerHTML);
            el.className += " highlighted";
          }
        }
      }
    }
  }

  inline static function hasClass(el:Element, className:String) return el.className.indexOf(className) != -1;

  static function syntaxHighlight(html:String) {
    var kwds = ["abstract", "trace", "break", "case", "cast", "class", "continue", "default", "do", "dynamic", "else", "enum", "extends", "extern", "for", "function", "if", "implements", "import", "in", "inline", "interface", "macro", "new", "override", "package", "private", "public", "return", "static", "switch", "throw", "try", "typedef", "untyped", "using", "var", "while" ];
    var kwds = new EReg("\\b(" + kwds.join("|") + ")\\b", "g");

    var vals = ["null", "true", "false", "this"];
    var vals = new EReg("\\b(" + vals.join("|") + ")\\b", "g");

    var types = ~/\b([A-Z][a-zA-Z0-9]*)\b/g;

	html = html.replace("\t", "  "); // indent with two spaces
    html = kwds.replace(html, "<span class='kwd'>$1</span>");
    html = vals.replace(html, "<span class='val'>$1</span>");
    html = types.replace(html, "<span class='type'>$1</span>");
    
    html = ~/("[^"]*")/g.replace(html, "<span class='str'>$1</span>");
    html = ~/(\/\/.+?)(\n|$)/g.replace(html, "<span class='cmt'>$1</span>$2");
    html = ~/(\/\*\*?(.|\n)+?\*?\*\/)/g.replace(html, "<span class='cmt'>$1</span>");
    
    return html;
  }

  static function syntaxHighlightHXML(html:String) {
    html = ~/\b(haxe)\b/g.replace(html, "<span class='kwd'>$1</span>");
    html = ~/("[^"]*")/g.replace(html, "<span class='str'>$1</span>");
    html = ~/(--?.+?)(\s)/g.replace(html, "<span class='val'>$1</span>$2");
    html = ~/(#.+?)(\n|$)/g.replace(html, "<span class='cmt'>$1</span>$2");
    
    return html;
  }
}
