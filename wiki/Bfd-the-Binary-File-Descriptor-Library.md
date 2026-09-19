[Home](Home) › [Tutorials](Category-Tutorials) › **BFD, the Binary File Descriptor Library**

# BFD, the Binary File Descriptor Library

Provides an API to read and write object files in many different object file formats. libbfd is the core of the GNU binutils.

 Website: http://sourceware.org/binutils/  
 Platforms supported: Win32, Linux, DOS  
 Headers to include: bfd.bi  
 Header version: binutils versions from 2.16 to 2.25

 Define `__BFD_VER__` to 216, 217, 218, ..., 225 to include the bfd header for the corresponding binutils version.

Example

```freebasic
#define __BFD_VER__ 217

#include "bfd.bi"
```

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
