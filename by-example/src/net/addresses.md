# Addresses

An `IpAddress` is an IPv4 or IPv6 address held as a value: copy it, compare it
with `Equals`, print it with `ToString( )`. A `SocketAddress` is an address and
a port — what a connection is made to.

```tiko
{{#include ../../examples/net/addresses.tiko}}
```

**Output**

```text
{{#include ../../examples/net/addresses.out}}
```

**Parsing is strict.** `192.168.000.001` is refused: some programs read a
leading zero as octal, others as decimal, and an address that two programs
read differently is how a filter gets bypassed. IPv6 is accepted in any of its
spellings and printed in one.

The `Is…` questions sort addresses into kinds: `IsLoopback` (this machine),
`IsPrivate` (10/8, 172.16/12, 192.168/16, fc00::/7), `IsLinkLocal`,
`IsMulticast`, `IsUnspecified` and `IsGlobalUnicast`. An IPv4 address written
as IPv6 (`::ffff:192.168.0.1`) is answered as the IPv4 address it holds;
`Unmap( )` turns it back.

`ParseSocketAddress` needs the port, and brackets around an IPv6 address,
because its colons would otherwise run into the port's. `Loopback( )` and
`Any_( )` are the two addresses a program names most: this machine, and every
interface of it.

`Resolve( host, port )` asks the system for a name's addresses and returns all
of them, each with the port. An address written as text is returned as it is,
without asking anyone.

### Activities

1. Add `Show( "fe80::1%eth0" )` and print `Zone( )` for it.
2. Resolve `"localhost"` and print every address it has on your machine.
