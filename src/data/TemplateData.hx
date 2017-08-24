package data;

/**
 * @author Mark Knol
 */
@:structInit
@:keep
class TemplateData {
	public var title : String;
	public var tags : haxe.ds.StringMap<Array<data.Page>>;
	public var sitemap : Array<data.Category>;
	public var seriePages : Int -> Array<data.Page>;
	public var pages : Array<data.Page>;
	public var pageContent : String;
	public var now : Date;
	public var latestCreatedPages :  Int -> Array<data.Page>;
	public var getTagTitle : String -> String;
	public var getSortedTags : Void -> Array<String>;
	public var currentPage : data.Page;
	public var currentCategory : data.Category;
	public var convertDate : Date -> String;
	public var basePath : String;
	public var DateTools : Class<DateTools>;
}
