package;

/**
 * @author Mark Knol
 */
class GitUtil
{
  static function getCreationDate(path:String) {
    #if !display
    var process = new sys.io.Process('git', ['log','--diff-filter=A','--follow','--format=%aD', '-1', '--', path]);
    if (process.exitCode() != 0) throw process.stderr.readAll().toString();
    return process.stdout.readLine();
    #else 
    return "";
    #end
  }
  
  static function getModificationDate(path:String) {
    #if !display
    var process = new sys.io.Process('git', ['log','--format=%aD', '-1', '--', path]);
    if (process.exitCode() != 0) throw process.stderr.readAll().toString();
    return process.stdout.readLine();
    #else 
    return "";
    #end
  }
  
  public static function getStat(path:String) {
    return {
      mtime: getModificationDate(path),
      ctime: getCreationDate(path),
    }
  }
}