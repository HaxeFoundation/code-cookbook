[tags]: / "server,multi-threading,hxcpp"

# Prototype SSL Socket Server

This write-up was inspired by [this stack overflow question](https://stackoverflow.com/questions/56418671/how-to-use-haxe-ssl-socket/56692779#56692779).
While I've worked with sockets before, I wanted to prototype a Haxe HXCPP socket server leveraging secure SSL connections.

### OS Note

I use Linux, so this write-up is written from that perspective. Commands shown will likely
be similar on OSX. Windows users will have to modify some commands. I used Haxe 4.0.0-rc1 and hxcpp
4.0.19 for this test.

### Getting Started

The first thing you'll need for playing with SSL is a certificate and a key file. There are
apparently ways to make this work for localhost, but since the whole point of a cert is to
prove domain ownership, I prefer to play with real certs. You
can get them for free (for domains that you own and control -- you'll have to provide verification)
from [letsencrypt.org](https://letsencrypt.org).

Notes on using cert files:
- You may need to convert your files to PEM format (Google or `openssl` CLI tool may help you).
- You may sometimes need to concatenate multiple intermediate / CA pem files into an overall `chain.pem` file.
- If you can't get SSL certificates, you could comment out all the SSL bits, and just test the
socket server, if you like.

In the below example, I'm using `foo.example.com` as the hostname. Your hostname will vary and
your cert files are bound to a specific hostname, such as `myhost.mydomain.com`. Some certs
are valid for multiple hosts via a wildcard cert (e.g. `*.mydomain.com`).

### cpp.Lib.stringReference note

Note: until [this issue](https://github.com/HaxeFoundation/haxe/issues/8457) is fixed in Haxe, you may need to alter `haxe/std/cpp/_std/sys/ssl/Key.hx` line 17 to use
`toString()` instead of `cpp.Lib.stringReference()` as follows:

```haxe
var str = data.toString(); // cpp.Lib.stringReference(data);
```

### About the Server

This example server uses [Threads](https://api.haxe.org/cpp/vm/Thread.html), where the main thread accepts
connections, and then passes each connected client socket off to a reader thread. The reader thread
simply calls `Sys.print()` with any data received, and gracefully exits if an end-of-file (`Eof`) is received.

Using threads, thread messages, and blocking sockets is an efficient design. That way, a thread can simply
sleep until the socket wakes it up. Which is what you want, as opposed to the CPU spinning in a while loop,
endlessly checking if a socket is unblocked.

The server loads my private key and certificate chain files, and listens on port 8000.

### The Code

```haxe
import sys.net.Host;
import sys.net.Socket;
import sys.ssl.Socket as SocketSSL; // aliased to avoid conflict with sys.net.Socket
import sys.ssl.Certificate;
import sys.ssl.Key;

import cpp.vm.Mutex;
import cpp.vm.Thread;

class Main
{
  static var _mutex:Mutex = new Mutex();

  public static function main()
  {
    var _oSocketMaster =  new SocketSSL();
    var cert = Certificate.loadFile('my_chain.pem');
    _oSocketMaster.setCA(cert);
    _oSocketMaster.setCertificate(cert, 
                                  Key.loadFile('my_private.key'));
    _oSocketMaster.setHostname('foo.example.com');

    // e.g. for an application like an HTTPs server, the client
    // doesn't need to provide a certificate. Otherwise we get:
    // Error: SSL - No client certification received from the client, but required by the authentication mode
    _oSocketMaster.verifyCert = false;

    // Binding 0.0.0.0 means, listen on "any / all IP addresses on this host"
    _oSocketMaster.bind( new Host( '0.0.0.0' ), 8000);
    _oSocketMaster.listen( 9999 );

    while(true) {

      // Accepting socket
      trace('waiting to accept...');
      var oSocketDistant:SocketSSL = _oSocketMaster.accept();
      if ( oSocketDistant != null ) {
        trace( 'got connection from : ' + oSocketDistant.peer() );
        oSocketDistant.handshake(); // This may not be necessary, if !verifyCert

        // Spawn a reader thread for this connection:
        var thrd = Thread.create(reader);
        trace('sending socket...');
        thrd.sendMessage(oSocketDistant);
        trace('ok...');
      }

    }
  }

  static function reader()
  {
    var oSocketDistant:sys.net.Socket = cast Thread.readMessage(true);
    trace('new reader thread...');

    while(true) {

      try {
        Sys.print( oSocketDistant.input.readString(1) );
      } catch ( e:haxe.io.Eof ) {
        trace('Eof, reader thread exiting...');
        return;
      } catch ( e:Dynamic ) {
        trace('Uncaught: ${ e }'); // throw e;
      }
    }
  }
}
```

### Testing the Server

So, let's see it in action!

My project directory contains `Main.hx`, as well as my cert files, `my_chain.pem` and `my_private.key`.

I compile and start the server in one terminal:

```
> haxe -main Main -debug -cpp out && ./out/Main-debug
...compiling info removed...
Main.hx:37: waiting to accept...
```

And then I connect from another terminal with a client that's a command line utility for testing ssl connections:

```
> openssl s_client -connect foo.example.com:8000
...lots of info about the cert...
SSL handshake has read 3374 bytes and written 370 bytes
Verification: OK
---
```

And it hangs there, waiting for you to type input. On the server side we see:

```
Main.hx:38: got connection from : { host => Host, port => 57394 }
Main.hx:43: sending socket...
Main.hx:45: ok...
Main.hx:35: waiting to accept...
Main.hx:54: new reader thread...
```

Typing messages into the client terminal, those messages are echoed on the server side as expected.

We can open many clients in separate terminals, they each get their own reader thread.

In the client terminal, hitting `CTRL+C` exits the client, and on the server we see:

```
Main.hx:61: Eof, reader thread exiting...
```

The reader thread exits gracefully, while the server is still running.

Everything is working as expected!

### Next Steps

When you're ready to take your server past the prototype phase, you'll want to pass some "data processor"
thread to the reader threads (the same way the socket is passed, via `Thread.sendMessage()`.) Then when
the reader receives data from a client, it would send that data to the data processor thread.

```
> Author: [Jeff Ward](https://github.com/jcward)
