[tags]: / "conditional-compilation,expression-macro"

# Include a file next to your Haxe class file

Let's say you want to create a macro that takes a file next to the current class. 
For example you want to include the file content of a template file in the class as a static field.
In this example we use a `@:build` macro for that. Inside the build function we will call `Context.getPosInfos(Context.currentPos())` which returns `{min:Int, max:Int, file:String}`.
This object contains a `file` property which refers to the path of the class _.hx_ file (of course the path at which the macro was called, not the macro class itself). 

> Note that such paths are relative to where you are compiling, so it contains the class path as well; If needed you can change Haxe current working directory by adding `--cwd` to your compilation arguments.

## Preparation

1. Create a class called "Macros.hx"
1. Create a class called "MyComponent.hx"
1. Create a template file called "MyComponent.template". Write some dummy text in this file.

## Implementation

This will be the content of the "Macros" class. 
Since this class is going to be used as a `@:build` macro, the function will get the fields of the class (which is to be built), pushes the new field and returns them. Because thats how build macros work.

```haxe
import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import sys.FileSystem;
import sys.io.File;

class Macros {
  public static function build():Array<Field> {
    // get the current fields of the class
    var fields:Array<Field> = Context.getBuildFields();
    
    // get the path of the current current class file, e.g. "src/path/to/MyClassName.hx"
    var posInfos = Context.getPosInfos(Context.currentPos());
    var directory = Path.directory(posInfos.file);
    
    // get the current class information. 
    var ref:ClassType = Context.getLocalClass().get();
    // path to the template. syntax: "MyClassName.template"
    var filePath:String = Path.join([directory, ref.name + ".template"]);
    
    // detect if template file exists
    if (FileSystem.exists(filePath)) {
      // get the file content of the template 
      var fileContent:String = File.getContent(filePath);
      
      // add a static field called "TEMPLATE" to the current fields of the class
      fields.push({
        name:  "TEMPLATE",
        access:  [Access.AStatic, Access.APublic],
        kind: FieldType.FVar(macro:String, macro $v{fileContent}), 
        pos: Context.currentPos(),
        doc: "auto-generated from " + filePath,
      });
    }
    
    return fields;
  }
}
```

### Usage

This is an example of how to use the macro, this will be the content of the "MyComponent" class:

```haxe
@:build(Macros.build())
class MyComponent {
  public function new() {
    // trace the auto-generated template
    trace(MyComponent.TEMPLATE);
  }
}
```

If you dislike decorating all your components with the `@:buid` metadata; you can also create an interface, add the metadata on that and implement the interface, as demonstrated here:

```haxe
class MyComponent implements IComponent {
  public function new() {
    // trace the auto-generated template
    trace(MyComponent.TEMPLATE);
  }
}

@:build(Macros.build())
interface IComponent {}
```

If all is correct, you can create a `new MyComponent()` which logs the content of the template. 
When you look into the generated output, you'll notice the template content is in the source.

Note that including file content can save HTTP requests, but obviously increases your build output size. 
In some cases it is wiser to just load the file externally, but that totally depends on the use case. 

Now you have this base to work on, it is also possible to parse/process the template compile time or do other things with it, change it to other data structures etc. 
It opens several possibilities.

> Author: [Mark Knol](http://github.com/markknol)