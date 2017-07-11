[tags]: / "json,validation,expression-macro"

# Validates a .JSON file compile-time

Json is quite a strict format. 
Ensure all comma's and quotes are correct using a macro function, which is executed while compiling.

## Macro function

```haxe
class Validator {
  public static macro function validateJson(path:String) {
    if (sys.FileSystem.exists(path)) {
      var content = sys.io.File.getContent(path);
      try {
        // Test the json by parsing it. 
        // It will throw an error when you made a mistake.
        haxe.Json.parse(content);
      } catch (error:String) {
        // create position inside the json, FlashDevelop handles this very nice.
        var position = Std.parseInt(error.split("position").pop());
        var pos = haxe.macro.Context.makePosition({
            min:position,
            max:position + 1,
            file:path
        });
        haxe.macro.Context.error(path + " is not valid Json. " + error, pos);
      }
    } else {
      haxe.macro.Context.warning(path + " does not exist", haxe.macro.Context.currentPos());
    }
    return macro null;
  }
}
```

## Usage

This example only validates the _.json_ files in debug builds and not in display mode (auto-completion). 
The function can be called from anywhere.

```haxe
class Test {
  static function main() {
    #if (debug && !display)
    Validator.validateJson("assets/json/levels.json");
    Validator.validateJson("assets/json/copy.json");
    #end
  }
}
```

> Source: <https://gist.github.com/markknol/59f0ede823f7d511362b>  
> Author: [Mark Knol](https://github.com/markknol)
