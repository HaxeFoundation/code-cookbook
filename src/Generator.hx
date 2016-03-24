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
  
  private var _pages:Array<Page> = new Array<Page>();
  private var _groups:Map<String,Array<Page>> = new Map<String,Array<Page>>();
  
  public function new() {
    
  }
  
  /**
   * Build the Code Cookbook website with static website generator.
   * @param doMinify minifies the HTML output.
   */
  public function build (doMinify:Bool = false) {
    addGeneralPages();
    addCookbookPages();
    
    for (page in _pages) {
      // set the data for the page
      var data = {
        title: '${page.title} - Haxe Code Cookbook', 
        year: Date.now().getFullYear(), // we're professional now
        pages: _pages,
        groups: _groups,
        pageContent: null,
        customData: page.customData
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
  
  private function addPage(page:Page, group:String) {
    _pages.push(page);
    
    if (!_groups.exists(group)) {
      _groups.set(group, []);
    }
    _groups.get(group).push(page);
  }
  
  private function addGeneralPages() {
    var page1 = new Page("layout.mtt", "index.mtt", "index.html")
      .setTitle("Build and debug cross platform applications using Haxe");
    var page2 = new Page("layout-page-main.mtt", "index.mtt", "index.html")
      .setTitle("Build and debug cross platform applications using Haxe");
      
    addPage(page1, "/home");
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
}


class Page { 
  public var title:String;
  public var templatePath:String;
  public var contentPath: String;
  public var outputPath: String;
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
}