# HTTP

`std/http` fetches web pages and talks to web APIs. `http.Fetch( url )` sends
a `GET` and returns the whole reply as a `Response`: the status, the headers
and the body. `https` URLs work the same way, encrypted by `std/tls`.

```tiko
{{#include ../../examples/net/http.tiko}}
```

**Output**

```text
{{#include ../../examples/net/http.out}}
```

The example runs its own tiny server on this machine so that it needs no
network: `Serve` accepts one connection on a second thread, reads the request
and writes a reply by hand. That is the whole of HTTP/1.1 on the wire — a
status line, headers, a blank line, then the body.

On the client side `Header.Get` finds a header whatever its case, and returns
an `Optional`, because a header may be missing. `Text( )` decodes the body as
UTF-8. A status such as 404 is **not** an error: the request worked and the
server answered, so check `StatusCode`. An error is a request that could not be
made at all, like the `ftp:` URL, which `std/http` does not speak.

For more than one request make an `http.Client`: it keeps connections open and
reuses them, follows redirects, and holds settings such as `TimeoutMs`.
`Client.Open` hands the body over as a stream instead of reading it all, for
downloads too large to keep in memory.

### Activities

1. Change the server's status line to `HTTP/1.1 404 Not Found` and print
   `r.Value( ).IsSuccess( )`.
2. Fetch `"http://127.0.0.1:1/"`, where nothing listens, and print the
   failure's `Message( )`.
