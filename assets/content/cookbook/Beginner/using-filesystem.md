[tags]: / "filesystem"

# Using the file system

Using file system in Haxe is made easy because of the  [`sys` package](http://api.haxe.org/sys/). These are the Haxe targets that can directly access the filesystem:

Name | Access to filesystem
--- | --- | 
C++ | Yes 
C#  | Yes 
PHP | Yes 
Java  | Yes
Python  | Yes 
Lua | Yes 
Macro | Yes 
HL (HashLink) | Yes 
Neko | Yes 
JavaScript | No 
NodeJS (using [hxnodejs](http://lib.haxe.org/p/hxnodejs/)) | Yes 
ActionScript 3  | No 
Flash | No 

> Note that in macros you can access file system. 

### Check if FileSystem is available

You can safely access the `sys`-package if you wrap the code with [conditional compilation](http://haxe.org/manual/lf-condition-compilation.html):
  
```haxe
#if sys
trace("file system can be accessed");
#end
```
Otherwise you will get the error:
  _"You cannot access the sys package while targeting js (for sys.FileSystem)"_.

### Read content of a file

This example reads a text file:
```haxe
var content:String = sys.io.File.readContent('my_folder/my_file.txt');
trace(myContent);
```

### Write content to a file

This example writes an object `person` to a json file:
```haxe
var user = {name:"Mark", age:31};
var content:String = haxe.Json.stringify(user);
sys.io.File.saveContent('my_folder/my_file.json',content);
```
> Api documentation: <http://api.haxe.org/sys/io/File.html>

### Cross platform paths

Dealing with paths, directories, slashes, extensions on multiple platforms or OSes can be slightly awkward. Haxe provides the `haxe.io.Path` class which supports the common path formats.

Extracting info from a path:
```haxe
var location = "path/to/file.txt";
var path = new haxe.io.Path(location);
trace(path.dir); // path/to
trace(path.file); // file
trace(path.ext); // txt
```

Combining info into a new path:
```haxe
var directory = "path/to/";
var file = "./file.txt";
trace(haxe.io.Path.join([directory, file])); // path/to/file.txt
```

> Api documentation: <http://api.haxe.org/haxe/io/Path.html>

### Recursive loop through all directories / files
```haxe
function recursiveLoop(directory:String = "path/to/") {
  if (sys.FileSystem.exists(directory)) {
    trace("directory found: " + directory);
    for (file in sys.FileSystem.readDirectory(directory)) {
      var path = haxe.io.Path.join([directory, file]);
      if (!sys.FileSystem.isDirectory(path)) {
        trace("file found: " + path);
        // do something with file
      } else {
        var directory = haxe.io.Path.addTrailingSlash(path);
        trace("directory found: " + directory);
        recursiveLoop(directory);
      }
    }
  } else {
    trace('"$directory" does not exists');
  }
}
```
> Api documentation: <http://api.haxe.org/sys/FileSystem.html>

### Checking file attributes

```haxe
var stat:sys.FileStat = sys.FileSystem.stat("myFile.txt");
trace("Last access time: " + stat.atime);
trace("Last modification time: " + stat.mtime);
trace("Last status change time: " + stat.ctime);
trace("The user id: " + stat.uid);
trace("File size: " + stat.size);
```
> Api documentation: <http://api.haxe.org/sys/FileStat.html>

