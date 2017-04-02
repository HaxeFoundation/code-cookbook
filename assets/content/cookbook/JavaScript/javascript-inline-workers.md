[tags]: / "javascript,workers,multi-threading"

# Javascript inline web workers in Haxe

Javascript workers make it possible to perform costly calculations (media decoding etc, crypt calculations etc.) in a background thread, without blocking the main UI. There are lots of articles about workers on the net:

- [Mozilla MDN - Using web workers](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers)
- [Html5Rocks - The basics of web workers](https://www.html5rocks.com/en/tutorials/workers/basics/)

Web workers normally require the workers to be defined in separate scripts. This is fully doable using Haxe, but requires a two step compilation process. Using some clever javascript tricks, we can define the worker code AND the parent code in the same project. This is called "inline workers". You can read more about [javascript inline workers here](https://www.html5rocks.com/en/tutorials/workers/basics/#toc-inlineworkers).

### Different inline worker approaches
Inline workers can be created in different ways. The method that's chosen here uses the same script read twice, once when the page is rendered and one when the worker is instantiated. This has the advantage that the parent and the worker share all dependencies. (Just keep in mind that they run in different threads, and that the worker can't access the DOM.)

Another approach is to create the worker script by using ```window.URL.createObjectURL```. However, it's harder to share dependencies between parent and worker that way.

The solution presented in this example here is inspired by this [StackOverflow answer](http://stackoverflow.com/a/10136565/146400) by [Delan Azabani](http://stackoverflow.com/users/330644/delan-azabani).


## Example

In the following example, the parent will create a 64 Mb data array filled with numbers counting from 0 and up. The data is passed to the worker, wich increments each data item by one and returns it to the parent. (In a real world example, the worker could be doing media decoding, password cracking or some other time-consuming calculations.)

### Creating an inline worker
Instead of creating a worker by just asking for another external script, the same script that's currently running is read once more. The script identifies itself as running on the parent or on the worker, and initializes differently because of that.

### Processing the data
The data is passed back and forth between the parent and the worker via messages, and these messages are taken care of in message handlers on each side. In this example, this handler is very simple:

The message passed to the handler is of the type ```js.html.MessageEvent```, and this has a ```.data``` property that carries the actual data.

In this example we know that the data is of the type ```ArrayBuffer``` so we can just cast it to a ```Uint8Array``` and do our simple processing (increasing every array item value by one). Now, we can simply post the altered data back to the parent:

```haxe
    // Handle message from parent to worker
    static function onMessageFromParent(e:js.html.MessageEvent) {
        trace('Worker recieved data from Client: ' + e.data);
        var uInt8View = new js.html.Uint8Array(cast e.data);
               
        // Do fancy stuff with data...
        // Here we just add one to each array item
        for (i in 0 ... uInt8View.length) uInt8View[i] += 1;
      
        // Post altered data back to parent
        workerScope.postMessage(uInt8View.buffer, [uInt8View.buffer]);
    }
```
## Running the example

The example code below should be saved in a file called ```Main.hx```;
Compile this into a js file called ```app.js``` using the following command:

```> haxe -main Main -js app.js -dce full```

Create a file called ```index.html``` with the following content
```html
<html>
    <head>
    <meta charset="utf-8" />
    <title>Haxe Inline workers</title>
    </head>
    <body>
        <script src="app.js"></script>
    </body>
</html>
```
Open the ```index.html``` in a browser window, and check the javascript console output.
You should see something like:
```code
> Original data: 0,1,2...  
> Worker recieved data from Client: [object ArrayBuffer] 
> Parent recieved data from Worker: [object ArrayBuffer] 
> Roundtrip time: 283 ms  
> Data altered by worker: 1,2,3...
```

## Note regarding transferrable object data

In this example, we are using ```transferrable object``` to speed up passing the data back and forth between the parent and the worker. Try replacing the following lines in the example code...

```untyped self.postMessage(uInt8View.buffer, [uInt8View.buffer]);```

with this:

```untyped self.postMessage(uInt8View.buffer);```

This gives you standard object copying, instead of transferrable objects. When you run the example again, you should notice a significant increase in runtrip time. (On Firefox, this is something like 10x slower.)

You can read more about [transferrable objects here](https://www.html5rocks.com/en/tutorials/workers/basics/#toc-transferrables).


## Complete example project code

```haxe
// Main.hx

class Main {

    static public function main() {
        if ( try js.Browser.document == null catch (e:Dynamic) true)              
            initAsWorker();
        else 
            initAsParent();
    }

    //=========================================================
    // Initialization

    static var workerScope:js.html.DedicatedWorkerGlobalScope;

    static function initAsWorker() {
        // Find the worker "self"
        workerScope = untyped self;

        // Setup the worker message handler:        
        workerScope.onmessage = onMessageFromParent;
    }

    static function initAsParent() {
        // Find the path of the currently running script
        var scriptPath = cast(js.Browser.document.currentScript, js.html.ScriptElement).src;        
        
        // Create the worker
        var worker = new js.html.Worker(scriptPath);

        // Setup the parent message handler:
        worker.onmessage = onMessageFromWorker;        

        // create 64Mb data to play with
        var uInt8View = new js.html.Uint8Array(new js.html.ArrayBuffer(1024 * 1024 * 64));
        for (i in 0 ... uInt8View.length) uInt8View[i] = i;
        trace('Original data: [' + uInt8View.subarray(0, 3) + '...]');

        start = Date.now().getTime();
        worker.postMessage(uInt8View.buffer, [uInt8View.buffer]);  
    }

    static var start:Float = 0;

    //=========================================================
    // Message handlers for processing data

    // Handle message passed from parent to worker
    static function onMessageFromParent(e:js.html.MessageEvent) {
        trace('Worker recieved data from Client: ' + e.data);
        var uInt8View = new js.html.Uint8Array(cast e.data);
               
        // Do fancy stuff with data...
        // Here we just add one to each array item
        for (i in 0 ... uInt8View.length) uInt8View[i] += 1;
      
        // Post altered data back to parent
        workerScope.postMessage(uInt8View.buffer, [uInt8View.buffer]);
    }
    
    // Handle message passed from worker to parent
    static function onMessageFromWorker(e:js.html.MessageEvent) {
        trace('Parent recieved data from Worker: ' + e.data);
        trace('Roundtrip time: ' + (Date.now().getTime() - start) + ' ms');            
        var uInt8View = new js.html.Uint8Array(cast e.data);
        trace('Data altered by worker: [' + uInt8View.subarray(0, 3) + '...]');
    }
}


```
> Author: [Jonas Nyström](https://github.com/cambiata)

