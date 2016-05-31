[tags]: / "arguments"

# Named Parameters in Haxe

While there is no named parameter support in Haxe, anonymous structures can be used to obtain the same effect.

* Pros: it can make your code more readable, especially functions with a long parameter list.

* Cons: as noted in the Haxe manual ["Impact on Performance" section](http://haxe.org/manual/types-structure-performance.html), this will have a negative impact on static targets due to an additional dynamic lookup. This should therefore be avoided in performance critical sections on those targets. 

## Usage
```haxe
class Test {
  static public function main() {
    myFun({ x: 12, name: "foo"});
  }
  static public function myFun(p:{x:Int, name:String}) {
    trace('Got ${p.x} and ${p.name}');
  }
}
```

[Code in "Try Haxe"](http://try.haxe.org/#2E83d)

> More on this topic: 
>
> - Anonymous structures in Haxe manual: <http://haxe.org/manual/types-anonymous-structure.html>
> - Tinker Bell Language Extentions by back2dos provide a more integrated support for named parameters and discuss their usage: <https://github.com/haxetink/tink_lang#named-parameters>
> 
> Author: x2f
