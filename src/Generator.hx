package;
import haxe.Timer;
import haxe.ds.StringMap;
import markdown.AST.ElementNode;
import markdown.AST.TextNode;
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
  public var basePath = "";
  public var titlePostFix = "";
  
  private var _pages:Array<Page> = new Array<Page>();
  private var _folders:StringMap<Array<Page>> = new StringMap<Array<Page>>();
  
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
    var tags:StringMap<Array<Page>> = collectTags();
    var sitemap:Array<Category> = createSitemap();
    addCategoryPages(sitemap);
    addTagPages(tags);
    
    Timer.measure(function() {
      for(page in _pages) {
        // set the data for the page
        var category = getCategory(sitemap, page);
        
        var data = {
          title: '${page.title} $titlePostFix', 
          year: Date.now().getFullYear(), // we're professional now
          lastUpdated: DateTools.format(Date.now(), "%d-%m-%Y"),
          baseHref: getBaseHref(page),
          pages: _pages,
          currentPage: page,
          currentCategory: category,
          contributionUrl: getContributionUrl(page),
          editUrl: getEditUrl(page),
          addLinkUrl: (category != null) ? getAddLinkUrl(category) : getAddLinkUrl(page),
          absoluteUrl: getAbsoluteUrl(page),
          sitemap: sitemap,
          tags: tags,
          pageContent: null,
        }
        data.pageContent = page.pageContent != null ? page.pageContent : getContent(contentPath + page.contentPath, data);
        
        // execute the template
        var template = Template.fromFile(contentPath + page.templatePath);
        var html = Minifier.removeComments(template.execute(data));
        
        if (doMinify) {
          // strip crap
          var length = html.length;
          html = Minifier.minify(html);
          var newLength = html.length;
          //trace("optimized " + (Std.int(100 / length * (length - newLength) * 100) / 100) + "%");
        }
        
        // write output into file
        var targetDirectory = getDirectoryPath(outputPath + page.outputPath);
        if (!FileSystem.exists(targetDirectory)) {
          FileSystem.createDirectory(targetDirectory);
        }
        File.saveContent(outputPath + page.outputPath, html);
      }
    });
    
    var allTags = [for (tag in tags.keys()) tag];
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
  
  private function addCategoryPages(sitemap:Array<Category>) {
    for (category in sitemap) {
      addPage(new Page("layout-page-sidebar.mtt",  "table-of-content.mtt",  'category/${category.id}/index.html')
                        .setTitle('${category.title } - table of content')
                        .hidden(), category.folder);
    }
  }
  
  private function addTagPages(tags:StringMap<Array<Page>>) {
    for (tag in tags.keys()) {
      addPage(new Page("layout-page-sidebar.mtt",  "tags.mtt",  'tag/$tag.html')
                        .setTitle('Tag - ${tag}')
                        .setCustomData({tag:tag, pages: tags.get(tag)})
                        .hidden(), "tags");
    }
  }
  
  private function addGeneralPages() {
    var homePage = new Page("layout-page-main.mtt", "index.mtt", "index.html")
                          .setTitle("Easy to read Haxe coding examples");
                          
    var errorPage = new Page("layout-page-main.mtt", "404.mtt", "404.html")
                          .setTitle("Page not found");
      
    addPage(homePage, "/home");
    addPage(errorPage, "/404");
  }
  
  private function addCookbookPages(documentationPath:String = "cookbook/") {
    for (file in FileSystem.readDirectory(contentPath + documentationPath)) {
      if (!FileSystem.isDirectory(contentPath + documentationPath + file)) {
        var page = new Page("layout-page-sidebar.mtt", 
                             documentationPath + file, 
                             documentationPath.replace('cookbook/', 'category/').toLowerCase().replace(" ", "-") + 
                                getWithoutExtension(file).toLowerCase() + ".html");
        page.pageContent = parseMarkdownContent(page, documentationPath + file);
        addPage(page, documentationPath);
      } else {
        addCookbookPages(documentationPath + file + "/" );
      }
    }
  }
  
  // categorizes the folders 
  private function createSitemap():Array<Category> {
    var sitemap = [];
    for (key in _folders.keys()) {
      var structure = key.split("/");
      structure.pop();
      var id = structure.pop();
      if (key.indexOf("cookbook/") == 0) {
        sitemap.push(new Category(id.toLowerCase().replace(" ", "-"), id, key, _folders.get(key)));
      }
    }
    return sitemap;
  }
  
  // collects all tags and counts them
  private function collectTags() {
    var tags = new StringMap<Array<Page>>();
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
    return tags;
  }
  
  private function replaceTryHaxeTags(content:String) {
    //[tryhaxe](http://try.haxe.org/embed/ae6ef)
    return  ~/(\[tryhaxe\])(\()(.+?)(\))/g.replace(content, '<iframe src="$3" class="try-haxe"><a href="$3">Try Haxe!</a></iframe>');
  }
  
  private function getCategory(sitemap:Array<Category>, page:Page):Category {
    for (category in sitemap) {
      if (category.pages.indexOf(page) != -1 ) {
        return category;
      }
    }
    return null;
  }
  
  private function getBaseHref(page:Page) {
    if (page.outputPath == "404.html") {
      return basePath;
    }
    var href = [for (s in page.outputPath.split("/")) ".."];
    href[0] = ".";
    return href.join("/");
  }
  
  public inline function getEditUrl(page:Page) {
    return '${repositoryUrl}edit/${repositoryBranch}/${contentPath}${page.contentPath}';
  }
  
  public inline function getContributionUrl(page:Page) {
    return '${repositoryUrl}tree/${repositoryBranch}/${contentPath}${page.contentPath}';
  }
  
  public function getAddLinkUrl(category:Category  = null, page:Page = null) {
    var fileNameHint = "/snippet-name.md/?filename=snippet-name.md";
    var directory = if (category != null) {
      getDirectoryPath(category.pages[0].contentPath);
    } else {
      getDirectoryPath(page.contentPath);
    }
    return '${repositoryUrl}new/master/${contentPath}${directory}${fileNameHint}';
  }
  
  public inline function getAbsoluteUrl(page:Page) {
    return basePath + page.outputPath;
  }
  
  private static inline function getDirectoryPath(file:String) {
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
  
  private function getContent(file:String, data:Dynamic) {
    return switch(getExtension(file)) {
      case "md": 
        parseMarkdownContent(null, file);
      case "mtt": 
        Template.fromFile(file).execute(data);
      default: 
        File.getContent(file);
    }
  }
  
  public function parseMarkdownContent(page:Page, file:String):String {
    var document = new Markdown.Document();
    var markdown = replaceTryHaxeTags(File.getContent(contentPath + file));

    try {
      // replace windows line endings with unix, and split
      var lines = ~/(\r\n|\r)/g.replace(markdown, '\n').split("\n");
      
      // parse ref links
      document.parseRefLinks(lines);
      
      // parse tags
      if (page != null) {
        var link = document.refLinks["tags"];
        page.tags = (link != null) ? link.title.split(",").map(function(a) return a.toLowerCase().trim()) : null;
      }
      
      // parse ast
      var blocks = document.parseLines(lines);
      
      // pick first header, use it as title for the page
      if (page != null) {
        var hasTitle = false;
        for (block in blocks) {
          var el = Std.instance(block, ElementNode);
          if (el != null) {
            if (!hasTitle && el.tag == "h1" && !el.isEmpty()) {
              page.title = new markdown.HtmlRenderer().render(el.children);
              hasTitle = true;
              #if !generator_highlight 
              break;
              #end
            }
            #if generator_highlight 
            else if (el.tag == "pre") {
              var preNode = Std.instance(el.children[0], ElementNode);
              if (preNode != null && preNode.attributes.exists("class")) {
                var className = preNode.attributes.get("class");
                if (className.indexOf("haxe") != -1 || className.indexOf("js") != -1) {
                  var codeText = Std.instance(preNode.children[0], TextNode);
                  if (codeText!=null) {
                    codeText.text = Highlighter.syntaxHighlight(codeText.text);
                    preNode.attributes.set("class", preNode.attributes.get("class")  + " highlighted");
                  }
                }
              }
            }
            #end
          }
        }
      }
      return Markdown.renderHtml(blocks);
    } catch (e:Dynamic){
      return '<pre>$e</pre>';
    }
  }
  
  public function includeDirectory(dir:String, ?path:String) {
    if (path == null) path = outputPath;
    trace("include directory: " + path);
    
    for (file in FileSystem.readDirectory(dir)) {
      var srcPath = '$dir/$file';
      var dstPath = '$path/$file';
      if (FileSystem.isDirectory(srcPath)) {
        FileSystem.createDirectory(dstPath);
        includeDirectory(srcPath, dstPath);
      } else {
        File.copy(srcPath, dstPath);
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
  
  public var pageContent:String;
  
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
