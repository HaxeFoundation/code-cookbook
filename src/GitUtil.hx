package;

using StringTools;

/**
 * @author Mark Knol
 */
class GitUtil
{
  static function getCreationDate(path:String):Date {
    #if !display
    try {
      var process = new sys.io.Process('git', ['log','--diff-filter=A','--follow','--date=format:%Y-%m-%d %H:%M:%S','--format=%ad', '-1', '--', path]);
      if (process.exitCode() != 0) throw process.stderr.readAll().toString();
      var dateString = process.stdout.readAll().toString();
      trace(haxe.Json.stringify(dateString));
      dateString = dateString.replace("\n", "").replace("\r", "");
      return Date.fromString(dateString);
    } 
    catch (e:Dynamic) 
    {
      trace("error: " + e);
      return null;
    }
    #else 
    return null;
    #end
  }
  
  static function getModificationDate(path:String):Date {
    #if !display
    try {
      var process = new sys.io.Process('git', ['log','--date=format:%Y-%m-%d %H:%M:%S','--format=%ad', '-1', '--', path]);
      if (process.exitCode() != 0) throw process.stderr.readAll().toString();
      var dateString = process.stdout.readAll().toString();
      dateString = dateString.replace("\n", "").replace("\r", "");
      return Date.fromString(dateString);
    }
    catch (e:Dynamic) 
    {
      trace("error: " + e);
      return null;
    }
    #else 
    return null;
    #end
  }
  
  public static function getStat(path:String):GitDates {
    return {
      modified: getModificationDate(path),
      created: getCreationDate(path),
    }
  }
}

typedef GitDates = {
  modified: Date,
  created: Date,
}
