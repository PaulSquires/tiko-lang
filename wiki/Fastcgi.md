[Home](Home) › [Tutorials](Category-Tutorials) › **FastCGI**

# FastCGI

Open extension to CGI that provides high performance without the limitations of server specific APIs.

 Website: https://web.archive.org/web/20080213023105/http://www.fastcgi.com:80/ http://www.fastcgi.com (archived copy from 2006)  
 Github: https://github.com/FastCGI-Archives  
 See also Forum: https://freebasic.net/forum/viewtopic.php?f=14&t=28126  
 Platforms supported: Win32, Linux  
 Headers to include: fastcgi/fastcgi.bi, fastcgi/fcgiapp.bi, fastcgi/fcgi_stdio.bi  
 Header version: 2.4.1-SNAP-0311112127

Example

```freebasic
#include "fastcgi/fcgi_stdio.bi"

Dim As Integer count = 0

While (FCGI_Accept() >= 0)

    count += 1

    Print !"Content-type: text/html\r\n"

    Print !"\r\n"

    Print "<title>FastCGI Hello!</title>"

    Print "<h1>FastCGI Hello!</h1>"

    Print Using "Request number ### running on host <i>&</i>"; count; *getenv("SERVER_NAME");

Wend
```

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
