[tags]: / "filesystem"

# Using the file system

These are the Haxe targets that can directly access the filesystem:

Name | Access to filesystem
--- | --- | 
C++ | Yes 
Neko | Yes 
PHP | Yes 
Java  | Yes
C#  | Yes 
Python  | Yes 
JavaScript | No 
NodeJS (using [hxnodejs](http://lib.haxe.org/p/hxnodejs/)) | Yes 
ActionScript 3  | No 
Flash | No 

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
sys.io.File.saveContent(content, 'my_folder/my_file.json');
```
> Api documentation: <http://api.haxe.org/sys/io/File.html>

### Recursive loop through all directories / files
```haxe
import sys.FileSystem;

private function recursiveLoop(folder:String = "my_folder/") {
  if (FileSystem.exists(folder)) {
    trace("directory found: " + folder);
    for (file in FileSystem.readDirectory(folder)) {
      var path = folder + file;
      if (!FileSystem.isDirectory(path)) {
        trace("file found: " + path);
        // do something with file
      } else {
        recursiveLoop(path + "/");
      }
    }
  } else {
    trace('"$folder" does not exists');
  }
}
```
> Api documentation: <http://api.haxe.org/sys/FileSystem.html>

### Checking file attributes

```haxe
var stat:FileStat = FileSystem.stat("myFile.txt");
trace("Last access time: " + stat.atime);
trace("Last modification time: " + stat.mtime);
trace("Last status change time: " + stat.ctime);
trace("Last status change time: " + stat.ctime);
trace("The user id: " + stat.uid);
trace("File size: " + stat.size);
```
> Api documentation: <http://api.haxe.org/sys/FileStat.html>
