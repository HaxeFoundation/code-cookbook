(function (console) { "use strict";
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
var Highlighter = function() { };
Highlighter.main = function() {
	var _g = 0;
	var _g1 = window.document.getElementsByTagName("code");
	while(_g < _g1.length) {
		var el = _g1[_g];
		++_g;
		if(Highlighter.hasClass(el,"prettyprint")) {
			if(!Highlighter.hasClass(el,"highlighted")) {
				if(Highlighter.hasClass(el,"haxe") || Highlighter.hasClass(el,"js") || Highlighter.hasClass(el,"javascript")) {
					el.innerHTML = Highlighter.syntaxHighlight(el.innerHTML);
					el.className += " highlighted";
				} else if(Highlighter.hasClass(el,"hxml")) {
					el.innerHTML = Highlighter.syntaxHighlightHXML(el.innerHTML);
					el.className += " highlighted";
				}
			}
		}
	}
};
Highlighter.hasClass = function(el,className) {
	return el.className.indexOf(className) != -1;
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
	var _this1 = new EReg("(//.+?)(\n|$)","g");
	tmp1 = html.replace(_this1.r,"<span class='cmt'>$1</span>$2");
	html = tmp1;
	var tmp2;
	var _this2 = new EReg("(/\\*\\*?(.|\n)+?\\*?\\*/)","g");
	tmp2 = html.replace(_this2.r,"<span class='cmt'>$1</span>");
	html = tmp2;
	return html;
};
Highlighter.syntaxHighlightHXML = function(html) {
	var tmp;
	var _this = new EReg("\\b(haxe)\\b","g");
	tmp = html.replace(_this.r,"<span class='kwd'>$1</span>");
	html = tmp;
	var tmp1;
	var _this1 = new EReg("(\"[^\"]*\")","g");
	tmp1 = html.replace(_this1.r,"<span class='str'>$1</span>");
	html = tmp1;
	var tmp2;
	var _this2 = new EReg("(--?.+?)(\\s)","g");
	tmp2 = html.replace(_this2.r,"<span class='val'>$1</span>$2");
	html = tmp2;
	var tmp3;
	var _this3 = new EReg("(#.+?)(\n|$)","g");
	tmp3 = html.replace(_this3.r,"<span class='cmt'>$1</span>$2");
	html = tmp3;
	return html;
};
Highlighter.main();
})(typeof console != "undefined" ? console : {log:function(){}});
