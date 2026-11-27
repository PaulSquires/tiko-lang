[Home](Home) › [Using C Libraries](Using-C-Libraries-Tutorial) › **FTP, FTPS and SFTP**

# FTP, FTPS and SFTP Tutorial

> 📘 **Start with:** [Vendor Packages](Vendor-Packages), what a vendor package is and how `link static` and `link dynamic` work.
>
> 📖 **In the book:** [Chapter 25, Files over the network](https://tiko-lang.net/book/ch25-files-processes.html#files-over-the-network-ftp-and-sftp). Measured with libcurl 8.23.0 and tiko, against vsftpd 3.0 and OpenSSH 8.9 servers, on Windows, Linux (x86-64 and arm64) and macOS.

Files move between computers over **FTP** (plain, and encrypted as **FTPS**) and over SSH as **SFTP** and **SCP**. **libcurl** speaks all four behind one interface: a URL says where, a handful of options say how, and `curl_easy_perform` does it.

tiko ships libcurl as a [vendor package](Vendor-Packages), with everything it needs inside it: libssh2 for SFTP and SCP, and the encryption -- Windows' own on Windows, OpenSSL on Linux and macOS. One line gives a program libcurl's whole C API and links the library:

```freebasic
#import "vendor/libcurl"
```

There is nothing to download, no header to translate, no `#foreignlib` and nothing on the command line. The names are the ones [libcurl's documentation](https://curl.se/libcurl/c/) uses -- `curl_easy_init`, `CURLOPT_URL`, `curl_easy_perform`, `curl_easy_cleanup` -- with one difference, the **typed setters** of section 2. More programs are in the toolchain's `examples/libcurl`. To hold an SSH session yourself -- walk directories, run commands -- see the [SSH tutorial](SSH-Tutorial).

You need a server and an account on it. The programs take the host and the account as arguments:

```
ftpfirst files.example.com me secret
```

---

## 1. A first program

The program uploads a file, lists the directory, downloads the file again and deletes it:

```freebasic
'' FTP from tiko with libcurl: upload a file, list the directory,
'' download it back, delete it.
''     ftpfirst host user password
#import "vendor/libcurl"
#include once "crt/string.bi"

'' curl hands a download to this, a piece at a time.
function OnData cdecl ( byval p as zstring ptr, byval size as uinteger, _
                        byval n as uinteger, byval sink as any ptr ) as uinteger
    dim as string ptr s = sink
    dim as uinteger had = len( *s )
    *s &= space( size * n )
    memcpy( strptr( *s ) + had, p, size * n )
    return size * n                     '' anything else stops the transfer
end function

'' ...and asks this for an upload's bytes; 0 is the end.
type Upload
    as string body
    as uinteger pos_
end type
function OnRead cdecl ( byval p as zstring ptr, byval size as uinteger, _
                        byval n as uinteger, byval src as any ptr ) as uinteger
    dim as Upload ptr u = src
    dim as uinteger k = len( u->body ) - u->pos_
    if k > size * n then k = size * n
    memcpy( p, strptr( u->body ) + u->pos_, k )
    u->pos_ += k
    return k
end function

dim shared as string gHost, gUser, gPass

function NewHandle( byref path as string, byval sink as string ptr ) as CURL ptr
    dim as CURL ptr h = curl_easy_init( )
    curl_setopt_str( h, CURLOPT_URL, "ftp://" & gHost & "/" & path )
    curl_setopt_str( h, CURLOPT_USERNAME, gUser )
    curl_setopt_str( h, CURLOPT_PASSWORD, gPass )
    curl_setopt_fn( h, CURLOPT_WRITEFUNCTION, procptr( OnData ) )
    curl_setopt_ptr( h, CURLOPT_WRITEDATA, sink )
    return h
end function

gHost = command( 1 ) : gUser = command( 2 ) : gPass = command( 3 )
curl_global_init( CURL_GLOBAL_DEFAULT )
dim as string got
dim as CURLcode rc

'' Upload: CURLOPT_UPLOAD, a read callback, the size first.
dim as Upload u
u.body = "Monthly report" & chr( 10 ) & "All figures in order." & chr( 10 )
dim as CURL ptr h = NewHandle( "report.txt", @got )
curl_setopt_long( h, CURLOPT_UPLOAD, 1 )
curl_setopt_fn( h, CURLOPT_READFUNCTION, procptr( OnRead ) )
curl_setopt_ptr( h, CURLOPT_READDATA, @u )
curl_setopt_off( h, CURLOPT_INFILESIZE_LARGE, len( u.body ) )
rc = curl_easy_perform( h )
print "upload:   "; *curl_easy_strerror( rc ); ", "; str( u.pos_ ); " bytes"
curl_easy_cleanup( h )

'' A URL ending in '/' is a directory; DIRLISTONLY lists names only.
got = ""
h = NewHandle( "", @got )
curl_setopt_long( h, CURLOPT_DIRLISTONLY, 1 )
rc = curl_easy_perform( h )
print "listing:  "; *curl_easy_strerror( rc )
print got;
curl_easy_cleanup( h )

got = ""
h = NewHandle( "report.txt", @got )
rc = curl_easy_perform( h )
print "download: "; *curl_easy_strerror( rc ); ", "; _
      iif( got = u.body, "the same bytes", "DIFFERENT" )
curl_easy_cleanup( h )

'' An FTP command after a transfer of nothing: delete the file.
dim as curl_slist ptr cmds = curl_slist_append( nullptr, "DELE report.txt" )
h = NewHandle( "", @got )
curl_setopt_long( h, CURLOPT_NOBODY, 1 )
curl_setopt_ptr( h, CURLOPT_POSTQUOTE, cmds )
rc = curl_easy_perform( h )
print "delete:   "; *curl_easy_strerror( rc )
curl_easy_cleanup( h )
curl_slist_free_all( cmds )
curl_global_cleanup( )
```

Run against a test server, it prints:

```text
upload:   No error, 37 bytes
listing:  No error
pub
report.txt
up
download: No error, the same bytes
delete:   No error
```

- **`curl_global_init` once**, before any handle; `curl_global_cleanup` once at the end.
- **A handle is one transfer at a time**: set its options, `curl_easy_perform`, then `curl_easy_cleanup` (or reuse it). `curl_easy_strerror` puts a `CURLcode` into words.
- **A download arrives through a write callback** -- a `cdecl` function with curl's signature, given each piece. It must return the byte count it was handed, or curl stops the transfer. Copy the bytes with `memcpy`: a `zstring` stops at a zero byte.
- **An upload** is `CURLOPT_UPLOAD`, a read callback that fills curl's buffer and returns how much (`0` at the end), and the size up front in `CURLOPT_INFILESIZE_LARGE`.
- **A URL ending in `/` is a directory**: its listing is the download, one name a line with `CURLOPT_DIRLISTONLY`.
- **FTP commands** -- `DELE`, `RNFR` / `RNTO`, `MKD` -- go in a `curl_slist` as `CURLOPT_QUOTE` (before the transfer) or `CURLOPT_POSTQUOTE` (after); with `CURLOPT_NOBODY` there is no transfer at all. The list must live until `curl_easy_perform` returns.
- **Plain FTP is not encrypted**: the password crosses the network as it is. Use FTPS (section 3) or SFTP (section 4) anywhere you would not shout it.

## 2. The typed setters

`curl_easy_setopt( h, option, value )` is a C **variadic** function: curl reads `value` as the type its option names -- a C `long`, a `curl_off_t`, a pointer -- and a C `long` is 32 bits on Windows and 64 elsewhere. A variadic call passes what the caller wrote, so a value of the wrong width arrives wrong, with no error: a 32-bit `-1` given where curl reads a `curl_off_t` arrives as 4294967295. The package adds a setter for each kind of option, taking exactly that type:

| Setter | For the options libcurl's documentation gives as | Examples |
| --- | --- | --- |
| `curl_setopt_long( h, opt, v )` | `long` | `CURLOPT_UPLOAD`, `CURLOPT_USE_SSL`, `CURLOPT_TIMEOUT` |
| `curl_setopt_off( h, opt, v )` | `curl_off_t` | `CURLOPT_INFILESIZE_LARGE`, `CURLOPT_RESUME_FROM_LARGE` |
| `curl_setopt_str( h, opt, s )` | `char *` -- curl copies the string | `CURLOPT_URL`, `CURLOPT_USERNAME`, `CURLOPT_CAINFO` |
| `curl_setopt_ptr( h, opt, p )` | other pointers: data, lists | `CURLOPT_WRITEDATA`, `CURLOPT_QUOTE` |
| `curl_setopt_fn( h, opt, procptr( f ) )` | callbacks | `CURLOPT_WRITEFUNCTION`, `CURLOPT_XFERINFOFUNCTION` |

Reads have the same: `curl_getinfo_long`, `curl_getinfo_off`, `curl_getinfo_float64` and `curl_getinfo_str` (`CURLINFO_RESPONSE_CODE` writes a C `long`, which is not an `int64` on Windows). `curl_multi_setopt_long` / `_ptr` and `curl_share_setopt_long` / `_ptr` do the same for the multi and share interfaces. Each returns curl's code.

## 3. Encrypted: FTPS

FTPS is FTP with TLS. The same server, its certificate checked against a private CA:

```freebasic
'' FTP over TLS: the same server, encrypted, its certificate checked.
''     ftpsfirst host user password ca.crt
#import "vendor/libcurl"
#include once "crt/string.bi"

function OnData cdecl ( byval p as zstring ptr, byval size as uinteger, _
                        byval n as uinteger, byval sink as any ptr ) as uinteger
    dim as string ptr s = sink
    dim as uinteger had = len( *s )
    *s &= space( size * n )
    memcpy( strptr( *s ) + had, p, size * n )
    return size * n
end function

curl_global_init( CURL_GLOBAL_DEFAULT )
dim as string got
dim as zstring * CURL_ERROR_SIZE why
dim as CURL ptr h = curl_easy_init( )
curl_setopt_str( h, CURLOPT_URL, "ftp://" & command( 1 ) & "/" )
curl_setopt_str( h, CURLOPT_USERNAME, command( 2 ) )
curl_setopt_str( h, CURLOPT_PASSWORD, command( 3 ) )
curl_setopt_long( h, CURLOPT_DIRLISTONLY, 1 )
curl_setopt_fn( h, CURLOPT_WRITEFUNCTION, procptr( OnData ) )
curl_setopt_ptr( h, CURLOPT_WRITEDATA, @got )
curl_setopt_ptr( h, CURLOPT_ERRORBUFFER, @why )

'' TLS for the commands AND the data, or no transfer at all.
curl_setopt_long( h, CURLOPT_USE_SSL, CURLUSESSL_ALL )
'' The CA the server's certificate must chain to (a private one here).
curl_setopt_str( h, CURLOPT_CAINFO, command( 4 ) )
#ifdef TIKO_OS_WINDOWS
'' Windows asks whether the certificate was revoked; a private CA
'' publishes no list, so: check when there is one, else carry on.
curl_setopt_long( h, CURLOPT_SSL_OPTIONS, CURLSSLOPT_REVOKE_BEST_EFFORT )
#endif

dim as CURLcode rc = curl_easy_perform( h )
if rc = CURLE_OK then
    print "encrypted listing:"
    print got;
else
    print "failed: "; *curl_easy_strerror( rc ); " -- "; why
end if
curl_easy_cleanup( h )
curl_global_cleanup( )
```

```text
encrypted listing:
pub
up
```

- **`CURLUSESSL_ALL`** makes TLS a condition: the commands and the data are encrypted, or nothing happens. (`CURLUSESSL_TRY` quietly carries on unencrypted when the server says no.) That is **explicit** FTPS, an `ftp://` URL on port 21; an `ftps://` URL is **implicit** FTPS, encrypted from the first byte, on port 990.
- **The certificate is checked by default** -- its chain and that it names the host you asked for. `CURLOPT_CAINFO` names the CA for a private certificate; leave it out for one a public authority issued. Never turn `CURLOPT_SSL_VERIFYPEER` or `_VERIFYHOST` off: that is the same as no encryption against anyone who can get between you and the server.
- **On Windows**, the check also asks whether the certificate was revoked, and a private CA publishes no revocation list: without `CURLSSLOPT_REVOKE_BEST_EFFORT` the check fails (section 9).

## 4. SFTP and SCP

The same calls with an `sftp://` or `scp://` URL; libssh2 inside libcurl does the SSH:

```freebasic
'' SFTP and SCP through libcurl: the same calls as FTP, an sftp://
'' URL, and the server's host key checked against known_hosts.
''     sftpcurl host:port user keyfile known_hosts
#import "vendor/libcurl"
#include once "crt/string.bi"

function OnData cdecl ( byval p as zstring ptr, byval size as uinteger, _
                        byval n as uinteger, byval sink as any ptr ) as uinteger
    dim as string ptr s = sink
    dim as uinteger had = len( *s )
    *s &= space( size * n )
    memcpy( strptr( *s ) + had, p, size * n )
    return size * n
end function

dim shared as string gBase, gUser, gKey, gKnown

'' '~/' in an SFTP or SCP URL is the account's home directory.
function NewHandle( byref url as string, byval sink as string ptr ) as CURL ptr
    dim as CURL ptr h = curl_easy_init( )
    curl_setopt_str( h, CURLOPT_URL, url )
    curl_setopt_str( h, CURLOPT_USERNAME, gUser )
    curl_setopt_long( h, CURLOPT_SSH_AUTH_TYPES, CURLSSH_AUTH_PUBLICKEY )
    curl_setopt_str( h, CURLOPT_SSH_PRIVATE_KEYFILE, gKey )
    curl_setopt_str( h, CURLOPT_SSH_PUBLIC_KEYFILE, gKey & ".pub" )
    '' Without this, curl accepts ANY server.
    curl_setopt_str( h, CURLOPT_SSH_KNOWNHOSTS, gKnown )
    curl_setopt_fn( h, CURLOPT_WRITEFUNCTION, procptr( OnData ) )
    curl_setopt_ptr( h, CURLOPT_WRITEDATA, sink )
    return h
end function

gBase = command( 1 ) : gUser = command( 2 )
gKey = command( 3 ) : gKnown = command( 4 )
curl_global_init( CURL_GLOBAL_DEFAULT )
dim as string got
dim as CURLcode rc

'' A directory URL lists it, a line per entry, as 'ls -l' writes it.
dim as CURL ptr h = NewHandle( "sftp://" & gBase & "/~/", @got )
rc = curl_easy_perform( h )
print "sftp listing: "; *curl_easy_strerror( rc ); ", "; _
      str( len( got ) ); " bytes"
curl_easy_cleanup( h )

'' The same file by SFTP and by SCP.
for i as integer = 0 to 1
    dim as string scheme = iif( i = 0, "sftp", "scp" )
    got = ""
    h = NewHandle( scheme & "://" & gBase & "/~/pub/hello.txt", @got )
    rc = curl_easy_perform( h )
    print scheme; " download: "; *curl_easy_strerror( rc ); ": "; got;
    curl_easy_cleanup( h )
next
curl_global_cleanup( )
```

```text
sftp listing: No error, 558 bytes
sftp download: No error: hello from tikoft
scp download: No error: hello from tikoft
```

- **`CURLOPT_SSH_KNOWNHOSTS`, or curl accepts any server.** With it, a server whose key is not in the file -- or a different key -- fails the transfer. Make the file with `ssh-keyscan -p <port> <host>`, and check the fingerprint with the server's administrator.
- A key login: `CURLOPT_SSH_AUTH_TYPES` = `CURLSSH_AUTH_PUBLICKEY`, the two key files, and `CURLOPT_KEYPASSWD` for a passphrase. A password login: `CURLSSH_AUTH_PASSWORD` and `CURLOPT_PASSWORD`. Keys are OpenSSH's format or PEM, ed25519, ECDSA or RSA.
- **Paths in an SFTP or SCP URL start at the root**; `/~/` is the account's home directory.
- Uploads, listings and commands work as for FTP. The commands are SFTP's -- `rename <from> <to>` and `rm <file>` among them (`examples/libcurl/03-sftp` uses both) -- with paths relative to the home directory.

## 5. Large files: progress and resume

A download straight to a file, a progress callback that stops it after 40 MB, and a second transfer that continues from the end of the file:

```freebasic
'' A large download to a file, with progress, stopped part way and
'' then resumed from where the file ends.
''     bigfile host user password remote-file local-file
#import "vendor/libcurl"
#include once "crt/stdio.bi"

'' Write each piece straight to the open file.
function OnData cdecl ( byval p as zstring ptr, byval size as uinteger, _
                        byval n as uinteger, byval f as any ptr ) as uinteger
    return fwrite( p, size, n, cast( FILE ptr, f ) ) * size
end function

'' Called as the transfer moves; a non-zero return stops it.
dim shared as curl_off_t gStopAt
function OnProgress cdecl ( byval ud as any ptr, _
        byval dlTotal as curl_off_t, byval dlNow as curl_off_t, _
        byval ulTotal as curl_off_t, byval ulNow as curl_off_t ) as int32
    if gStopAt > 0 andalso dlNow >= gStopAt then return 1
    return 0
end function

function Fetch( byref url as string, byref local_ as string, _
                byval from as curl_off_t ) as CURLcode
    dim as FILE ptr f = fopen( local_, iif( from > 0, "ab", "wb" ) )
    dim as CURL ptr h = curl_easy_init( )
    curl_setopt_str( h, CURLOPT_URL, url )
    curl_setopt_str( h, CURLOPT_USERNAME, command( 2 ) )
    curl_setopt_str( h, CURLOPT_PASSWORD, command( 3 ) )
    curl_setopt_fn( h, CURLOPT_WRITEFUNCTION, procptr( OnData ) )
    curl_setopt_ptr( h, CURLOPT_WRITEDATA, f )
    curl_setopt_long( h, CURLOPT_NOPROGRESS, 0 )
    curl_setopt_fn( h, CURLOPT_XFERINFOFUNCTION, procptr( OnProgress ) )
    '' A curl_off_t option: curl_setopt_off, so all 64 bits arrive.
    curl_setopt_off( h, CURLOPT_RESUME_FROM_LARGE, from )
    dim as CURLcode rc = curl_easy_perform( h )
    dim as curl_off_t bytes
    curl_getinfo_off( h, CURLINFO_SIZE_DOWNLOAD_T, bytes )
    print "  "; *curl_easy_strerror( rc ); ", "; str( bytes ); _
          " bytes this time"
    curl_easy_cleanup( h )
    fclose( f )
    return rc
end function

function FileSize( byref path as string ) as curl_off_t
    dim as integer f = freefile
    if open( path for binary access read as #f ) <> 0 then return 0
    dim as curl_off_t n = lof( f )
    close #f
    return n
end function

dim as string url = "ftp://" & command( 1 ) & "/" & command( 4 )
dim as string local_ = command( 5 )
curl_global_init( CURL_GLOBAL_DEFAULT )

print "first try, stopped after 40 MB:"
gStopAt = 40000000
Fetch( url, local_, 0 )
print "on disk: "; str( FileSize( local_ ) ); " bytes"

print "resumed from there:"
gStopAt = 0
Fetch( url, local_, FileSize( local_ ) )
print "on disk: "; str( FileSize( local_ ) ); " bytes"
curl_global_cleanup( )
```

Fetching a 100 MB file:

```text
first try, stopped after 40 MB:
  Operation was aborted by an application callback, 40143920 bytes this time
on disk: 40143920 bytes
resumed from there:
  No error, 64713680 bytes this time
on disk: 104857600 bytes
```

The stopped file and the resumed one together are the server's file, byte for byte (its SHA-256 compared). Where the first transfer stops differs a little from run to run: curl calls the progress callback as data arrives.

- **The write callback can write anywhere** -- here with C's `fwrite`, straight to disk, so memory stays small however large the file.
- **`CURLOPT_XFERINFOFUNCTION`** (with `CURLOPT_NOPROGRESS` = 0) is called as the transfer moves, with the totals so far as `curl_off_t`. A non-zero return stops it: `CURLE_ABORTED_BY_CALLBACK`.
- **`CURLOPT_RESUME_FROM_LARGE`** starts at an offset -- a `curl_off_t`, so `curl_setopt_off`. `CURLINFO_SIZE_DOWNLOAD_T`, through `curl_getinfo_off`, says how much this transfer moved.

## 6. More programs

The toolchain's `examples/libcurl`, each built with `tiko <name>.tiko`, read the FTP server from `TIKO_FTP_HOST`, `TIKO_FTP_USER`, `TIKO_FTP_PASSWORD` (and `TIKO_FTP_CA`), and the SSH server from vendor/libssh2's `TIKO_SSH_*`:

| Folder | Shows |
| --- | --- |
| `01-ftp` | an upload, a name listing, a download compared with the upload, a resume from an offset, rename and delete with FTP commands, a refused login and its message |
| `02-ftps` | explicit and implicit FTPS, the certificate checked against a CA, a check that fails |
| `03-sftp` | SFTP up and down, a listing, the same file over SCP, rename and remove with SFTP commands, an unknown server refused |
| `04-progress` | 32 MiB up and down with a progress callback, curl's measured totals, a transfer the callback stops |

## 7. In a project

A [`tiko build`](Category-Tiko-Build) project needs nothing in its `tiko.toml` for libcurl: the import says it all. `tiko build`'s `copy_to` copies the shared library along with the program.

## 8. Shipping the program

- **Linked dynamically** (the default): ship the library the build put beside the program -- `libcurl.dll` on Windows, `libcurl_linux_x86_64.so` or `libcurl_linux_arm64.so` on Linux, `libcurl_macos_arm64.dylib` on macOS. It is the only file: libssh2 and the encryption are inside it. (Measured on Windows: `ftpfirst` is 24 KB, `libcurl.dll` 5.2 MB.)
- **Linked statically** (`#import "vendor/libcurl" link static`): the program alone -- `ftpfirst` is then 5.0 MB on Windows. On macOS a static program also links two system frameworks, CoreFoundation and SystemConfiguration, which the package names itself.
- libcurl carries its own libssh2: a program that imports `vendor/libssh2` too gets a second, separate copy of it.

libcurl is under the curl licence (MIT-style), libssh2 under the BSD 3-Clause licence and OpenSSL under the Apache License 2.0; the three texts are in `pkg/vendor/libcurl/LICENSE` in the toolchain, to go with a program you distribute.

## 9. Troubleshooting

Each of these was produced with the programs above:

| Symptom | Cause and fix |
| --- | --- |
| `SSL peer certificate or SSH remote key was not OK`, and `CURLOPT_ERRORBUFFER` says `schannel: the revocation status is unknown` (Windows) | a certificate from a private CA, which publishes no revocation list: add `CURLSSLOPT_REVOKE_BEST_EFFORT` to `CURLOPT_SSL_OPTIONS` |
| the same, with `schannel: the certificate chain is incomplete` (Windows) | `CURLOPT_CAINFO` does not hold the CA that signed the server's certificate |
| `Problem with the SSL CA cert (path? access rights?)` | the `CURLOPT_CAINFO` file is missing or is not a certificate |
| `SSL peer certificate or SSH remote key was not OK` with `sftp://` or `scp://` | the server's key is not in `CURLOPT_SSH_KNOWNHOSTS`'s file, or a different key is |
| `Login denied` | FTP: the user or password. SFTP: the key is not in the account's `authorized_keys`, or it has a passphrase and `CURLOPT_KEYPASSWD` is not set |
| `Could not connect to server` | nothing listening at that host and port -- **or**, for FTP after a good login, the server's passive data ports cannot be reached (a firewall or NAT in between). `CURLOPT_ERRORBUFFER` names the port it tried |
| `Operation was aborted by an application callback` | a write or read callback returned another count than it was given, or the progress callback returned non-zero |
| the program exits at once with `-1073741515` (Windows) | no `libcurl.dll` beside the program or anywhere Windows looks |

---

**Next:** [SSH](SSH-Tutorial) · [Vendor Packages](Vendor-Packages)

[Home](Home)
