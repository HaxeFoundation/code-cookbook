# Everything is an expression

Many programming languages split code into two kinds of elements: *statements* and *expressions*.
Statements perform some action (e.g. `if/else`) and expressions return values (e.g. `a + b`).

This is **NOT** the case in Haxe. In Haxe, everything is an expression which means it can be used where value is expected.

## Examples
```haxe
class Main {
  static function main() {
    // if/else is an expression returning value of either `true` or `false` branch
    trace(if (Math.random() > 0.5) "Hello" else "Bye");

    // try/catch is an expression returning value of `try` if everything is okay
    // or `catch` if error is caught
    trace(try haxe.Json.parse("{") catch (e:Dynamic) null);

    // switch is an expression returning value of the matched `case` (or `default`)
    trace(switch (Std.random(3)) {
      case 0: "zero";
      case 1: "one";
      case 2: "two";
      default: "impossible!";
    });

    // Even blocks are just expressions, returning value of the last of their expressions
    trace({
      var l = new List();
      for (i in 0...10) l.add(i);
      l;
    });

    // Actually, knowing that blocks are mere expressions, they are not necessarily required
    // for e.g. functions so this is a perfectly valid function definition
    function toInt(s:String):Int return Std.parseInt(s);

    // Some expressions, such as loops or var declarations don't make any sense as values,
    // so they will be typed as Void and thus won't be able to be used where value is expected
    // for example the following won't compile:
    //trace(for (i in 0...10) i);

    // Some expressions such as `throw`, `continue` or `return` also don't make sense as values,
    // however they are allowed to be in value places so code like the following is possible:
    for (file in ["a.txt", "b.txt", "c.txt"]) {
      // try reading file or skip the loop iteration
      var content = try sys.io.File.getContent(file) catch (e:Dynamic) continue;
      trace(content);
    }

    // One interesting feature of the `return` expression is that it can be used with a
    // non-empty expression for returning out of `Void` functions. While it can be confusing at first,
    // it is very pragmatic when dealing with callback-based code.
    // This kind of expressions will be transformed from `return someVoid();` to `someVoid(); return;`.
    // For example:
    function getContent(fileName:String, callback:String->Void):Void {
      if (fileName == "")
        return callback("New file"); // invoke callback and return early if `fileName` is empty string
      
      var content =
        try
          sys.io.File.getContent(fileName)
        catch (e:Dynamic)
          return callback("ERROR: " + e); // invoke callback and return early in case of error

      callback(content.toUpperCase()); // invoke callback normally
    }
  }
}
```

> Author: [Dan Korostelev](https://github.com/nadako)
