package;
import haxe.Timer;
import haxe.ds.StringMap;
import sys.FileSystem;
import sys.io.File;
import templo.Template;
using StringTools;

/**
 * @author Mark Knol
 */
class Generator {
  public var contentPath = "./assets/content/";
  public var outputPath = "./output/";
  public var repositoryUrl = "";
  public var repositoryBranch = "";
  public var domain = "";
  public var titlePostFix = "";
  public var sitemap:Array<Category> = [];
  public var tags:StringMap<Array<Page>>;
  
  private var _pages:Array<Page> = new Array<Page>();
  private var _folders:Map<String,Array<Page>> = new Map<String,Array<Page>>();
  
  public function new() { }
  
  /**
   * Build the Code Cookbook website with static website generator.
   * @param doMinify minifies the HTML output.
   */
  public function build (doMinify:Bool = false) {
    initTemplate();
    
    addGeneralPages();
    addCookbookPages();
    
    // after all other pages are added
    collectTags();
    createSitemap();
    addCategoryPages();
    addTagPages();
    
    Timer.measure(function() {
      for(page in _pages) {
        // set the data for the page
        var category = getCategory(page);
        
        var data = {
          title: '${page.title} $titlePostFix', 
          year: Date.now().getFullYear(), // we're professional now
          baseHref: getBaseHref(page),
          pages: _pages,
          currentPage: page,
          currentCategory: category,
          contributionUrl:getContributionUrl(page),
          editUrl:getEditUrl(page),
          addLinkUrl: (category != null) ? getAddLinkUrl(category) : getAddLinkUrl(page),
          absoluteUrl:getAbsoluteUrl(page),
          sitemap: sitemap,
          tags: tags,
          pageContent: null,
        }
        data.pageContent = getContent(contentPath + page.contentPath, data);
        
        // execute the template
        var template = Template.fromFile(contentPath + page.templatePath);
        var html = template.execute(data);
        
        if (doMinify) {
          // strip crap
          var length = html.length;
          html = Minifier.removeComments(Minifier.minify(html));
          var newLength = html.length;
          //trace("optimized " + (Std.int(100 / length * (length - newLength) * 100) / 100) + "%");
        }
        
        // write output into file
        var targetDirectory = getDirectory(outputPath + page.outputPath);
        if (!FileSystem.exists(targetDirectory)) {
          FileSystem.createDirectory(targetDirectory);
        }
        File.saveContent(outputPath + page.outputPath, html);
      }
    });
    
    //var allTags = [for (tag in tags.keys()) tag];
    //File.saveContent("used-tags.txt", allTags.join("\r\n"));
    
    trace(sitemap.length + " categories");
    trace(allTags.length + " tags");
    trace(_pages.length + " pages done!");
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
  
  private function addCategoryPages() {
    for (category in sitemap) {
      addPage(new Page("layout-page-sidebar.mtt", 
                       "table-of-content.mtt", 
                       'category/${category.id}/index.html')
                        .setTitle('${category.title } - table of content')
                        .hidden(), category.folder);
    }
  }
  
  private function addTagPages() {
    for (tag in tags.keys()) {
      addPage(new Page("layout-page-sidebar.mtt", 
                       "tags.mtt", 
                       'tag/$tag.html')
                        .setTitle('Tag - ${tag}')
                        .setCustomData({tag:tag, pages: tags.get(tag)})
                        .hidden(), "tags");
    }
  }
  
  private function addGeneralPages() {
    var page = new Page("layout-page-main.mtt", "index.mtt", "index.html")
      .setTitle("Easy to read Haxe coding examples");
      
    addPage(page, "/home");
  }
  
  private function addCookbookPages(documentationPath:String = "cookbook/") {
    for (file in FileSystem.readDirectory(contentPath + documentationPath)) {
      if (!FileSystem.isDirectory(contentPath + documentationPath + file)) {
        
         var page = new Page("layout-page-sidebar.mtt", 
                             documentationPath + file, 
                             documentationPath.replace('cookbook/', 'category/').toLowerCase() + 
                                getWithoutExtension(file).toLowerCase() + ".html")
            .setTags(getTags(documentationPath + file))
            .setTitle(getDocumentationTitle(documentationPath + file));
        addPage(page, documentationPath);
      } else {
        addCookbookPages(documentationPath + file + "/" );
      }
    }
  }
  
  // categorizes the folders 
  private function createSitemap() {
    for (key in _folders.keys()) {
      var structure = key.split("/");
      structure.pop();
      var id = structure.pop();
      if (key.indexOf("cookbook/") == 0) {
        sitemap.push(new Category(id.toLowerCase(), id, key, _folders.get(key)));
      }
    }
  }
  
  // collects all tags and counts them
  private function collectTags() {
    tags = new StringMap<Array<Page>>();
    for (page in _pages) {
      if (page.tags != null) {
        for (tag in page.tags) {
          tag = tag.toLowerCase();
          if (!tags.exists(tag)) {
            tags.set(tag, []);
          }
          tags.get(tag).push(page);
        }
      }
    }
  }
  
  private function replaceTryHaxeTags(content:String) {
    //[tryhaxe](http://try.haxe.org/embed/ae6ef)
    return  ~/(\[tryhaxe\])(\()(.+?)(\))/.replace(content, '<iframe src="$3" class="try-haxe"><a href="$3">Try Haxe!</a></iframe>');
  }
  
  private function getDocumentationTitle(path:String) {
    // pick first header `# mytitle` from markdown file
    var lines = File.getContent(contentPath + path).split("\n");
    var prefix = "# ";
    for (line in lines) {
      if (line.substr(0, prefix.length) == prefix) return line.substr(prefix.length);
    }
    return null;
  }
  
  private function getCategory(page:Page):Category {
    for (category in sitemap) {
      if (category.pages.indexOf(page) != -1 ) {
        return category;
      }
    }
    return null;
  }
  
  private function getBaseHref(page:Page) {
    var href = [for (s in page.outputPath.split("/")) ".."];
    href[0] = ".";
    return href.join("/");
  }
  
  private function getTags(path:String) {
    // pick first header `# mytitle` from markdown file
    var lines = File.getContent(contentPath + path).split("\n");
    var prefix = "[tags]: / \"";
    for (line in lines) {
      if (line.substr(0, prefix.length) == prefix) {
        return line.substr(prefix.length, line.length-prefix.length-1).replace('"',"").toLowerCase().split(",");
      }
    }
    return null;
  }
  
  public inline function getEditUrl(page:Page) {
    return '${repositoryUrl}edit/${repositoryBranch}/${contentPath}${page.contentPath}';
  }
  
  public inline function getContributionUrl(page:Page) {
    return '${repositoryUrl}tree/${repositoryBranch}/${contentPath}${page.contentPath}';
  }
  
  public inline function getAddLinkUrl(category:Category  = null, page:Page = null) {
    var fileNameHint = "/snippet-name.md/?filename=snippet-name.md";
    var directory = if (category != null) {
      getDirectory(category.pages[0].contentPath);
    } else {
      getDirectory(page.contentPath);
    }
    return '${repositoryUrl}new/master/${contentPath}${directory}${fileNameHint}';
  }
  
  public inline function getAbsoluteUrl(page:Page) {
    return domain + page.outputPath;
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
  
  private function getContent(file:String, data) {
    return switch(getExtension(file)) {
      case "md": Markdown.markdownToHtml(replaceTryHaxeTags(File.getContent(file)));
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
  public var tags:Array<String>;
  
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
  
  public function setTags(tags:Array<String>):Page {
    this.tags = tags;
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
