[tags]: / "macro,json,expression-macro,configuration"

# Strictly Typed JSON

It's possible read JSON files at compile time into strictly typed objects in Haxe.

<img src="assets/haxe-json-macro.png" />

Normally you might load a JSON file with something like this:
```haxe
var json = haxe.Json.parse(sys.io.File.getContent(path));
```

Instead, if you load the JSON in a macro, then the JSON data will be available at compile time and therefore the types will be known:

Create a file called **JsonMacro.hx** (or whatever you like) and add this:
```haxe
macro function load(path:String) {
	return try {
		var json = haxe.Json.parse(sys.io.File.getContent(path));
		macro $v{json};
	} catch (e) {
		haxe.macro.Context.error('Failed to load json: $e', haxe.macro.Context.currentPos());
	}
}
```

Then use this to load your JSON instead:

```haxe
var leveldata = JsonMacro.load('leveldata.json');

for (i in leveldata.array) { // works now because we know the type of the leveldata object
}
```

**Explanation**: We run the original `Json.parse(File.getContent())` snippet in a macro function so it will execute when the haxe compiles our calls to `JsonMacro.load()`. Instead of returning the JSON object, in macros we need to return _syntax_. So we must convert our JSON object into haxe syntax – just as if we'd typed our JSON out manually as haxe objects. Fortunately there's a built-in operator for converting values into haxe syntax, it's the ['macro-reification-value-operator': `$v{ some-basic-value }`](https://haxe.org/manual/macro-reification-expression.html). We could also use [`Context.makeExpr(value, position)`](https://api.haxe.org/haxe/macro/Context.html#makeExpr) to do the same job. We wrap the JSON reading a try-catch so we can tidy-up error reporting a little.

With this approach, the JSON's content is embedded into your compiled app and _not_ loaded at runtime, therefore, the path argument must be a constant string and cannot be an expression evaluated at runtime.

> Author: [George Corney](https://github.com/haxiomic)
