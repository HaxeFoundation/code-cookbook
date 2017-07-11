[tags]: / "conditional-compilation"

# Conditional compilation

> This snippet demonstrates use of conditional compilation with custom compiler flags.

Conditional compilation is a tool commonly used to alter the flow of the compilation process. It relies on the use of compiler flags (also known as _defines_), which are configurable values that exist only during compilation.

Compiler flags are set with `-D key` or `-D key=value` from the command-line or build file. The values of `Float`, `Int`, and `String` constants are used directly when evaluating conditionals.

Note that those conditional compilation branches that the compiler doesn't enter are discarded while parsing the source file.

To get a list of supported Haxe compiler flags, use `haxe --help-defines`.

## Implementation
```haxe
class Main {
  static function main() {
    #if introduce
    trace("Hello! This is an example of conditional compilation.");
    #end

    #if (level > 4)
    trace("Welcome, administrator!");
    #elseif (level > 2)
    trace("Welcome, super user!");
    #else
    trace("Welcome, user!");
    #end
  }
}
```

## Usage

Assume the following build file:

```hxml
-main Main
-neko main.n
-D introduce
-D level=3
```

Running `neko main.n` from the compiler output directory will result in:

```
Hello, this is an example of conditional compilation.
Welcome, super user!
```

> * Learn about conditional compilation here: <http://haxe.org/manual/lf-condition-compilation.html>
> * Learn about available global compiler flags here: <http://haxe.org/manual/compiler-usage-flags.html>
>
> Author: [Domagoj Štrekelj](https://github.com/dstrekelj)
