package util;

/**
 * @author Mark Knol
 */
class Minifier {
  public static inline function minify(content:String){
    // adapted from http://stackoverflow.com/questions/16134469/minify-html-with-boost-regex-in-c
    return new EReg("(?ix)(?>[^\\S]\\s*|\\s{2,})(?=[^<]*+(?:<(?!/?(?:textarea|pre|script|code)\\b)[^<]*+)*+(?:<(?>textarea|pre|script|code)\\b|\\z))", "ig").replace(content, " ");// .split("> <").join("><");
  }
  
  public static inline function removeComments(content:String){
    // adapted from http://stackoverflow.com/questions/16134469/minify-html-with-boost-regex-in-c
    return new EReg("<!--(.*?)-->", "g").replace(content, "");
  }
}