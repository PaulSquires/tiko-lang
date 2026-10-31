[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › **Internet**

# Internet

Reads the connection state, combines and cleans URLs, and finds browsers and mail.

The connection and URL functions are thin covers over WinINet, the Internet layer of Windows,
returning a `ustring` or a plain answer instead of filling buffers. The URL functions work on
text alone and never go on the network. The browser and mail functions read what is registered
on this machine; none of them starts a program.

## Importing

```freebasic
#import "sys/win"
using win
```

## Example

A console program that reports the connection, the default browser and a URL built from a
base and a relative link:

```freebasic
#import "sys/win"
using win

if InternetGetConnectedState() then
    print "online through "; InternetGetConnectionName()
else
    print "offline"
end if

dim browser as ustring = GetDefaultBrowserName()
if len( browser ) then print "default browser: "; browser else print "no default browser"
print "Edge version: "; GetEdgeVersion()

print InternetCombineUrl( "https://example.com/docs/page.html", "../img/logo.png" )
' https://example.com/img/logo.png
```

## Functions

| Function | Does |
| --- | --- |
| [InternetAttemptConnect](#internetattemptconnect) | Asks Windows to make a connection to the Internet. |
| [InternetCheckConnection](#internetcheckconnection) | Tells whether a server can be reached. |
| [InternetCanonicalizeUrl](#internetcanonicalizeurl) | Escapes unsafe characters in a URL and resolves `..` and `.`. |
| [InternetCombineUrl](#internetcombineurl) | Combines a base URL and a relative URL. |
| [InternetGetConnectedState](#internetgetconnectedstate) | Tells whether the machine has an Internet connection. |
| [InternetGetConnectionDescription](#internetgetconnectiondescription) | Returns flags describing the connection. |
| [InternetGetConnectionName](#internetgetconnectionname) | Returns the name of the connection. |
| [GetEdgeVersion](#getedgeversion) | Returns the version of Microsoft Edge. |
| [GetFirefoxVersion](#getfirefoxversion) | Returns the version of Firefox. |
| [GetChromeVersion](#getchromeversion) | Returns the version of Google Chrome. |
| [GetDefaultBrowserName](#getdefaultbrowsername) | Returns the program name of the default browser. |
| [GetDefaultBrowserPath](#getdefaultbrowserpath) | Returns the full path of the default browser. |
| [GetDefaultMailClientPath](#getdefaultmailclientpath) | Returns the full path of the default mail program. |
| [GetDefaultMailClientName](#getdefaultmailclientname) | Returns the program name of the default mail program. |

## Reference

### InternetAttemptConnect

```freebasic
function InternetAttemptConnect overload() as DWORD
```

Asks Windows to connect to the Internet, dialling a modem connection if that is how the machine
connects; a machine that is already online answers at once. The Windows function, which takes a
reserved argument, is still there with one argument.

**Returns** `ERROR_SUCCESS` (0) when a connection is there or was made, otherwise a Windows error
code.

**Example**

```freebasic
if InternetAttemptConnect() = ERROR_SUCCESS then print "you can connect to the Internet"
```

Microsoft Learn: [InternetAttemptConnect](https://learn.microsoft.com/en-us/windows/win32/api/wininet/nf-wininet-internetattemptconnect)

### InternetCheckConnection

```freebasic
function InternetCheckConnection overload( byval pwszUrl as wstring ptr ) as boolean
```

Tries to reach the server of a URL (`FLAG_ICC_FORCE_CONNECTION`): only the host is used, not the
page. The call waits for the answer, which can take several seconds when the server does not
respond. The Windows function, with a flags argument and a reserved one, is still there.

| Parameter | Meaning |
| --- | --- |
| `pwszUrl` | A URL such as `"https://example.com/"`. |

**Returns** `true` when the server could be reached; on failure `false`, and `GetLastError()`
says why.

**Example**

```freebasic
if InternetCheckConnection( "https://example.com/" ) then print "the server answers"
```

Microsoft Learn: [InternetCheckConnectionW](https://learn.microsoft.com/en-us/windows/win32/api/wininet/nf-wininet-internetcheckconnectionw)

### InternetCanonicalizeUrl

```freebasic
function InternetCanonicalizeUrl overload( byval pwszUrl as wstring ptr, byval dwFlags as DWORD = 0 ) as ustring
```

Puts a URL into its standard form: unsafe characters and spaces become `%` escape sequences, and
`..` and `.` segments are resolved. `"http://example.com/a b/../c.html"` gives
`http://example.com/c.html`; `"http://example.com/my file.html"` gives
`http://example.com/my%20file.html`.

The text does not have to be a URL: `"not a url"` comes back as `not%20a%20url`.

| Parameter | Meaning |
| --- | --- |
| `pwszUrl` | The URL. |
| `dwFlags` | `ICU_*` flags. 0 escapes and resolves. `ICU_DECODE or ICU_NO_ENCODE` turns `%20` back into a space; `ICU_DECODE` alone decodes and then escapes again. `ICU_NO_META` leaves `..` and `.` alone. |

**Returns** the URL, or `""` when it cannot be processed.

**Example**

```freebasic
print InternetCanonicalizeUrl( "http://example.com/a%20b", ICU_DECODE or ICU_NO_ENCODE )   ' http://example.com/a b
```

Microsoft Learn: [InternetCanonicalizeUrlW](https://learn.microsoft.com/en-us/windows/win32/api/wininet/nf-wininet-internetcanonicalizeurlw)

### InternetCombineUrl

```freebasic
function InternetCombineUrl overload( byval pwszBaseUrl as wstring ptr, byval pwszRelativeUrl as wstring ptr, byval dwFlags as DWORD = 0 ) as ustring
```

Resolves a relative URL, such as a link found in a page, against the URL of the page, the way a
browser does, and returns the result in standard form.

| `pwszBaseUrl` | `pwszRelativeUrl` | Result |
| --- | --- | --- |
| `https://example.com/docs/page.html` | `../img/logo.png` | `https://example.com/img/logo.png` |
| `https://example.com/docs/` | `/forum/index.php?board=1.0` | `https://example.com/forum/index.php?board=1.0` |
| `https://example.com/docs/` | `intro page.html` | `https://example.com/docs/intro%20page.html` |

| Parameter | Meaning |
| --- | --- |
| `pwszBaseUrl` | The URL the link is relative to. |
| `pwszRelativeUrl` | The link. A complete URL is returned as it is. |
| `dwFlags` | `ICU_*` flags, as for [InternetCanonicalizeUrl](#internetcanonicalizeurl). |

**Returns** the combined URL, or `""` on failure.

**Example**

```freebasic
print InternetCombineUrl( "https://example.com/docs/", "intro page.html" )
```

Microsoft Learn: [InternetCombineUrlW](https://learn.microsoft.com/en-us/windows/win32/api/wininet/nf-wininet-internetcombineurlw)

### InternetGetConnectedState

```freebasic
function InternetGetConnectedState overload() as boolean
```

Tells whether the machine has a connection Windows can use to reach the Internet. This is what
the network settings say, not a test that a server answers; use
[InternetCheckConnection](#internetcheckconnection) for that. The Windows function, which also
returns flags, is still there with two arguments.

**Returns** `true` when there is a connection.

**Example**

```freebasic
if InternetGetConnectedState() = false then print "working offline"
```

Microsoft Learn: [InternetGetConnectedState](https://learn.microsoft.com/en-us/windows/win32/api/wininet/nf-wininet-internetgetconnectedstate)

### InternetGetConnectionDescription

```freebasic
function InternetGetConnectionDescription() as DWORD
```

Returns flags that describe how the machine connects:

| Flag | Value | Means |
| --- | --- | --- |
| `INTERNET_CONNECTION_MODEM` | `&h01` | through a modem |
| `INTERNET_CONNECTION_LAN` | `&h02` | through a local network |
| `INTERNET_CONNECTION_PROXY` | `&h04` | through a proxy server |
| `INTERNET_RAS_INSTALLED` | `&h10` | remote access (dial-up) is installed |
| `INTERNET_CONNECTION_OFFLINE` | `&h20` | the system is in offline mode |
| `INTERNET_CONNECTION_CONFIGURED` | `&h40` | a connection is configured but may not be up |

A machine on a local network answered `&h12`, LAN and remote access installed, when measured.

**Returns** the flags; 0 when there is no connection.

**Example**

```freebasic
if InternetGetConnectionDescription() and INTERNET_CONNECTION_PROXY then print "through a proxy"
```

Microsoft Learn: [InternetGetConnectedStateExW](https://learn.microsoft.com/en-us/windows/win32/api/wininet/nf-wininet-internetgetconnectedstateexw)

### InternetGetConnectionName

```freebasic
function InternetGetConnectionName() as ustring
```

Returns the name Windows gives the connection: `LAN Connection` for a local network, or the
name of a dial-up entry.

**Returns** the name, or `""` when there is no connection.

**Example**

```freebasic
print "connected through "; InternetGetConnectionName()
```

### GetEdgeVersion

```freebasic
function GetEdgeVersion() as ustring
```

Returns the version of Microsoft Edge that the current user runs, as Edge records it in the
user's part of the registry: a dotted number such as `154.0.4258.37`.

**Returns** the version, or `""` when Edge has not recorded one for this user.

**Example**

```freebasic
dim edge as ustring = GetEdgeVersion()
if len( edge ) then print "Edge"; val( edge ) ' the major version
```

Microsoft Learn: [RegQueryValueExW](https://learn.microsoft.com/en-us/windows/win32/api/winreg/nf-winreg-regqueryvalueexw)

### GetFirefoxVersion

```freebasic
function GetFirefoxVersion() as ustring
```

Returns the version string a machine-wide Firefox installation records in the registry.

**Returns** the version, or `""` when Firefox is not installed for all users.

**Example**

```freebasic
if len( GetFirefoxVersion() ) = 0 then print "Firefox is not installed"
```

### GetChromeVersion

```freebasic
function GetChromeVersion() as ustring
```

Returns the version of Google Chrome as Google's updater records it for a machine-wide
installation. A copy of Chrome installed for the current user only is not seen.

**Returns** the version, or `""` when no machine-wide Chrome is recorded.

**Example**

```freebasic
dim chrome as ustring = GetChromeVersion()
if len( chrome ) then print "Chrome "; chrome else print "no machine-wide Chrome"
```

### GetDefaultBrowserName

```freebasic
function GetDefaultBrowserName() as ustring
```

Returns the program name of the browser that opens `http` links, without folder or extension:
`msedge`, `firefox`, `chrome`.

**Returns** the name, or `""` when no browser is registered.

**Example**

```freebasic
print "links open in "; GetDefaultBrowserName()
```

Microsoft Learn: [AssocQueryStringW](https://learn.microsoft.com/en-us/windows/win32/api/shlwapi/nf-shlwapi-assocquerystringw)

### GetDefaultBrowserPath

```freebasic
function GetDefaultBrowserPath() as ustring
```

Returns the full path of the program that opens `http` links, such as
`C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe`.

**Returns** the path, or `""` when no browser is registered.

**Example**

```freebasic
dim browser as ustring = GetDefaultBrowserPath()
if len( browser ) then ShellExecuteW( NULL, "open", browser, "https://example.com/", NULL, SW_SHOWNORMAL )
```

### GetDefaultMailClientPath

```freebasic
function GetDefaultMailClientPath() as ustring
```

Returns the full path of the program that opens `mailto:` links.

**Returns** the path, or `""` when no mail program is registered.

**Example**

```freebasic
if len( GetDefaultMailClientPath() ) = 0 then print "no mail program is set up"
```

### GetDefaultMailClientName

```freebasic
function GetDefaultMailClientName() as ustring
```

Returns the program name of the program that opens `mailto:` links, without folder or extension,
such as `OUTLOOK` or `thunderbird`, as the file is named on disk.

**Returns** the name, or `""` when no mail program is registered.

**Example**

```freebasic
print "mail goes through "; GetDefaultMailClientName()
```

## See also

- [Category: sys/win](Category-Sys-Win)
- [Common dialogs](SysWin-Common-Dialogs) for the Internet Properties dialog tabs
- [CWebView2](CWebView2), the Edge browser control
