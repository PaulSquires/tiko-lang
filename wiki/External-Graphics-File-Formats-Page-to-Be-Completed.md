[Home](Home) › [Tutorials](Category-Tutorials) › **External Graphics File Formats (page to be completed)**

# External Graphics File Formats (page to be completed)

The **external graphics file formats** supported by rtlib through Bload and Bsave.

 Here is a rough starting point, though many bits still to add in... (from coderJeff)

Files used with BLOAD/BSAVE

First byte of file:

```freebasic
&hFD  QB BSAVED BLOCK
&hFE  FB BSAVED BLOCK
&h42  Windows Bitmap (&h42 = ASC("B"))
```

For the QB/FB saved block, &hFD and &hFE identify the file as a QB/FB format and the next bytes determine the SIZE of the data contained in the file, followed by DATA and optionally PALETTE.

 For the Windows Bitmap, should be binary compatible with standard Windows BMP files. When loading, &h42 only identifies the file as possibly a windows bitmap and other checks on the header may cause it to fail loading.

QB BSAVED Block

```freebasic
OFS  LEN   DESCRIPTION
0    1     QB BSAVED BLOCK Identifier (&hFD)
1    4     Ignored
5    2     unsigned 16 bit SIZE, little endian order
7   ...    DATA (expected to be SIZE bytes long)
?   ...    PALETTE COLORS
```

BSAVE and QB/FB Save Block

`BSave( filename, source [,[ size ][,{ pal | pal, bitsperpixel }]] )`

 BSAVE always writes using the FB format (&hFE)  
 DATA bytes written is the smaller of the SIZE parameter and screen \* pitch  
 PALETTE is written either from pal parameter or from current screen's palette

BLOAD and QB/FB Save Block

`BLoad filename [, dest [, [pal]]]`

 If `dest` is not given, then DATA is loaded directly to screen memory byte for byte. If SIZE exceeds the current screen \* pitch, then DATA is truncated to fit the size of the current graphics mode.

 If `dest` is given, then DATA is loaded directly to the memory location pointed to by 'dest'.

 RLE (Run-Length Encoding) not supported. So only uncompressed formats.

BLOAD/BSAVE and Windows bitmap

BLOAD - if first byte is &H42 then file is attempted to be loaded as a bitmap  
 BSAVE - if filename has '.bmp' extension, then is saved as bitmap

 .....  
 .....

See also

- [`BLoad`](Bload)
- [`BSave`](Bsave)
- .....

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
