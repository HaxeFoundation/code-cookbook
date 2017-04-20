# how to set up vscode for haxe usage:

## *Installation*
* Install `Visual Studio Code` from the website:
<https://code.visualstudio.com/>
* In VSCode, type `Ctrl+Shift+X` or click the extensions icon.
  
  In the search box, type `haxe`. choose `HaxeSupport`. click the `Install` button. `Restart`.

## *vscode with your haxe project*
### *code completion*:
* In VSCode's file menu: `File` -> `Open Folder`: choose the project folder or create a new one.
  
  Next press `F1`, type `haxeinit`
you'll see: `Haxe: Initialize VS Code project`
click or press `enter` to run this command.

* note: if this command fails, delete the .vscode folder (hidden folder) that resides in your project folder (the one you selected previously).

**by now, you should have code completions working.**

### *Debugging*:
Debugging works well with the javascript target.

Press `F5`, you'll see the words: `Select Environment` -> choose `Node.js`.  
A file `launch.json` will open up.  
In the `"configurations"` key you'll see the key `"program"`.  
Set it to the js output file as defined in your `build.hxml` file.

For example:  
 ```"program": "${workspaceRoot}/bin/app.js"```  
and in your `build.hxml` file:
```haxe
-main MyMainClass
-js bin/app.js
```
Now press `F5` again, to run your app with debug support.

*Note*:  
 you'll have to `build` before `running`.  
 the default keyboard shortcut is `Ctrl+Shift+B`.  
 You can set it to something more convenient (like `F8`) in `File menu` -> `Preferences` -> `Keyboard Shortcuts`

## *Other things for useful workflow:* 
- **Auto save feature.**  
 Add the following lines to `user settings` - `File` -> `Preferences` -> `User Settings`):   

	"files.autoSave": "afterDelay",  
	"files.autoSaveDelay": 200,
- **keyboard shortcuts:**  
	{ "key": "F8",          "command": "workbench.action.tasks.build" },  
	{ "key": "f4",                    "command": "workbench.action.showErrorsWarnings"}