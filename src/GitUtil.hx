package;

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
      return Date.fromString(process.stdout.readLine());
    } catch (e:Dynamic) return null;
    #else 
    return null;
    #end
  }
  
  static function getModificationDate(path:String):Date {
    #if !display
    try {
      var process = new sys.io.Process('git', ['log','--date=format:%Y-%m-%d %H:%M:%S','--format=%ad', '-1', '--', path]);
      if (process.exitCode() != 0) throw process.stderr.readAll().toString();
      return Date.fromString(process.stdout.readLine());
    } catch (e:Dynamic) return null;
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
