# Named Parameters in Haxe

While there is no named parameter support in Haxe, anonymous structures can be used to obtain the same effect.



As noted, in the haxe documentation ["Impact on Performance" section](http://haxe.org/manual/types-structure-performance.html), this will have a negative impact on static targets due to an additional dynamic lookup, though. Your mileage may vary but I suppose this is ok to use for not too often called functions with lots of parameters.

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

> More on this topic: <http://haxe.org/manual/types-anonymous-structure.html>
> 
> Author: [x2f](http://github.com/x2f)
