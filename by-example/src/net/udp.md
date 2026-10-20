# UDP

UDP sends **datagrams**: single messages that arrive whole or not at all, with
no connection to set up first. A `UdpSocket` is bound to an address and port,
and then sends to and receives from anyone.

```tiko
{{#include ../../examples/net/udp.tiko}}
```

**Output**

```text
{{#include ../../examples/net/udp.out}}
```

`SendTo( p, n, address )` sends `n` bytes as one datagram. `ReceiveFrom( p, n,
from )` waits for the next one and fills `from` with its sender, so a server
knows where to reply. A datagram longer than the buffer fills the buffer, and
the rest is lost: the receive fails with `NET_MESSAGE_TOO_LONG` so the program
knows it saw only part of it.

`Connect( address )` fixes the other end; after it, `Send` and `Receive` need
no address, and datagrams from anyone else are not delivered. Nothing promises
that a datagram arrives, or that two arrive in the order they were sent: on
this machine they do, across a network they may not.

### Activities

1. Reply from `b` to `from`, and receive the reply on `a`.
2. Use `a.Connect` and `a.Send` instead of `SendTo`.
