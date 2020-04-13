[tags]: / "filesystem, sys, file"

# Search for all files of particular extension

This example uses Haxe's Filesystem to recursively search for all files of certain extension. 


## Implementation
```hx
import haxe.io.Path;
import sys.FileSystem;

static function recursiveSearch(directory:String = "path/to/", extension:String) {
  var files:Array<String> = [];
    
  if (FileSystem.exists(directory)) {
    for (file in FileSystem.readDirectory(directory)) {
      var path = Path.join([directory, file]);
      if (!FileSystem.isDirectory(path)) {
        // check if extension matches
        if (Path.extension(path) == extension)
            files.push(path);	
      } else {
        var directory = Path.addTrailingSlash(path);
        recursiveSearch(directory);
      }
    }
  } else {
    throw '"$directory" does not exists';
  }         
  return files;
}
```

## Usage
```hx
// search for all *.hx files
var haxeFiles:Array<String> = recursiveSearch('path/to/files', 'hx');
trace(haxeFiles); // ["path/to/files/Example.hx"]
```

> Author: [Damilare Akinlaja](https://github.com/darmie)
