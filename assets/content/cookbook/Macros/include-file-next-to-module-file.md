[tags]: / "build-macro,building-fields,expression-macro"

# Include a file next to a Haxe module file

This example lets you take a file next to the current module _.hx_ file and include its file content. That can be very useful if you want to separate (for example) view templates, shader sources or other multiline texts from the Haxe source. The articles demonstrates how to do it with an expression macro but also with a build macro.

## Preparation

This articles shows the two ways of using the macro:

- Using a `macro function` (expression macro) 
- Using a `@:build` macro (build macro).

To make this example work:

1. Create a class called "Macros.hx"
1. Create a class called "MyComponent.hx"
1. Create a template file called "MyComponent.template". Write some dummy text in this file.

#### Getting the template file

Inside our macro functions we will call `Context.getPosInfos(Context.currentPos())` which returns `{min:Int, max:Int, file:String}`.
This object contains a `file` property which refers to the path of the module file (of course the path at which the macro was called, not the macro class itself). 

> Note that such paths are relative to where you are compiling, so it contains the class path as well; If needed you can change Haxe current working directory by adding `--cwd` to your compilation arguments.

---

# Using an expression macro

In this example we use an expression macro, these are used as normal functions and are written as `macro function`. The function will return an expression of a type String.

#### Implementation

```haxe
#if macro
import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import sys.FileSystem;
import sys.io.File;
#end

class Macros {
   public static macro function getTemplate():ExprOf<String> {
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
      
      // Tell the haxe compiler that the module depends on this file
      // See registerModuleDependency section
      Context.registerModuleDependency(Context.getLocalModule(), path);
      
      // return as expression
      return macro $v{fileContent};
    }  else {
      return macro null;
    }
  }
}
```

#### Usage

This is an example of how to use the macro function, this will be the content of the "MyComponent" class:

```haxe
class MyComponent {
  public static var TEMPLATE:String = Macros.getTemplate();
  public function new() {
    // trace the auto-generated template
    trace(MyComponent.TEMPLATE);
  }
}
```

--- 


# Using a build macro

In this example we will do nearly the same, but use a build macro and let it add the static `TEMPLATE` field auto-magically.
This can be used with the `@:build` or `@:autoBuild`. 
 
#### Implementation

This will be the content of the "Macros" class. 
The function will get the fields of the class (which is to be built), pushes the new field and returns them. Because that's how build macros work. Compared to the expression macro function, there is no need to use the `macro` keyword in the function declaration.

```haxe
import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import sys.FileSystem;
import sys.io.File;

class Macros {
  public static function buildTemplate():Array<Field> {
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
      
      // Tell the haxe compiler that the module depends on this file
      // See registerModuleDependency section
      Context.registerModuleDependency(Context.getLocalModule(), path);
      
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

#### Usage

This is an example of how to use the build macro, this will be the content of the "MyComponent" class:

```haxe
@:build(Macros.buildTemplate())
class MyComponent {
  public function new() {
    // trace the auto-generated template
    trace(MyComponent.TEMPLATE);
  }
}
```

If you dislike decorating all your components with the `@:build` metadata; you can also create an interface, add the metadata on that and implement the interface, as demonstrated here:

```haxe
class MyComponent implements IComponent {
  public function new() {
    // trace the auto-generated template
    trace(MyComponent.TEMPLATE);
  }
}

@:build(Macros.buildTemplate())
interface IComponent {}
```

## About Context.registerModuleDependency

With `Context.registerModuleDependency` you can let the haxe compiler know that a module now depends on a file in your filesystem.
This is relevant only when compiling using the haxe compilation server.

The compilation server improves compile times by only redoing work on files that have changed or if their dependencies have changed.

If we don't tell haxe about this new file dependency, then changes to the included file could end up being ignored in a new compilation server build, resulting in a cached and now stale version of the file's contents being included.

## Conclusion

If all is correct, you can create a `new MyComponent()` which logs the content of the template. 
When you look into the generated output, you'll notice the template content is in the source.

Note that including file content can save HTTP requests, but obviously increases your build output size. 
In some cases it is wiser to just load the file externally, but that totally depends on the use case. 

You've just tasted the different macro "flavors". As you could see they don't differ that much. 
Now you have this base to work on, it is also possible to parse/process the template compile time or do other things with it, change it to other data structures etc. 
It opens several possibilities.

> Author: [Mark Knol](https://github.com/markknol)
