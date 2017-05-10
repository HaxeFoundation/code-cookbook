# Loading an external file

This example uses `haxe.Http` to load external json file using and demonstrates how to handle the result.

## Loading a json file 

The following example loads your IP-address using a free-to-use web API. The service returns JSON formatted string `data`. 
This string is parsed to an object `result` using the `haxe.Json.parse` function. After this, we trace the IP-address `result.ip`.

```haxe
var http = new haxe.Http("https://api.ipify.org?format=json");

http.onData = function (data:String) {
  var result = haxe.Json.parse(data);
  trace('Your IP-address: ${result.ip}');
}

http.onError = function (error) {
  trace('error: $error');
}

http.request();
```

> **More on this topic: **
> 
> * [haxe.Http API documentation](http://api.haxe.org/haxe/Http.html)
