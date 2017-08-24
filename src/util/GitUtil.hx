package util;
import haxe.crypto.Md5;
import haxe.ds.StringMap;
import haxe.io.Path;

using StringTools;

/**
 * @author Mark Knol
 */
class GitUtil
{
  static function getCreationDate(path:String):Date {
    #if !display
      var process = new sys.io.Process('git', ['log','--diff-filter=A','--follow','--date=short','--format=%ad', '-1', '--', path]);
      if (process.exitCode() != 0) throw process.stderr.readAll().toString();
      var dateString = process.stdout.readAll().toString();
      dateString = dateString.replace("\n", "").replace("\r", "");
      if (dateString == null || dateString.length < 8) return Date.now();
      return Date.fromString(dateString);
    #else 
    return Date.now();
    #end
  }
  
  static function getModificationDate(path:String):Date {
    #if !display
      var process = new sys.io.Process('git', ['log','--date=short','--format=%ad', '-1', '--', path]);
      if (process.exitCode() != 0) throw process.stderr.readAll().toString();
      var dateString = process.stdout.readAll().toString();
      dateString = dateString.replace("\n", "").replace("\r", "");
      if (dateString == null || dateString.length < 8) return Date.now();
      return Date.fromString(dateString);
    #else 
    return Date.now();
    #end
  }
  
  public static function getAuthors(path:String, authorByName:StringMap<GitAuthorInfo>):Array<GitAuthorInfo> {
    #if (!display && !disable_git_authors)
      var tty = Sys.systemName() == 'Windows' ? 'CON' : '/dev/tty';
      var process = new sys.io.Process('git shortlog -snc --email "$path" < $tty');
      if (process.exitCode() != 0) throw process.stderr.readAll().toString();
      var log = process.stdout.readAll().toString();

      if (log == null || log.length == 0) return [];
      var ereg = ~/(\d{1,4})\t(.+?) <(.+?)>/g;
      var authors:Array<GitAuthorInfo> = [];
      while (ereg.match(log)) {
        var name = ereg.matched(2);
        var author:GitAuthorInfo = authorByName.exists(name) ? authorByName.get(name) : { name: name };
        author.commits = Std.parseInt(ereg.matched(1));
        author.email = ereg.matched(3);
        author.hash = Md5.encode(ereg.matched(3).toLowerCase());
		authors.push(author);
		authorByName.set(name, author);
        log = ereg.matchedRight();
      }
      return authors;
    #else 
    return [];
    #end
  }
  
  public static function getStat(path:String):GitDates {
    #if disable_git_dates
    return {
      modified: Date.now(),
      created: Date.now(),
    }
    #else
    return {
      modified: getModificationDate(path),
      created: getCreationDate(path),
    }
    #end
  }
}

typedef GitDates = {
  modified: Date,
  created: Date,
}

typedef GitAuthorInfo = {
  ?username: String,
  ?profileLink: String,
  ?name: String,
  ?email: String,
  ?hash: String,
  ?commits: Int,
}
