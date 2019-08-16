[tags]: / "io"

# stdin, stdout, stderr

Reading from stdin and writing to stdout and stderr.



## stdin

You can read from stdin interactively from the command
line, or can pipe input to your Haxe program like you would
with any other command line utility.

To read in one line:

~~~haxe
Sys.println("Enter your name:");
var ans = Sys.stdin().readLine();
// `ans` is just the text --- no newline
~~~

If you want to iteratively read in lines:

~~~haxe
var line : String;
var lines : Array<String> = [];
try {
    while (true) {
        line = Sys.stdin().readLine();
        lines.push(line);
    }
}
catch (e : haxe.io.Eof) {
    trace("done!");
}
~~~

You could also read in all the input in one shot:

~~~haxe
var content = Sys.stdin().readAll().toString();
~~~



## stdout

There's a few ways to write to stdout:

~~~haxe
trace("Hello, trace!");
Sys.println("Hello, println!");
Sys.print("Hello, print!"); // no added newline
~~~

You can also use `Sys.stdout()` to grab the stdout object and call its write
methods (see [haxe.io.Output](https://api.haxe.org/haxe/io/Output.html).



## stderr

To write to stderr:

~~~haxe
Sys.stderr().writeString("Yow!\n");
~~~
