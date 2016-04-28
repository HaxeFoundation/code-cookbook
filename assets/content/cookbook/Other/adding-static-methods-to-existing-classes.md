[tags]: / "static-extensions"

# Adding Static Methods to Existing Classes

Haxe allows you to add static methods to existing classes (eg. `sys.io.File`) via the Static Extensions feature. The "secret sauce" is to specify the first parameter of the extension as `Class<X>` where `X` is the class you want to add static methods to (eg. `sys.io.File`).

Here's a class with a static method that adds a `ensureDirectoryExists` method to `sys.FileSystem`:

## Implementation

```haxe
// FileSystemExtensions.hx
class FileSystemExtensions {
  public static function ensureDirExists(clazz:Class<sys.FileSystem>, path:String) : Void {
    if (!FileSystem.exists(path)) {
      throw path + " doesn't exist";
    }
    else if (!FileSystem.isDirectory(path)) {
      throw path + " isn't a directory";
    }
  }
}
```

Note that the method is `public`, `static`, and the first parameter is `Class<sys.FileSystem>`.

## Usage

Here's how to consume the code:

```haxe
// Main.hx
import sys.FileSystem;
import FileSystemExtensions;

class Main {
  static function main() {
    FileSystem.ensureDirExists("bin");
  }
}
```

Using this, you can add all kinds of interesting extensions to pre-existing classes (eg. core Haxe classes, or classes from other Haxe libraries). 

> More on this topic: <haxe.org/manual/lf-static-extension.html>
> 
> Author: [ashes999](http://github.com/ashes999)
