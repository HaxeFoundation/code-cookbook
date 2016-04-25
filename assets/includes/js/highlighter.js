(function (console) { "use strict";
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
var Highlighter = function() { };
Highlighter.main = function() {
	js.JQuery("code.prettyprint").each(function() {
		var el = js.JQuery(this);
		if(!el.hasClass("highlighted") && (el.hasClass("haxe") || el.hasClass("js"))) {
			el.html(Highlighter.syntaxHighlight(el.html()));
			el.addClass("highlighted");
		}
	});
};
Highlighter.syntaxHighlight = function(html) {
	var kwds = ["abstract","trace","break","case","cast","class","continue","default","do","dynamic","else","enum","extends","extern","for","function","if","implements","import","in","inline","interface","macro","new","override","package","private","public","return","static","switch","throw","try","typedef","untyped","using","var","while"];
	var kwds1 = new EReg("\\b(" + kwds.join("|") + ")\\b","g");
	var vals = ["null","true","false","this"];
	var vals1 = new EReg("\\b(" + vals.join("|") + ")\\b","g");
	var types = new EReg("\\b([A-Z][a-zA-Z0-9]*)\\b","g");
	html = html.replace(kwds1.r,"<span class='kwd'>$1</span>");
	html = html.replace(vals1.r,"<span class='val'>$1</span>");
	html = html.replace(types.r,"<span class='type'>$1</span>");
	var tmp;
	var _this = new EReg("(\"[^\"]*\")","g");
	tmp = html.replace(_this.r,"<span class='str'>$1</span>");
	html = tmp;
	var tmp1;
	var _this1 = new EReg("(//.+\n)","g");
	tmp1 = html.replace(_this1.r,"<span class='cmt'>$1</span>");
	html = tmp1;
	var tmp2;
	var _this2 = new EReg("(/\\*\\*?[^*]*\\*?\\*/)","g");
	tmp2 = html.replace(_this2.r,"<span class='cmt'>$1</span>");
	html = tmp2;
	return html;
};
var q = window.jQuery;
var js = js || {}
js.JQuery = q;
Highlighter.main();
})(typeof console != "undefined" ? console : {log:function(){}});
