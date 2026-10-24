[Home](Home) › [Function Finder](Function-Finder) › **Networking**

# Networking

The functions to look up hosts, connect over TCP and UDP, parse and build URLs, fetch web pages over HTTP and HTTPS, grouped by what you want to do. The **From** column says what a program needs before it can call one:

- `std/<Name>`: `#import "std/<Name>"`, then `using <Name>` to call it by its bare name.

Jump to: [Parse, print and classify IP addresses](#parse-print-and-classify-ip-addresses) · [Look up a host name](#look-up-a-host-name) · [Connect to a TCP server](#connect-to-a-tcp-server) · [Read and write a TCP connection](#read-and-write-a-tcp-connection) · [Accept TCP connections](#accept-tcp-connections) · [Send and receive UDP datagrams](#send-and-receive-udp-datagrams) · [Take a URL apart and build one](#take-a-url-apart-and-build-one) · [Read and build query strings](#read-and-build-query-strings) · [Find out why a network call failed](#find-out-why-a-network-call-failed) · [Fetch a web page or call a web API](#fetch-a-web-page-or-call-a-web-api) · [Read a large download as it arrives](#read-a-large-download-as-it-arrives) · [Encrypt a connection with TLS](#encrypt-a-connection-with-tls) · [Find out why an HTTP request or TLS handshake failed](#find-out-why-an-http-request-or-tls-handshake-failed)

## Parse, print and classify IP addresses

| Function | What it does | From |
|---|---|---|
| [ParseIp](Category-Net#ip-addresses) | Parses IPv4 or IPv6 text, with an optional zone, and refuses leading zeros. | `std/net` |
| [IpAddress](Category-Net#ip-addresses) | Holds one IPv4 or IPv6 address as a value that can be copied and compared. | `std/net` |
| [IpAddress.ToString](Category-Net#ip-addresses) | Returns the address as text, IPv6 in its shortest lower-case form. | `std/net` |
| [IpAddress.IsLoopback / IsPrivate / IsLinkLocal](Category-Net#ip-addresses) | Tells whether the address is loopback, private or link-local. | `std/net` |
| [IpAddress.IsMulticast / IsUnspecified / IsGlobalUnicast](Category-Net#ip-addresses) | Tells whether the address is multicast, all zeros or an ordinary unicast address. | `std/net` |
| [IpAddress.IsV4Mapped / Unmap](Category-Net#ip-addresses) | Recognises an IPv4 address written as IPv6 and turns it back into IPv4. | `std/net` |
| [Ipv4](Category-Net#ip-addresses) | Returns the IPv4 address made of four numbers. | `std/net` |
| [IpFromBytes](Category-Net#ip-addresses) | Returns the address held in 4 or 16 bytes. | `std/net` |
| [Loopback](Category-Net#ip-addresses) | Returns 127.0.0.1, or ::1 when asked for IPv6. | `std/net` |
| [AnyAddress](Category-Net#ip-addresses) | Returns 0.0.0.0 or ::, the address that binds every interface. | `std/net` |
| [SocketAddress](Category-Net#ip-addresses) | Holds an IP address and a port, printed as 1.2.3.4:80 or [::1]:80. | `std/net` |
| [ParseSocketAddress](Category-Net#ip-addresses) | Parses an address and port, with brackets around IPv6. | `std/net` |

## Look up a host name

| Function | What it does | From |
|---|---|---|
| [Resolve](Category-Net#looking-up-host-names) | Looks up a host name and returns every address it has, each with the given port. | `std/net` |

## Connect to a TCP server

| Function | What it does | From |
|---|---|---|
| [TcpStream](Category-Net#tcp-connections) | Holds one TCP connection, which reads and writes like any stream. | `std/net` |
| [TcpStream.Connect](Category-Net#tcp-connections) | Connects to an address and port, giving up after an optional timeout. | `std/net` |
| [TcpStream.ConnectHost](Category-Net#tcp-connections) | Looks up a host and connects to the first of its addresses that answers. | `std/net` |

## Read and write a TCP connection

| Function | What it does | From |
|---|---|---|
| [TcpStream.SetReadTimeout / SetWriteTimeout](Category-Net#tcp-connections) | Makes a read or write that waits too long fail with a timeout. | `std/net` |
| [TcpStream.SetNoDelay](Category-Net#tcp-connections) | Sends small writes at once instead of gathering them. | `std/net` |
| [TcpStream.SetKeepAlive](Category-Net#tcp-connections) | Probes an idle connection so that a dead peer is noticed. | `std/net` |
| [TcpStream.Shutdown](Category-Net#tcp-connections) | Tells the peer no more data is coming, so its reads end. | `std/net` |
| [TcpStream.LocalAddress / PeerAddress](Category-Net#tcp-connections) | Returns the address and port of this end or of the other end. | `std/net` |
| [TcpStream.Close](Category-Net#tcp-connections) | Closes the connection; closing twice is harmless. | `std/net` |

## Accept TCP connections

| Function | What it does | From |
|---|---|---|
| [TcpListener](Category-Net#tcp-servers) | Holds a listening socket that waits for TCP connections. | `std/net` |
| [TcpListener.Bind](Category-Net#tcp-servers) | Binds an address and port and starts listening; port 0 picks a free one. | `std/net` |
| [TcpListener.Accept](Category-Net#tcp-servers) | Waits for the next connection and opens a TcpStream on it, with an optional timeout. | `std/net` |
| [TcpListener.LocalAddress](Category-Net#tcp-servers) | Returns the address and port the listener is bound to. | `std/net` |

## Send and receive UDP datagrams

| Function | What it does | From |
|---|---|---|
| [UdpSocket](Category-Net#udp) | Holds a socket that sends and receives single datagrams. | `std/net` |
| [UdpSocket.Bind](Category-Net#udp) | Receives datagrams on an address and port. | `std/net` |
| [UdpSocket.SendTo / ReceiveFrom](Category-Net#udp) | Sends a datagram to an address, or waits for one and reports its sender. | `std/net` |
| [UdpSocket.Connect / Send / Receive](Category-Net#udp) | Fixes the other end, then sends and receives without naming it. | `std/net` |
| [UdpSocket.SetReadTimeout](Category-Net#udp) | Makes a receive that waits too long fail with a timeout. | `std/net` |
| [UdpSocket.SetBroadcast / JoinMulticast](Category-Net#udp) | Allows broadcast sends, or receives a multicast group. | `std/net` |

## Take a URL apart and build one

| Function | What it does | From |
|---|---|---|
| [ParseUrl](Category-Net#urls) | Takes a URL apart into scheme, user, host, port, decoded path, query and fragment. | `std/net` |
| [Url](Category-Net#urls) | Holds a URL as fields that can be read, changed and printed again. | `std/net` |
| [Url.ToString](Category-Net#urls) | Returns the URL as text, escaping each part only as much as it needs. | `std/net` |
| [Url.Resolve](Category-Net#urls) | Makes a relative link absolute against this URL, removing . and .. segments. | `std/net` |
| [Url.HostPort / EscapedPath](Category-Net#urls) | Returns host:port, or the path as it appears in the URL. | `std/net` |

## Read and build query strings

| Function | What it does | From |
|---|---|---|
| [Url.Query](Category-Net#urls) | Returns the URL's query string parsed into QueryValues. | `std/net` |
| [ParseQuery](Category-Net#query-strings) | Parses name=value pairs, decoding percent escapes and plus signs. | `std/net` |
| [QueryValues](Category-Net#query-strings) | Holds query pairs in order, where one name may appear more than once. | `std/net` |
| [QueryValues.Get / GetAll](Category-Net#query-strings) | Returns the first value of a name, or every value of it. | `std/net` |
| [QueryValues.Add / SetValue / Remove](Category-Net#query-strings) | Appends a pair, replaces a name's values, or removes a name. | `std/net` |
| [QueryValues.Encode](Category-Net#query-strings) | Returns the pairs as query text in order, with spaces as plus signs. | `std/net` |

## Find out why a network call failed

| Function | What it does | From |
|---|---|---|
| [NetError](Category-Net#errors) | Holds why a network call failed: a code, the system's number and a message. | `std/net` |
| [NetErrorMessage](Category-Net#errors) | Returns the fixed English text for a NetErrorCode. | `std/net` |

## Fetch a web page or call a web API

| Function | What it does | From |
|---|---|---|
| [Fetch](Category-Http#a-client) | Fetches a URL with GET on a fresh client and returns the whole response. | `std/http` |
| [Post](Category-Http#a-client) | Posts a text body to a URL on a fresh client and returns the whole response. | `std/http` |
| [Client](Category-Http#a-client) | Holds the request settings and reuses connections to the same host. | `std/http` |
| [Client.Fetch](Category-Http#a-client) | Fetches a URL with GET and returns the whole response. | `std/http` |
| [Client.Head](Category-Http#a-client) | Sends a HEAD request and returns the status and headers. | `std/http` |
| [Client.Post](Category-Http#a-client) | Posts a text body with its content type and returns the whole response. | `std/http` |
| [Client.Send](Category-Http#requests) | Sends a Request, follows redirects and reads the whole body into a Response. | `std/http` |
| [Request](Category-Http#requests) | Holds a method, URL, headers and body to send. | `std/http` |
| [Request.SetBody](Category-Http#requests) | Sets the body as UTF-8 text and its Content-Type. | `std/http` |
| [Request.SetBasicAuth](Category-Http#requests) | Adds an Authorization: Basic header for a user name and password. | `std/http` |
| [Response](Category-Http#responses) | Holds the status, headers, final URL and body of a reply. | `std/http` |
| [Response.Text](Category-Http#responses) | Returns the body decoded as UTF-8 text. | `std/http` |
| [Headers](Category-Http#responses) | Holds header fields in order, with names compared regardless of case. | `std/http` |

## Read a large download as it arrives

| Function | What it does | From |
|---|---|---|
| [Client.Open](Category-Http#reading-a-body-as-it-arrives) | Sends a request and hands the body over as a stream to read at your own pace. | `std/http` |
| [ResponseStream](Category-Http#reading-a-body-as-it-arrives) | Reads a response body as a stream and gives the connection back when closed. | `std/http` |

## Encrypt a connection with TLS

| Function | What it does | From |
|---|---|---|
| [TlsStream](Category-Http#tls-on-its-own) | Encrypts a connected stream with TLS, as a client or a server. | `std/tls` |
| [TlsStream.ConnectHost](Category-Http#tls-on-its-own) | Opens a TCP connection to a host and shakes hands as a TLS client. | `std/tls` |
| [TlsStream.Connect](Category-Http#tls-on-its-own) | Shakes hands as a TLS client over a stream that is already connected. | `std/tls` |
| [TlsStream.Accept](Category-Http#tls-on-its-own) | Shakes hands as a TLS server over an accepted connection. | `std/tls` |
| [TlsConfig](Category-Http#tls-on-its-own) | Holds the TLS version floor, extra trusted roots and a server's certificate and key. | `std/tls` |
| [TlsConfig.AddRootPem](Category-Http#tls-on-its-own) | Trusts the root certificates in PEM text as well as the system's. | `std/tls` |
| [TlsConfig.SetIdentityPem](Category-Http#tls-on-its-own) | Sets a server's certificate chain and PKCS#8 private key from PEM text. | `std/tls` |

## Find out why an HTTP request or TLS handshake failed

| Function | What it does | From |
|---|---|---|
| [HttpError](Category-Http#errors) | Holds why an HTTP request failed: a code, the URL and the lower layer's message. | `std/http` |
| [TlsError](Category-Http#errors) | Holds why a TLS handshake failed, such as an untrusted or expired certificate. | `std/tls` |

## See Also

- [Net guide](Category-Net)
- [HTTP and TLS guide](Category-Http)
- [Codec guide (percent-encoding)](Category-Codec)

---

[Home](Home) · [Function Finder](Function-Finder) · [Keyword Index](Keyword-Index)

<!-- Generated by tools/wikifinder/finder.py. Edit the data, not this page. -->
