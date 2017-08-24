package data;

/**
 * @author Mark Knol
 */
@:keep
class Category {
  public var parent:Category;
  public var title:String;
  public var outputPath:String;
  public var absoluteUrl:String;
  public var id:String;
  public var folder:String;
  public var pages:Array<Page>;
  public var isSerie:Bool;

  public var content:String;
  
  public function new(id:String, title:String, folder:String, pages:Array<Page>){
    this.id = id;
    this.title = title;
    this.folder = folder;
    this.pages = pages;
    this.outputPath = 'category/$id/';
  }
  
  public function getPageCount():Int {
    return [for (page in pages) if (page.visible && !page.isSerieHome()) page].length;
  }
}
