# TCP

TCP is a connection: a stream of bytes in each direction between two programs.
A `TcpListener` waits for connections and a `TcpStream` is one end of one. The
example plays both sides on this machine.

```tiko
{{#include ../../examples/net/tcp.tiko}}
```

**Output**

```text
{{#include ../../examples/net/tcp.out}}
```

`Bind` to port 0 lets the system choose a free port, and `LocalAddress( )` says
which. `Connect` takes a `SocketAddress` and a timeout in milliseconds;
`ConnectHost( "example.com", 80, 5000 )` looks a name up first and tries its
addresses in turn. `Accept` waits for the next connection and opens the
`TcpStream` it is given.

**A `TcpStream` is a stream**, the same kind as an open file, so `WriteUtf8`,
`WriteAll`, `ReadExact` and `ReadToEnd` work on it. A plain `Read` returns
whatever has arrived, which may be less than asked for: TCP delivers bytes, not
the pieces they were written in. A read of 0 bytes means the other end has
finished.

Reads and writes report an `fs.FsError`, as a file's do: `FS_TIMED_OUT` when a
`SetReadTimeout` runs out, `FS_CONNECTION_RESET` when the other end drops the
connection. Connecting, binding and accepting report a `NetError`, such as
`NET_CONNECTION_REFUSED` when nothing listens on the port.

### Activities

1. Close `server` before connecting and print the `Connect` failure's
   `Message( )`.
2. Send 100,000 bytes with `WriteAll` and read them on the other side with
   `ReadExact`. Then call `client.SetWriteTimeout( 2000 )` and try
   10,000,000. Why does the write give up when nobody reads yet?
