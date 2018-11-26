[tags]: / "filesystem"

# Zip files

The [haxe.zip](http://api.haxe.org/haxe/zip/) package allows to zip and unzip files and directories using Haxe. This example shows how to use it.

> **Note:** This only works on the [sys-targets](/category/beginner/using-filesystem.html).

## Zip a directory

The following example reads the directory "build/game/" with all of its content (recursively) and writes it to a zip file called _output.zip_.

```haxe
// recursive read a directory, add the file entries to the list
function getEntries(dir:String, entries:List<haxe.zip.Entry> = null, inDir:Null<String> = null) {
	if (entries == null) entries = new List<haxe.zip.Entry>();
	if (inDir == null) inDir = dir;
	for(file in sys.FileSystem.readDirectory(dir)) {
		var path = haxe.io.Path.join([dir, file]);
		if (sys.FileSystem.isDirectory(path)) {
			getEntries(path, entries, inDir);
		} else {
			var bytes:haxe.io.Bytes = haxe.io.Bytes.ofData(sys.io.File.getBytes(path).getData());
			var entry:haxe.zip.Entry = {
				fileName: StringTools.replace(path, inDir, ""), 
				fileSize: bytes.length,
				fileTime: Date.now(),
				compressed: false,
				dataSize: 0,
				data: bytes,
				crc32: haxe.crypto.Crc32.make(bytes)
			};
			entries.push(entry);
		}
	}
	return entries;
}
// create the output file 
var out = sys.io.File.write("output.zip", true);
// write the zip file
var zip = new haxe.zip.Writer(out);
zip.write(getEntries("build/game/"));
```

> **More information:**
> 
> * [haxe.zip API documentation](http://api.haxe.org/haxe/zip/)
> * More [format libraries](https://github.com/HaxeFoundation/format)
>
> Author: [Mark Knol](https://github.com/markknol)
