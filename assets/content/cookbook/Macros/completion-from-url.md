[tags]: / "completion,build-macro"

# Code completion from URL

This example will load an URL, scrape all id's from the HTML page and use them for auto-completion.

```haxe
import haxe.macro.Context;
import haxe.macro.Expr;

class MyMacro {
  public static function build(url:String) {
    var h = haxe.Http.requestUrl(url);

    //trace(h);

    var r = ~/id=["']([A-Za-z0-9]+)["']/;
    var ids = [];
    while (r.match(h)) {
      var id = r.matched(1);
      ids.remove(id);
      ids.push(id);
      h = r.matchedRight();
    }

    var fields = Context.getBuildFields();
    var gtype = TAnonymous([for (id in ids) { 
      name : id, 
      pos : Context.currentPos(), 
      kind : FVar(macro:String) 
    }]);
    
    var gids:Field = {
      name : "gids",
      pos : Context.currentPos(),
      kind : FVar(gtype),
      access : [AStatic],
    };
    fields.push(gids);
    return fields;
  }
}
```

## Usage

```haxe
@:build(MyMacro.build("http://www.msn.com/en-us/"))
class Main {
  static function main() {
    Main.gids; // auto-complete here
  }
}
```

## Demo

<img src="img/completion-from-url.gif" alt="Code completion from URL"/>

## Explanation in video
_Start at 21:00_

[youtube](https://www.youtube.com/embed/SEYCmjtKlVw)

> More info: <http://haxe.org/blog/nicolas-about-haxe-3>  
> Author: [Nicolas Cannasse](https://github.com/ncannasse)
