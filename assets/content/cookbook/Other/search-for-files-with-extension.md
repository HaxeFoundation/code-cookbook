# Search for all files of particular extension

This example uses Haxe's Filesystem to recursively search for all files of certain extension. 

```hx
import haxe.io.Path;

static function recursiveSearch(directory:String = "path/to/", extension:String) {
    var files:Array<String> = [];
    
    if (sys.FileSystem.exists(directory)) {
      for (file in sys.FileSystem.readDirectory(directory)) {
        var path = Path.join([directory, file]);
        if (!sys.FileSystem.isDirectory(path)) {
            // regex expression to search for files with a '.'
            var re = ~/[^.]+$/;
            if (re.match(path)) {
                var ext = re.matched(0);
                if (ext == extension)
                    files.push(path);	
            }
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
