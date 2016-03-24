# Add git commit-hash in build

This example executes a process on the system, compile-time. 
This allows to run a git command `git rev-parse HEAD` and use it's result as value.

```haxe
class MyMacros {
  public static macro function getGitCommitHash():haxe.macro.ExprOf<String> {
    var process = new sys.io.Process('git', ['rev-parse', 'HEAD']);
    if (process.exitCode() != 0) {
      var message = process.stderr.readAll().toString();
      var pos = haxe.macro.Context.currentPos();
      Context.error("Cannot execute `git rev-parse HEAD`. " + message, pos);
    }
    
    // read the output of the process
    var commitHash:String = process.stdout.readLine();
    
    // Generates a string expression
    return macro $v{commitHash};
  }
}
```

### Usage

The function can be called like any other static function in Haxe.

```haxe
// use as field
@:keep public static var COMMIT_HASH(default, never):String = Version.getGitCommitHash();

// ..or trace to output
trace(Version.getGitCommitHash());
```

> [sys.io.Process API documentation](http://api.haxe.org/sys/io/Process.html)
