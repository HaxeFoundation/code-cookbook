package util;
import haxe.crypto.Md5;
import haxe.ds.Map;
import haxe.ds.StringMap;
import haxe.io.Path;

using StringTools;
using Lambda;

/**
 * @author Mark Knol
 */
class GitUtil
{
	static var now = Date.now();
	
	static var dateStringCache:Map<String, String> = new Map();
	
	static function getCreationDate(path:String):Date {
		var dateString = getDateLog(path);
		if (dateString == null) return now;
		dateString = {
			var lines = dateString.split("\n");
			if (lines[lines.length - 1].length > 2) lines[lines.length - 1];
			else lines[lines.length - 2]; // last line is sometimes empty
		}
		return parseDateString(dateString, now);
	}
	
	static function getModificationDate(path:String):Date {
		var dateString = getDateLog(path);
		if (dateString == null) return now;
		dateString = dateString.split("\n").shift();
		return parseDateString(dateString, now);
	}
	
	static function parseDateString(dateString:Null<String>, fallback:Date) {
		if (dateString == null || dateString.length < 10) return fallback;
		dateString = dateString.trim();
		if (dateString.length != 10) throw 'invalid date: ' + dateString; // skip non-versioned files
		var splitted = dateString.split("-");
		return new Date(Std.parseInt(splitted[0]), Std.parseInt(splitted[1]), Std.parseInt(splitted[2]) - 1, 1, 1, 1);
	}
	
	static function getDateLog(path:String):String {
		return if (dateStringCache.exists(path)) {
			dateStringCache[path];
		} else {
			var process = new sys.io.Process('git log --date=short --format=%ad --follow -- "$path"');
			if (process.exitCode() != 0) throw process.stderr.readAll().toString();
			var dateString = process.stdout.readAll().toString();
			dateStringCache[path] = dateString;
			dateString;
		}
	}
	
	public static function getAuthors(path:String, authorByName:StringMap<GitAuthorInfo>):Array<GitAuthorInfo> {
		#if (!display && !disable_git_authors)
			var process = new sys.io.Process('git log --follow --pretty=format:"%aN <%aE>" -- "$path"');
			if (process.exitCode() != 0) throw process.stderr.readAll().toString();
			var log = process.stdout.readAll().toString();
			if (log == null || log.length == 0) return [];
			var ereg = ~/(.+?) <(.+?)>/g;
			var authors:Array<GitAuthorInfo> = [];
			while (ereg.match(log)) {
				log = ereg.matchedRight();
				var name = ereg.matched(1);
				if (name.toLowerCase() == "github") continue;
				
				var author:GitAuthorInfo = authorByName.exists(name) ? authorByName.get(name) : { name: name };
				author.email = ereg.matched(2);
				author.hash = Md5.encode(ereg.matched(2).toLowerCase());
				if (!authors.exists(function (a) return a.email == author.email)) {
					authors.push(author);
				}
				authorByName.set(name, author);
			}
			return authors;
		#else 
		return [];
		#end
	}
	
	public static function getStat(path:String):GitDates {
		#if (!display && disable_git_dates)
		return {
			modified: now,
			created: now,
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
}
