package;
import haxe.ds.StringMap;
import haxe.io.Error;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import templo.Template;
using StringTools;

/**
 * @author Mark Knol
 */
class Generator {
  public var contentPath = "./";
  public var outputPath = "./";
  public var repositoryUrl = "";
  public var domain = "";
  public var titlePostFix = "";
  public var sitemap:Array<Category> = [];
  
  private var _pages:Array<Page> = new Array<Page>();
  private var _folders:Map<String,Array<Page>> = new Map<String,Array<Page>>();
  
  public function new() {
    
  }
  
  /**
   * Build the Code Cookbook website with static website generator.
   * @param doMinify minifies the HTML output.
   */
  public function build (doMinify:Bool = false) {
    initTemplate();
    
    addGeneralPages();
    addCookbookPages();
    
    // after all other pages are added
    createSitemap();
    addCategoryPages();
    
    for(page in _pages) {
      // set the data for the page
      var category = getCategory(page);
      var data = {
        title: '${page.title}' + titlePostFix, 
        year: Date.now().getFullYear(), // we're professional now
        pages: _pages,
        currentPage: page,
        currentCategory: category,
        contributionUrl:getContributionUrl(page),
        addLinkUrl: (category != null) ? getAddLinkUrl(category) : getAddLinkUrl(page),
        absoluteUrl:getAbsoluteUrl(page),
        sitemap: sitemap,
        pageContent: null,
      }
      data.pageContent = getContent(contentPath + page.contentPath, data);
      
      trace("generating " + outputPath + page.outputPath);
      trace("from " + contentPath + page.templatePath);
      
      // execute the template
      var template = Template.fromFile(contentPath + page.templatePath);
      var html = template.execute(data);
      
      if (doMinify) {
        // strip crap
        var length = html.length;
        html = Minifier.removeComments(Minifier.minify(html));
        var newLength = html.length;
        trace("optimized " + (Std.int(100 / length * (length - newLength) * 100) / 100) + "%");
      }
      
      // write output into file
      File.saveContent(outputPath + page.outputPath, html);
    }
  }
  
  private function getCategory(page:Page):Category {
    for (category in sitemap) {
      if (category.pages.indexOf(page) != -1 ) {
        return category;
      }
    }
    return null;
  }
  
  private function addCategoryPages() {
    for (category in sitemap) {
      addPage(new Page("layout-page-sidebar.mtt", 
                       "table-of-content.mtt", 
                       category.id + "-index.html")
                        .setTitle('${category.title } - table of content')
                        .hidden(), category.folder);
    }
  }
  
  // categorizes the folders 
  private function createSitemap() {
    for (key in _folders.keys()) {
      var id = key.split("/")[2];
      if (key.indexOf("/cookbook/") == 0) {
        sitemap.push(new Category(id.toLowerCase(), id, key, _folders.get(key)));
      }
    }
  }
  
  public function getContributionUrl(page:Page) {
    return repositoryUrl + "tree/master/" + contentPath + page.contentPath;
  }
  
  public function getAddLinkUrl(category:Category  = null, page:Page = null) {
    if (category!= null) {
      return repositoryUrl + "new/master/" + contentPath + getDirectory(category.pages[0].contentPath);
    } else {
      return repositoryUrl + "new/master/" + contentPath + getDirectory(page.contentPath) + "?filename=snippet-name.md";
    }
  }
  
  public function getAbsoluteUrl(page:Page) {
    return domain + page.outputPath;
  }
  
  private function addPage(page:Page, folder:String = null) {
    _pages.push(page);
    
    if (folder != null) {
      if (!_folders.exists(folder)) {
        _folders.set(folder, []);
      }
      _folders.get(folder).push(page);
    }
  }
  
  private function addGeneralPages() {
    var page2 = new Page("layout-page-main.mtt", "index.mtt", "index.html")
      .setTitle("Build and debug cross platform applications using Haxe");
      
    addPage(page2, "/home");
  }
  
  private function addCookbookPages(documentationPath:String = "/cookbook/") {
    for (file in FileSystem.readDirectory(contentPath + documentationPath)) {
      if (!FileSystem.isDirectory(contentPath + documentationPath + file)) {
         var page = new Page("layout-page-sidebar.mtt", 
                             documentationPath + file, 
                             getWithoutExtension(file).toLowerCase() + ".html")
            .setTitle( getDocumentationTitle(documentationPath + file));
        addPage(page, documentationPath);
      } else {
        addCookbookPages(documentationPath + file + "/" );
      }
    }
  }
  
  private function getDocumentationTitle(path:String) {
    return File.getContent(contentPath + path).split("\n").shift().split("# ").join("");
  }
  
  private static inline function getDirectory(file:String) {
    var paths = file.split("/");
    paths.pop();
    return paths.join("/");
  }
  
  private static inline function getExtension(file:String) {
    return file.split(".").pop();
  }
  
  private static inline function getWithoutExtension(file:String) {
    var path = file.split(".");
    path.pop();
    return path.join(".");
  }
  
  private static function getContent(file:String, data) {
    return switch(getExtension(file)) {
      case "md": Markdown.markdownToHtml(File.getContent(file));
      case "mtt": Template.fromFile(file).execute(data);
      default: File.getContent(file);
    }
  }
  
  public function includeDirectory(dir:String, ?output:String) {
    if (output == null) output = outputPath;
    trace("include directory: " + output);
    for (file in FileSystem.readDirectory(dir)) {
      if (FileSystem.isDirectory(dir + "/" + file)) {
        FileSystem.createDirectory(output + "/" + file);
        includeDirectory(dir + "/" + file, output + "/" + file);
      } else {
        File.copy(dir + "/" + file, output + "/" + file);
      }
    }
  }
  
  private function initTemplate() {
    // for some reason this is needed, otherwise templates doesn't work.
    // the function fails, but i think internally Template can resolve paths now.
    try { 
      Template.fromFile(contentPath + "layout.mtt").execute({});
    } catch(e:Dynamic) { }
  }
  
}


class Page { 
  public var visible:Bool = true;
  public var title:String;
  public var templatePath:String;
  public var contentPath:String;
  public var outputPath:String;
  public var customData:Dynamic;
  
  public function new(templatePath:String, contentPath:String, outputPath:String) {
    this.templatePath = templatePath;
    this.contentPath = contentPath;
    this.outputPath = outputPath;
  }
  
  public function setCustomData(data:Dynamic):Page {
    this.customData = data;
    return this;
  }
  
  public function setTitle(title:String):Page {
    this.title = title;
    return this;
  }
  
  public function hidden() {
    visible = false;
    return this;
  }
}

class Category {
  public var title:String;
  public var id:String;
  public var folder:String;
  public var pages:Array<Page>;
  
  public function new(id:String, title:String, folder:String, pages:Array<Page>){
    this.id = id;
    this.title = title;
    this.folder = folder;
    this.pages = pages;
  }
  
  public function getPageCount():Int {
    return [for (page in pages) if (page.visible) page].length;
  }
}