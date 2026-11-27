# libssh2 examples

SSH from tiko through libssh2, from `vendor/libssh2`, which comes with the toolchain (OpenSSL's
libcrypto inside it). Each example is one `.tiko` program, built on its own with
`tiko <name>.tiko`.

Every example reads the server and the credentials from the environment, and says `skipped`
and exits 0 when `TIKO_SSH_HOST` is not set:

```
TIKO_SSH_HOST=files.example.com        the server
TIKO_SSH_PORT=22                       its port (22 when unset)
TIKO_SSH_USER=me                       the account
TIKO_SSH_KEY=/home/me/.ssh/id_ed25519  a private key, its .pub beside it (or TIKO_SSH_PASSWORD)
TIKO_SSH_PASSPHRASE=...                the key's passphrase, if it has one
TIKO_SSH_KNOWN_HOSTS=/home/me/.ssh/known_hosts
```

| Folder | Shows |
| --- | --- |
| `01-connect` | TCP with `std/net`, the handshake and what it negotiated, the host key's fingerprint and its check against `known_hosts` (stopping when it does not match), the methods the server offers, key or password authentication |
| `02-sftp` | `mkdir`, an upload, `stat`, a directory listing with each entry's attributes, a download compared with the upload, `rename`, `unlink`, `rmdir` |
| `03-exec` | a remote command's standard output and standard error apart, and its exit status |
| `04-scp` | a 300 000-byte binary file up with `libssh2_scp_send64` and down with `libssh2_scp_recv2` (its size, mode and time first) |

## Things to know

- **Check the host key before authenticating.** The handshake proves only that the server
  holds *some* key; `libssh2_knownhost_checkp` against `known_hosts` proves it is *the* key.
  A key not found is not one to trust: stop, check the fingerprint some other way, then add it
  (`ssh-keyscan -p <port> <host> >> known_hosts`). 01-connect prints it as OpenSSH does.
- **libssh2 needs a connected socket.** The examples connect with `std/net`'s `TcpStream` and
  hand libssh2 its `hFd` -- the SOCKET on Windows, the descriptor elsewhere.
- **Keys:** OpenSSH-format and PEM private keys, ed25519, ECDSA and RSA, with or without a
  passphrase. Error -19 (`LIBSSH2_ERROR_PUBLICKEY_UNVERIFIED`) is what a key file libssh2 cannot
  read and a wrong passphrase both give.
- **Every path and name goes with its length** (`libssh2_sftp_open_ex( sf, path, len( path ), ... )`);
  the convenience macros in the residue (`libssh2_userauth_password`, `libssh2_channel_exec`,
  `libssh2_sftp_readdir`) count it for you.
- **File contents are bytes**: copy them (`memcpy`), do not read them through a `zstring`,
  which stops at the first zero byte.
- **`LIBSSH2_SFTP_S_ISDIR` and its siblings give tiko's truth value**, -1, where C's is 1: test
  them, do not add them.
- **What libssh2 allocates, libssh2 frees**: `libssh2_sftp_close_handle`, `libssh2_sftp_shutdown`,
  `libssh2_channel_free`, `libssh2_knownhost_free`, `libssh2_session_free`.
- **A command's exit status** is there once its channel has closed:
  `libssh2_channel_close`, `libssh2_channel_wait_closed`, then `libssh2_channel_get_exit_status`.
