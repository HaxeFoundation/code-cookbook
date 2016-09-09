# Hello world

> This tutorial demonstrates how to write and compile a Hello World Haxe program. It explains the involved file-format (.hx) and gives a basic explanation of what the Haxe Compiler does with them.

#### Requirements

* Haxe has to be installed and available from command line.
* You have to know how to to save files on your computer.
* You have to be able to open a command line, navigate to a directory and execute a command.

## Creating and saving the code

Copy and paste the following code into any editor or IDE of your choice:

```haxe
class HelloWorld {
  static public function main():Void {
    trace("Hello World");
  }
}
```

Save it as "HelloWorld.hx" anywhere you like.

## Executing Haxe to interpret the code

Open a command prompt and navigate directories to where you saved "HelloWorld.hx" to in the previous step. Afterwards, execute this command:

```hxml
haxe -main HelloWorld --interp
```
