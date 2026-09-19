[Home](Home) › [Tutorials](Category-Tutorials) › **LZO**

# LZO

LZO is a compression library offering fast compression and very fast decompression.

 Website: https://www.oberhumer.com/opensource/lzo/  
 Platforms supported: Win32, Linux, DOS  
 Headers to include: lzo/lzo.bi  
 Header version: 2.02

Example

```freebasic
#include "lzo/lzo1x.bi"

Dim inbuf As ZString Ptr = @"string to compress (or not, since it's so short)"

Dim inlen As Integer = Len(*inbuf) + 1

Dim complen As lzo_uint = 100

Dim compbuf As ZString Ptr = Allocate(complen)

Dim decomplen As lzo_uint = 100

Dim decompbuf As ZString Ptr = Allocate(decomplen)

Dim workmem As Any Ptr

Print "initializing LZO: ";

If lzo_init() = 0 Then

    Print "ok"

Else

    Print "failed!"

    End 1

End If

Print "compressing '" & *inbuf & "': ";

workmem = Allocate(LZO1X_1_15_MEM_COMPRESS)

If lzo1x_1_15_compress(inbuf, inlen, compbuf, @complen, workmem) = 0 Then

    Print "ok (" & inlen & " bytes in, " & complen & " bytes compressed)"

Else

    Print "failed!"

    End 1

End If

Deallocate(workmem)

Print "decompressing: ";

workmem = Allocate(LZO1X_MEM_DECOMPRESS)

If lzo1x_decompress(compbuf, complen, decompbuf, @decomplen, NULL) = 0 Then

    Print "ok: '" & *decompbuf & "' (" & complen & " bytes compressed, " & decomplen & " bytes decompressed)"

Else

    Print "failed!"

    End 1

End If

Deallocate(workmem)
```

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
