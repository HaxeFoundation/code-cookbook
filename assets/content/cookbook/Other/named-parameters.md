[tags]: / "arguments"

# Named Parameters

While there is no named parameter support in Haxe, anonymous structures can be used to obtain the same effect.

* Pros: it can make your code more readable, especially functions with a long parameter list.

* Cons: it imposes a performance penalty on each call (see the *Performance Considerations* section below for details)

## Usage
```haxe
class Test {
  static public function main() {
    foo({ x: 12, y:1.0, name: "foo"});
    bar({ x: 10, y:2.0, name: "bar"});
  }
  
  // Could be useful to specify options
  static public function foo(options:{x:Int, y:Float, name:String}) {
    trace('Got options: ${options.x}, ${options.y} and ${options.name}');
  }
  
  // Or could be useful to specify configuration
  static public function bar(config:{x:Int, y:Float, name:String}) {
    trace('Got configuration: ${config.x}, ${config.y} and ${config.name}');
  }
}
```

[Code in "Try Haxe"](http://try.haxe.org/#6Ce47)

A more practical example can be found in the [Neko tutorial "Accessing to MySQL Database" page](http://old.haxe.org/doc/neko/mysql)

```haxe
class Test {
  static function main() {
    var cnx = neko.db.Mysql.connect({ 
      host: "localhost",
      port: 3306,
      user: "root",
      pass: "",
      socket: null,
      database: "MyBase"
    });
    // ...
    cnx.close();
  }
}
```

## Performance Considerations

In short, this technique should  be avoided in performance critical sections on any target. 

As noted in the Haxe manual ["Impact on Performance" section](http://haxe.org/manual/types-structure-performance.html), this technique will have a negative impact on static targets due to an **additional dynamic lookup**. Additionally, an **anonymous object is created as well** in the process, which further affects performances. 

The dynamic lookup is the more expensive bit on both the JVM (by far) and CLR (although barely). On other static and all dynamic platforms, the converse is true. The following code may remove the performance impact from anonymous object creation. (Source: [this comment from back2dos](https://github.com/HaxeFoundation/code-cookbook/pull/42#issuecomment-229000039)).

```haxe
public inline function foo(options:{ x:Int, y:Float, z:String }) return _foo(options.x, options.y, options.z);
private function _foo(x:Int, y:Float, z:String) return "$x, $y, $z";
```


> More on this topic: 
>
> - Anonymous structures in Haxe manual: <http://haxe.org/manual/types-anonymous-structure.html>
> - Tinker Bell Language Extentions by back2dos provide a more integrated support for named parameters and discuss their usage: <https://github.com/haxetink/tink_lang#named-parameters>
> 
> Author: [x2f](https://github.com/x2f), [back2dos](https://github.com/back2dos)
