package;
import GitUtil.GitDates;
import haxe.Timer;
import haxe.ds.StringMap;
import markdown.AST.ElementNode;
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
    
    // add tags to the home page (used for meta keywords)
    _pages[0].tags = [for (tag in tags.keys()) tag];
    
    Timer.measure(function() {
      for(page in _pages) {
        // set the data for the page
        var category = getCategory(sitemap, page);
        var data = {
          title: category != null ? '${page.title} - ${category.title} $titlePostFix' : '${page.title} $titlePostFix', 
          now: Date.now(),
          pages: _pages,
          currentPage: page,
          currentCategory: category,
          sitemap: sitemap,
          basePath: basePath,
          tags: tags,
          pageContent: null,
          DateTools: DateTools,
          getTagTitle:getTagTitle,
        }
        if (page.contentPath != null) 
        {
          page.addLinkUrl = (category != null) ? getAddLinkUrl(category) : getAddLinkUrl(page);
          data.pageContent = page.pageContent != null ? page.pageContent : getContent(contentPath + page.contentPath, data);
        }
        
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
        
        // make output directory if needed
        var targetDirectory = getDirectoryPath(outputPath + page.outputPath);
        if (!FileSystem.exists(targetDirectory)) {
          FileSystem.createDirectory(targetDirectory);
        }
        
        // write output to file
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
    
    page.absoluteUrl = getAbsoluteUrl(page);
    page.baseHref = getBaseHref(page);
    
    if (page.contentPath !=null) {
      page.dates = GitUtil.getStat(contentPath + page.contentPath);
      page.contributionUrl = getContributionUrl(page);
      page.editUrl = getEditUrl(page);
    }
    
    if (folder != null) {
      if (!_folders.exists(folder)) {
        _folders.set(folder, []);
      }
      _folders.get(folder).push(page);
    }
  }
  
  private function addCategoryPages(sitemap:Array<Category>) {
    for (category in sitemap) {
      addPage(new Page("layout-page-toc.mtt",  "table-of-content.mtt",  'category/${category.id}/index.html')
                        .setTitle('Haxe ${category.title} articles overview')
                        .setDescription('Overview of Haxe ${category.title.toLowerCase()} snippets and tutorials.')
                        .hidden(), category.folder);
    }
  }
  
  private function addTagPages(tags:StringMap<Array<Page>>) {
    for (tag in tags.keys()) {
      var tagTitle = getTagTitle(tag);
      addPage(new Page("layout-page-toc.mtt",  "tags.mtt", 'tag/$tag.html')
                        .setTitle('Haxe $tagTitle articles overview')
                        .setCustomData({tag:tag, pages: tags.get(tag)})
                        .setDescription('Overview of Haxe snippets and tutorials tagged with $tagTitle.')
                        .hidden(), "tags");
    }
  }
  
  private function addGeneralPages() {
    var homePage = new Page("layout-page-main.mtt", "index.mtt", "index.html")
                          .setTitle("Easy to read Haxe coding examples")
                          .setDescription('The Haxe Code Cookbook is a central place with Haxe coding snippets and tutorials.');
    
    var errorPage = new Page("layout-page-main.mtt", "404.mtt", "404.html")
                          .hidden()
                          .setTitle("Page not found");
    
    var sitemapPage = new Page("sitemap.mtt", null, "sitemap.xml")
                          .hidden()
                          .setTitle("Sitemap");
    
    addPage(homePage, "/home");
    addPage(errorPage, "/404");
    addPage(sitemapPage, "/sitemap");
  }
  
  private function addCookbookPages(documentationPath:String = "cookbook/") {
    for (file in FileSystem.readDirectory(contentPath + documentationPath)) {
      if (!FileSystem.isDirectory(contentPath + documentationPath + file)) {
        var page = new Page("layout-page-snippet.mtt", 
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

  private function getTagTitle(tag:String):String {
    return tag.replace("-", " ");
  }

  // categorizes the folders 
  private function createSitemap():Array<Category> {
    var sitemap = [];
    for (key in _folders.keys()) {
      var structure = key.split("/");
      structure.pop();
      var id = structure.pop();
      if (key.indexOf("cookbook/") == 0) {
        var category = new Category(id.toLowerCase().replace(" ", "-"), id.replace("-", " "), key, _folders.get(key));
        category.absoluteUrl = basePath + category.outputPath;
        sitemap.push(category);
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
  
  private function replaceAuthor(content:String) {
    //Author: [name](url) / [name](url) 
    if (content.indexOf("Author:") != -1) {
      var authorLineOld = content.split("Author:").pop().split("\n").shift();
      var authorline = ~/\[(.*?)\]\((.+?)\)/g.replace(authorLineOld, '<a href="$2" itemprop="url" rel="external"><span itemprop="name">$1</span></a>');
      authorline = '<span itemprop="author" itemscope="itemscope" itemtype="https://schema.org/Person">$authorline</span>';
      return  content.replace(authorLineOld, authorline);
    } else {
      return content;
    }
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
    return basePath + page.outputPath.replace("index.html","");
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
    var markdown = File.getContent(contentPath + file);
    markdown = replaceTryHaxeTags(markdown);
    markdown = replaceAuthor(markdown);
    
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
              blocks.remove(block);
              continue;
            }
            if (hasTitle && el.tag == "p" && page.description == null) {
              var description = new markdown.HtmlRenderer().render(el.children);
              page.description = new EReg("<(.*?)>", "g").replace(description, "");
            }
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
  public var description:String;
  public var templatePath:String;
  public var contentPath:String;
  public var outputPath:String;
  public var customData:Dynamic;
  public var tags:Array<String>;
  public var absoluteUrl:String;
  public var editUrl:String;
  public var addLinkUrl:String;
  public var contributionUrl:String;
  public var baseHref:String;
  public var dates:GitDates;
  
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
  
  public function setDescription(description:String):Page {
    this.description = description;
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
  public var outputPath:String;
  public var absoluteUrl:String;
  public var id:String;
  public var folder:String;
  public var pages:Array<Page>;
  
  public function new(id:String, title:String, folder:String, pages:Array<Page>){
    this.id = id;
    this.title = title;
    this.folder = folder;
    this.pages = pages;
    this.outputPath = 'category/$id/';
  }
  
  public function getPageCount():Int {
    return [for (page in pages) if (page.visible) page].length;
  }
}
