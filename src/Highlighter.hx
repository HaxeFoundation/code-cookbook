package;

/**
 * @author Mark Knol
 */
class Highlighter{
  public static function main() {
    new js.JQuery("code.prettyprint").each(function() {
      var el = js.JQuery.cur;
      if (!el.hasClass("highlighted") && (el.hasClass("haxe") || el.hasClass("js") || el.hasClass("javascript"))) {
        el.html(syntaxHighlight(el.html()));
        el.addClass("highlighted");
      }
    });
  }

  static function syntaxHighlight(html:String) {
    var kwds = ["abstract", "trace", "break", "case", "cast", "class", "continue", "default", "do", "dynamic", "else", "enum", "extends", "extern", "for", "function", "if", "implements", "import", "in", "inline", "interface", "macro", "new", "override", "package", "private", "public", "return", "static", "switch", "throw", "try", "typedef", "untyped", "using", "var", "while" ];
    var kwds = new EReg("\\b(" + kwds.join("|") + ")\\b", "g");

    var vals = ["null", "true", "false", "this"];
    var vals = new EReg("\\b(" + vals.join("|") + ")\\b", "g");

    var types = ~/\b([A-Z][a-zA-Z0-9]*)\b/g;

    html = kwds.replace(html, "<span class='kwd'>$1</span>");
    html = vals.replace(html, "<span class='val'>$1</span>");
    html = types.replace(html, "<span class='type'>$1</span>");
    
    html = ~/("[^"]*")/g.replace(html, "<span class='str'>$1</span>");
    html = ~/(\/\/.+\n)/g.replace(html, "<span class='cmt'>$1</span>");
    html = ~/(\/\*\*?[^*]*\*?\*\/)/g.replace(html, "<span class='cmt'>$1</span>");
    
    return html;
  }
}
