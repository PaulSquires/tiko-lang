# libcurl examples

Files over FTP, FTPS, SFTP and SCP from tiko through libcurl, from `vendor/libcurl`, which comes
with the toolchain (libssh2 and OpenSSL inside it; TLS is Schannel on Windows). Each example is
one `.tiko` program, built on its own with `tiko <name>.tiko`.

The FTP examples read `TIKO_FTP_*`, the SFTP one `TIKO_SSH_*` (as vendor/libssh2's examples do).
Each says `skipped` and exits 0 when its host is not set:

```
TIKO_FTP_HOST=files.example.com    TIKO_FTP_USER=me    TIKO_FTP_PASSWORD=...
TIKO_FTP_CA=ca.crt                 the CA a private FTPS server's certificate chains to
TIKO_FTPS_IMPLICIT_PORT=990        02-ftps's implicit port (TIKO_FTP_HOST may carry the explicit one: host:2121)
TIKO_SSH_HOST=files.example.com    TIKO_SSH_PORT=22    TIKO_SSH_USER=me
TIKO_SSH_KEY=/home/me/.ssh/id_ed25519 (its .pub beside it; or TIKO_SSH_PASSWORD)
TIKO_SSH_PASSPHRASE=...            TIKO_SSH_KNOWN_HOSTS=/home/me/.ssh/known_hosts
```

| Folder | Shows |
| --- | --- |
| `01-ftp` | an upload with a read callback, a name listing, a download compared with the upload, a resume from an offset, rename + delete with FTP commands, a refused login and its message |
| `02-ftps` | explicit TLS (`ftp://` + `CURLUSESSL_ALL`) and implicit (`ftps://`), the certificate checked against a CA, a check that fails |
| `03-sftp` | SFTP upload, listing, download; the same file over SCP; rename + remove with SFTP commands; the host key checked against `known_hosts`, and an unknown server refused |
| `04-progress` | 32 MiB up and down with a progress callback, curl's measured totals (`CURLINFO_*_T`), a transfer the callback stops |

## Things to know

- **Set options with the typed setters**, `curl_setopt_long`, `_off`, `_str`, `_ptr`, `_fn`,
  and read with `curl_getinfo_long`, `_off`, `_str`, `_float64`. `curl_easy_setopt` is
  variadic: curl reads the value as the type the option names, and C's `long` is 32 bits on
  Windows. A `curl_off_t` option (`CURLOPT_RESUME_FROM_LARGE`, `CURLOPT_INFILESIZE_LARGE`) given
  a 32-bit value through it is read wrong.
- **Never turn certificate or host-key checks off.** FTPS checks the certificate by default:
  give a private CA with `CURLOPT_CAINFO`. SFTP checks nothing unless
  `CURLOPT_SSH_KNOWNHOSTS` names the file.
- **Windows and a private CA:** Schannel also asks whether the certificate was revoked, and a
  private CA publishes no list, so the check fails ("revocation status is unknown", 60) unless
  `CURLOPT_SSL_OPTIONS` has `CURLSSLOPT_REVOKE_BEST_EFFORT`.
- **Plain FTP is unencrypted**, password included. `CURLUSESSL_ALL` makes TLS required;
  `CURLUSESSL_TRY` quietly falls back to the clear.
- **Callbacks** are `cdecl` procs with curl's C signature. The write callback must return the
  byte count it was given, or curl stops. Copy the bytes with `memcpy` (`crt/string.bi`): a
  `zstring` read stops at a zero byte.
- **Lists** (`curl_slist`, for `CURLOPT_QUOTE` / `POSTQUOTE`) must live until the transfer ends;
  `curl_slist_free_all` after it. Strings given to `curl_setopt_str` are copied by curl.
- **One handle, one transfer at a time**; `curl_global_init` once at the start,
  `curl_global_cleanup` once at the end.
- **Build a doubled string as `s = s & s`, not `s &= s`**: today's tiko corrupts a string
  appended to itself (fbc does not).
