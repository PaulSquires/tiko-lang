[Home](Home) › [Using C Libraries](Using-C-Libraries-Tutorial) › **SSH**

# SSH Tutorial

> 📘 **Start with:** [Vendor Packages](Vendor-Packages), what a vendor package is and how `link static` and `link dynamic` work.
>
> 📖 **In the book:** [Chapter 25, Files over the network](https://tiko-lang.net/book/ch25-files-processes.html#files-over-the-network-ftp-and-sftp). Measured with libssh2 1.11.1 and tiko, against an OpenSSH 8.9 server, on Windows, Linux (x86-64 and arm64) and macOS.

**SSH** is how a program logs in to another computer securely: to move files with **SFTP** or **SCP**, or to run a command there. A program speaks it through **libssh2**, a C library for the client side of SSH.

tiko ships libssh2 as a [vendor package](Vendor-Packages), with OpenSSL's cryptography inside it. One line gives a program libssh2's whole C API and links the library:

```freebasic
#import "vendor/libssh2"
```

There is nothing to download, no header to translate, no `#foreignlib` and nothing on the command line. The names are the ones [libssh2's documentation](https://libssh2.org/docs.html) uses -- `libssh2_session_handshake`, `libssh2_userauth_publickey_fromfile_ex`, `libssh2_sftp_open_ex`, `libssh2_channel_exec`. More programs are in the toolchain's `examples/libssh2`.

libssh2 is the library for **control**: a session you hold, directories you walk, files you open and seek, commands you run. To fetch or send whole files by URL with less code, [libcurl](FTP-Tutorial) does SFTP and SCP too, with libssh2 inside it.

You need an SSH server, an account on it, and two files:

- **a key**: `ssh-keygen -t ed25519` writes `~/.ssh/id_ed25519` and `id_ed25519.pub`; the server's administrator adds the `.pub` to the account's `~/.ssh/authorized_keys`.
- **the server's host key**, in a `known_hosts` file: `ssh-keyscan -p 22 files.example.com >> known_hosts`, then **check the fingerprint** it prints with the server's administrator. Every program here refuses a server whose key is not in that file.

Every program takes the server, port, user, key file and known_hosts file as arguments:

```
sshfirst files.example.com 22 me /home/me/.ssh/id_ed25519 /home/me/.ssh/known_hosts
```

---

## 1. A first connection

The program connects, checks who the server is, and logs in:

```freebasic
'' SSH from tiko: connect, check the server's host key against
'' known_hosts, then log in with a key.
''     sshfirst host port user keyfile known_hosts
#import "vendor/libssh2"
#import "std/net"

dim as string host = command( 1 ), user = command( 3 )
dim as string keyFile = command( 4 ), known = command( 5 )
dim as integer port = valint( command( 2 ) )

dim as net.TcpStream tcp
if tcp.ConnectHost( host, port, 10000 ).IsOk( ) = false then
    print "cannot connect to "; host : end 1
end if

libssh2_init( 0 )
dim as LIBSSH2_SESSION ptr s = libssh2_session_init( )
if libssh2_session_handshake( s, tcp.hFd ) <> 0 then
    print "no SSH handshake" : end 1
end if
print "key exchange: "; *libssh2_session_methods( s, LIBSSH2_METHOD_KEX )
print "host key:     "; *libssh2_session_methods( s, LIBSSH2_METHOD_HOSTKEY )

'' The host key, checked BEFORE anything secret is sent.
dim as uinteger klen
dim as int32 ktype
dim as const zstring ptr key_ = libssh2_session_hostkey( s, @klen, @ktype )
dim as LIBSSH2_KNOWNHOSTS ptr kh = libssh2_knownhost_init( s )
libssh2_knownhost_readfile( kh, known, LIBSSH2_KNOWNHOST_FILE_OPENSSH )
dim as libssh2_knownhost ptr found
dim as int32 check = libssh2_knownhost_checkp( kh, host, port, key_, klen, _
    LIBSSH2_KNOWNHOST_TYPE_PLAIN or LIBSSH2_KNOWNHOST_KEYENC_RAW, @found )
libssh2_knownhost_free( kh )
if check <> LIBSSH2_KNOWNHOST_CHECK_MATCH then
    print "the server's key is not in "; known; " -- stopping" : end 1
end if
print "known host:   yes"

if libssh2_userauth_publickey_fromfile_ex( s, user, len( user ), _
        keyFile & ".pub", keyFile, nullptr ) <> 0 then
    dim as zstring ptr msg
    libssh2_session_last_error( s, @msg, nullptr, 0 )
    print "login refused: "; *msg : end 1
end if
print "logged in as "; user

libssh2_session_disconnect_ex( s, SSH_DISCONNECT_BY_APPLICATION, "bye", "" )
libssh2_session_free( s )
libssh2_exit( )
```

Run against a test server, it prints:

```text
key exchange: curve25519-sha256
host key:     ecdsa-sha2-nistp256
known host:   yes
logged in as tikoft
```

- **libssh2 talks over a socket the program connects itself.** `std/net`'s `TcpStream` connects -- names, IPv6, a timeout -- and `tcp.hFd` is its socket, which `libssh2_session_handshake` takes.
- **The handshake proves only that the server holds *some* key.** `libssh2_knownhost_checkp` proves it is the key you recorded. `known_hosts` keeps a server on another port as `[host]:port`, and `checkp` matches that form. Anything but `LIBSSH2_KNOWNHOST_CHECK_MATCH` -- not found, or a **different** key -- means stop.
- **Only then does anything secret leave the program.** `libssh2_userauth_publickey_fromfile_ex` takes the user, the public and private key files, and the key's passphrase or `nullptr`. A password login is `libssh2_userauth_password( s, user, password )`.
- An error is a negative return; `libssh2_session_last_error` says what in words.

## 2. Files over SFTP

The same login, then a file up, the home directory listed, the file down again, and removed:

```freebasic
'' Files over SFTP with libssh2: upload, list, download, remove.
''     sftpfiles host port user keyfile known_hosts
#import "vendor/libssh2"
#import "std/net"
#include once "crt/string.bi"

dim as string host = command( 1 ), user = command( 3 )
dim as string keyFile = command( 4 ), known = command( 5 )
dim as integer port = valint( command( 2 ) )

'' Connect, check the host key, log in: sshfirst, in one function.
function Login( byref tcp as net.TcpStream, byref host as string, _
                byval port as integer, byref user as string, _
                byref keyFile as string, byref known as string ) _
                as LIBSSH2_SESSION ptr
    if tcp.ConnectHost( host, port, 10000 ).IsOk( ) = false then return nullptr
    dim as LIBSSH2_SESSION ptr s = libssh2_session_init( )
    if libssh2_session_handshake( s, tcp.hFd ) <> 0 then return nullptr
    dim as uinteger klen
    dim as int32 ktype
    dim as const zstring ptr k = libssh2_session_hostkey( s, @klen, @ktype )
    dim as LIBSSH2_KNOWNHOSTS ptr kh = libssh2_knownhost_init( s )
    libssh2_knownhost_readfile( kh, known, LIBSSH2_KNOWNHOST_FILE_OPENSSH )
    dim as libssh2_knownhost ptr found
    dim as int32 check = libssh2_knownhost_checkp( kh, host, port, k, klen, _
        LIBSSH2_KNOWNHOST_TYPE_PLAIN or LIBSSH2_KNOWNHOST_KEYENC_RAW, @found )
    libssh2_knownhost_free( kh )
    if check <> LIBSSH2_KNOWNHOST_CHECK_MATCH then return nullptr
    if libssh2_userauth_publickey_fromfile_ex( s, user, len( user ), _
        keyFile & ".pub", keyFile, nullptr ) <> 0 then return nullptr
    return s
end function

libssh2_init( 0 )
dim as net.TcpStream tcp
dim as LIBSSH2_SESSION ptr s = Login( tcp, host, port, user, keyFile, known )
if s = nullptr then print "could not log in" : end 1
dim as LIBSSH2_SFTP ptr sf = libssh2_sftp_init( s )

'' Upload: open for writing, write until all of it is sent.
dim as string path = "notes.txt"
dim as string body = "first line" & chr( 10 ) & "second line" & chr( 10 )
dim as LIBSSH2_SFTP_HANDLE ptr h = libssh2_sftp_open_ex( sf, path, _
    len( path ), LIBSSH2_FXF_WRITE or LIBSSH2_FXF_CREAT or _
    LIBSSH2_FXF_TRUNC, &o644, LIBSSH2_SFTP_OPENFILE )
dim as integer sent = 0
while sent < len( body )
    dim as integer n = libssh2_sftp_write( h, strptr( body ) + sent, _
                                           len( body ) - sent )
    if n < 0 then exit while
    sent += n
wend
libssh2_sftp_close_handle( h )
print "uploaded "; path; ", "; str( sent ); " bytes"

'' The home directory, with each entry's size.
dim as string dir_ = "."
dim as LIBSSH2_SFTP_ATTRIBUTES at
dim as zstring * 256 nm
h = libssh2_sftp_open_ex( sf, dir_, len( dir_ ), 0, 0, LIBSSH2_SFTP_OPENDIR )
while libssh2_sftp_readdir( h, @nm, 256, @at ) > 0
    if left( nm, 1 ) <> "." then
        print "  "; left( nm & space( 12 ), 12 ); _
              iif( LIBSSH2_SFTP_S_ISDIR( at.permissions ), "folder", _
                   str( at.filesize ) & " bytes" )
    end if
wend
libssh2_sftp_close_handle( h )

'' Download: read until read returns 0. The bytes are copied.
dim as string back
dim as ubyte buf( 0 to 4095 )
h = libssh2_sftp_open_ex( sf, path, len( path ), LIBSSH2_FXF_READ, 0, _
                          LIBSSH2_SFTP_OPENFILE )
do
    dim as integer n = libssh2_sftp_read( h, _
                           cast( zstring ptr, @buf( 0 ) ), 4096 )
    if n <= 0 then exit do
    dim as integer had = len( back )
    back &= space( n )
    memcpy( strptr( back ) + had, @buf( 0 ), n )
loop
libssh2_sftp_close_handle( h )
print "downloaded "; str( len( back ) ); " bytes: "; _
      iif( back = body, "the same", "DIFFERENT" )

libssh2_sftp_unlink_ex( sf, path, len( path ) )
print "removed "; path
libssh2_sftp_shutdown( sf )
libssh2_session_free( s )
libssh2_exit( )
```

```text
uploaded notes.txt, 23 bytes
  up          folder
  notes.txt   23 bytes
  pub         folder
downloaded 23 bytes: the same
removed notes.txt
```

- **Every path goes with its length** -- `libssh2_sftp_open_ex( sf, path, len( path ), ... )`. Relative paths start in the account's home directory.
- `LIBSSH2_FXF_WRITE or LIBSSH2_FXF_CREAT or LIBSSH2_FXF_TRUNC` with a mode (`&o644`) opens a file to write, creating or emptying it; `LIBSSH2_FXF_READ` to read; `LIBSSH2_SFTP_OPENDIR` opens a directory.
- **`libssh2_sftp_write` may take less than you give it**: write in a loop until all of it is sent. `libssh2_sftp_read` returns the bytes it read, `0` at the end.
- **File contents are bytes**: copy them with `memcpy`; a `zstring` stops at the first zero byte.
- `libssh2_sftp_readdir` fills a `LIBSSH2_SFTP_ATTRIBUTES` per entry: `filesize`, `permissions`, `mtime`. `LIBSSH2_SFTP_S_ISDIR` and its siblings test the permissions -- they give tiko's truth value, `-1`, so test them, do not add them.
- `libssh2_sftp_unlink_ex`, `_rename_ex`, `_mkdir_ex`, `_rmdir_ex` and `_stat_ex` do the rest. What libssh2 opens, libssh2 closes: `libssh2_sftp_close_handle`, `libssh2_sftp_shutdown`.

## 3. Running a command

```freebasic
'' Run a command over SSH: its output and its exit status.
''     sshexec host port user keyfile known_hosts "command"
#import "vendor/libssh2"
#import "std/net"

dim as string host = command( 1 ), user = command( 3 )
dim as string keyFile = command( 4 ), known = command( 5 )
dim as string cmd = command( 6 )
dim as integer port = valint( command( 2 ) )

libssh2_init( 0 )
dim as net.TcpStream tcp
if tcp.ConnectHost( host, port, 10000 ).IsOk( ) = false then end 1
dim as LIBSSH2_SESSION ptr s = libssh2_session_init( )
if libssh2_session_handshake( s, tcp.hFd ) <> 0 then end 1
dim as uinteger klen
dim as int32 ktype
dim as const zstring ptr k = libssh2_session_hostkey( s, @klen, @ktype )
dim as LIBSSH2_KNOWNHOSTS ptr kh = libssh2_knownhost_init( s )
libssh2_knownhost_readfile( kh, known, LIBSSH2_KNOWNHOST_FILE_OPENSSH )
dim as libssh2_knownhost ptr found
if libssh2_knownhost_checkp( kh, host, port, k, klen, _
        LIBSSH2_KNOWNHOST_TYPE_PLAIN or LIBSSH2_KNOWNHOST_KEYENC_RAW, _
        @found ) <> LIBSSH2_KNOWNHOST_CHECK_MATCH then end 1
libssh2_knownhost_free( kh )
if libssh2_userauth_publickey_fromfile_ex( s, user, len( user ), _
    keyFile & ".pub", keyFile, nullptr ) <> 0 then end 1

'' One channel per command.
dim as LIBSSH2_CHANNEL ptr ch = libssh2_channel_open_session( s )
libssh2_channel_exec( ch, cmd )
dim as zstring * 1025 buf
do
    dim as integer n = libssh2_channel_read_ex( ch, 0, @buf, 1024 )
    if n <= 0 then exit do
    buf[n] = 0
    print buf;
loop

'' The exit status is there once the channel has closed.
libssh2_channel_close( ch )
libssh2_channel_wait_closed( ch )
print "exit status "; str( libssh2_channel_get_exit_status( ch ) )
libssh2_channel_free( ch )
libssh2_session_free( s )
libssh2_exit( )
```

Given `echo hello from $(uname -s); exit 3`:

```text
hello from Linux
exit status 3
```

- **One channel per command**: `libssh2_channel_open_session`, then `libssh2_channel_exec`.
- `libssh2_channel_read_ex( ch, 0, ... )` reads standard output; stream `SSH_EXTENDED_DATA_STDERR` reads standard error. Read each until it returns `0`.
- **The exit status comes as the channel closes**: `libssh2_channel_close`, `libssh2_channel_wait_closed`, then `libssh2_channel_get_exit_status`.

## 4. Keys, passphrases and host keys

- **Key files**: OpenSSH's own format (what `ssh-keygen` writes) and PEM, **ed25519**, ECDSA and RSA. A key with a passphrase takes it as the last argument of `libssh2_userauth_publickey_fromfile_ex`.
- The cryptography is OpenSSL's on every system, so a program speaks to today's servers with today's defaults: curve25519 key exchange, ed25519 and ECDSA host keys, ChaCha20-Poly1305.
- **A fingerprint** to show a user, in OpenSSH's form: `libssh2_hostkey_hash( s, LIBSSH2_HOSTKEY_HASH_SHA256 )` is 32 bytes; `SHA256:` and their unpadded base64 (`codec.Base64Encode( raw, codec.B64_STANDARD, false )`) is what `ssh-keygen -lf known_hosts` prints. `examples/libssh2/01-connect` shows it.

## 5. More programs

The toolchain's `examples/libssh2`, each built with `tiko <name>.tiko`, read the server and the credentials from `TIKO_SSH_HOST`, `TIKO_SSH_PORT`, `TIKO_SSH_USER`, `TIKO_SSH_KEY` (or `TIKO_SSH_PASSWORD`) and `TIKO_SSH_KNOWN_HOSTS`:

| Folder | Shows |
| --- | --- |
| `01-connect` | what the handshake negotiated, the host key's fingerprint as OpenSSH prints it, the known_hosts check, the methods the server offers, key or password login |
| `02-sftp` | mkdir, upload, stat, a listing with each entry's attributes, download, rename, unlink, rmdir |
| `03-exec` | a command's standard output and standard error apart, and its exit status |
| `04-scp` | a binary file up with `libssh2_scp_send64` and down with `libssh2_scp_recv2`, its size and mode first |

## 6. In a project

A [`tiko build`](Category-Tiko-Build) project needs nothing in its `tiko.toml` for libssh2: the import says it all. `tiko build`'s `copy_to` copies the shared library along with the program.

## 7. Shipping the program

- **Linked dynamically** (the default): ship the library the build put beside the program -- `libssh2.dll` on Windows, `libssh2_linux_x86_64.so` or `libssh2_linux_arm64.so` on Linux, `libssh2_macos_arm64.dylib` on macOS. It is the only file: OpenSSL's cryptography is inside it. (Measured on Windows: `sshfirst` is 73 KB, `libssh2.dll` 4.5 MB.)
- **Linked statically** (`#import "vendor/libssh2" link static`): the program alone -- `sshfirst` is then 4.4 MB on Windows, most of it OpenSSL.

libssh2 is under the BSD 3-Clause licence and OpenSSL under the Apache License 2.0; both texts are in `pkg/vendor/libssh2/LICENSE` in the toolchain, to go with a program you distribute.

## 8. Troubleshooting

Each of these was produced with the programs above:

| Symptom | Cause and fix |
| --- | --- |
| `the server's key is not in known_hosts` -- `libssh2_knownhost_checkp` returns `LIBSSH2_KNOWNHOST_CHECK_NOTFOUND` (2) | the server's key was never recorded, or `known_hosts` holds it under another name or port (`[host]:port`). Record it with `ssh-keyscan`, and check the fingerprint |
| `checkp` returns `LIBSSH2_KNOWNHOST_CHECK_MISMATCH` (1) | the server has a different key from the one recorded: a reinstalled server -- or someone else answering. Find out which before you go on |
| login refused: `Callback returned error` (-19) | the key file cannot be read, **or** its passphrase is missing or wrong -- libssh2 says the same for both |
| login refused: `Username/PublicKey combination invalid` | the key is good but the account does not accept it: its `.pub` is not in the account's `authorized_keys` |
| login refused: `Unable to open public key file` | no such key file, or no `.pub` beside it |
| login refused: `Authentication failed (username/password)` (-18) | a password login with the wrong password, or an account that does not allow passwords |
| `cannot connect` | nothing listening at that host and port (22 by default), or a firewall |
| the program runs without `libssh2.dll` beside it (Windows) | Windows found another `libssh2.dll` on the `PATH` -- PHP's installer brings one (measured: PHP's, which also says 1.11.1). Ship the program's own copy beside it |
| the program exits at once with `-1073741515` (Windows) | no `libssh2.dll` anywhere Windows looks |

---

**Next:** [FTP, FTPS and SFTP with libcurl](FTP-Tutorial) · [Vendor Packages](Vendor-Packages)

[Home](Home)
