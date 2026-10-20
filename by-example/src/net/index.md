# Networking

The `std/net` module talks to other machines. It has three parts: IP
addresses and host lookup, TCP and UDP sockets, and URLs. Like `std/fs`, every
operation that can fail returns a `Result`, so a refused connection or a
malformed address is a value you look at, not a crash.

```tiko
{{#include ../../examples/net/overview.tiko}}
```

**Output**

```text
{{#include ../../examples/net/overview.out}}
```

`ParseIp` reads an address and `ToString( )` writes it back in its standard
form, which for IPv6 is lower case with the longest run of zeros written `::`.
`300.1.2.3` is not an address, and the failure's `Message( )` says which call
refused what. `ParseUrl` takes a URL apart into fields; the path comes back
decoded, `%20` as a space.

Every socket call **waits** until it is done or until its timeout runs out.
The examples in this section connect only to this machine, so they run
anywhere, with or without a network.

The pages in this section:

- [Addresses](addresses.md): IPv4 and IPv6, ports, and looking up a name.
- [TCP](tcp.md): a connection, which reads and writes like a file.
- [UDP](udp.md): single messages, sent and received whole.
- [URLs](urls.md): taking URLs apart, resolving links, query strings.

### Activities

1. Parse `"::1"` and print `IsLoopback( )`.
2. Print `u.Value( ).Query( ).Get( "x" ).ValueOr( "" )` for the URL above.
