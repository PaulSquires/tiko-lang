[Home](Home) › [Tutorials](Category-Tutorials) › **DevIL**

# DevIL

A full featured cross-platform image library.

 Website: http://openil.sourceforge.net/  
 Platforms supported: Win32, Linux  
 Headers to include: IL/il.bi, IL/ilu.bi, IL/ilut.bi  
 Header version: 1.7.8  
 Examples: in examples/files/DevIL/

Example

```freebasic
'' DevIL example

#include Once "IL/il.bi"

'' Version check

If (ilGetInteger(IL_VERSION_NUM) < IL_VERSION) Then

    Print "DevIL version is different"

    End 1

End If

'' Good practice to explicitely initialize it

ilInit()

'' Load a bitmap

Dim As ILuint fblogo

ilGenImages(1, @fblogo)

ilBindImage(fblogo)

Print "Loading fblogo.bmp..."

ilLoadImage("fblogo.bmp")

'' Save a copy

Print "Saving a copy, fblogo-copy.bmp..."

ilEnable(IL_FILE_OVERWRITE)

ilSaveImage("fblogo-copy.bmp")

'' Clean up

ilDeleteImages(1, @fblogo)
```

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
