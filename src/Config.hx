import haxe.io.Path;

class Config {
	public static final contentPath = "./assets/content/";
	public static final outputPath = "./output/";
	public static final repositoryUrl = switch (Sys.getEnv("REPO_URL")) {
		case null: "https://github.com/HaxeFoundation/code-cookbook/";
		case v: v;
	};
	public static final repositoryBranch = switch (Sys.getEnv("REPO_BRANCH")) {
		case null: "master";
		case v: v;
	};
	public static final basePath = switch (Sys.getEnv("BASEPATH")) {
		case null: "";
		case v: v;
	};
	public static final titlePostFix = " - Haxe programming language cookbook";
	public static final cookbookFolder = Path.addTrailingSlash("cookbook");
	public static final assetsFolderName = "assets";
	public static final snippetsFolder = Path.addTrailingSlash("snippets");
}
