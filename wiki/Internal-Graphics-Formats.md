[Home](Home) › [Tutorials](Category-Tutorials) › **Internal graphics formats**

# Internal graphics formats

Information on the internal formats used by FreeBASIC to represent graphics.

 **Pixel formats**

When a graphics mode is set via the [`Screen (Graphics)`](Screen-Graphics) or [`ScreenRes`](Screenres) functions, GfxLib creates also a framebuffer in standard system memory and sets an appropriate internal pixel format for the mode. There are basically three internal pixel formats, selected depending on the screen depth, as described in the following table:

| Screen depth | Internal bytes per pixel | Range bitmask | Pixel format |
| --- | --- | --- | --- |
| 1bpp | 1 | &h1 | palette color index |
| 2bpp | 1 | &h3 | palette color index |
| 4bpp | 1 | &hF | palette color index |
| 8bpp | 1 | &hFF | palette color index |
| 15/16bpp | 2 | &hFFFF | RRRRRGGGGGGBBBBB |
| 24/32bpp | 4 | &hFFFFFFFF | AAAAAAAARRRRRRRRGGGGGGGGBBBBBBBB |

 All drawing operations work on this RAM framebuffer; when the actual display needs to be updated, GfxLib copies the contents of the framebuffer to the real display memory, automatically converting in the process from the current internal pixel format to whatever pixel format the real display uses. By limiting the internal pixel formats to 3, the library prevents you having to deal with the plethora of real display formats.

**Color values**

When calling a graphics primitive that accepts a color, this can be specified in two ways. In 8bpp or less modes, the color value must be a direct 8 bits color index in the current palette, and this matches the internal pixel format for those modes. In higher color depths, the color value should always have the form `&hAARRGGBB`. This is what the [`RGB`](Rgb) and [`RGBA`](Rgba) macros return, and is equivalent to the 24/32bpp internal pixel format representation. If the current color depth is 24 or 32bpp, this means the color value passes in unaltered. If a 15/16bpp mode is in use, internally each primitive automatically converts the color from the `&hAARRGGBB` form into the `RRRRRGGGGGGBBBBB` internal pixel format (note that in this process the alpha channel is lost, as 15/16bpp modes do not support it). Once the color value is in one of the three pixel formats, the primitive limits its range to the range supported by the current color depth, by using a bitwise [`And`](Operator-and-Conjunction) operation with a range bitmask. So if in 8bpp, the color value passed is [`And`](Operator-and-Conjunction)ed by `&hFF` for example.

**Notes on transparency**

For 8bpp or less modes, color index 0 is always treated as the transparent color for the [`Put`](Put-Graphics) modes that support transparency. For higher depths, `RGB(255, 0, 255)` always represents the transparent color. In 15/16bpp modes, this translates to the internal value `&hF81F`, whereas in 24/32bpp modes it becomes `&hFFFF00FF`. Note that in 24/32bpp modes, [`Put`](Put-Graphics) identifies the transparent color by looking just at the red, green and blue components of the color value, while the alpha value can assume any value. This means that in 24/32bpp modes, `&h00FF00FF`, `&h10FF00FF`, `&hABFF00FF` and `&hFFFF00FF` for example all represent the transparent color, since the lower 24 bits are always `&hFF00FF`.

**Buffer formats**

In FreeBASIC, images can be used as arrays (as in QB) or as pointers. Either way, the image data is contained in one continuous chunk. The chunk consists of an header followed by the image data. The header can be of two types (old-style and new-style) and determines the format of the following image data.

**Old-style** chunk header consists of 4 bytes (32 bits, or 4 bytes). The first 3 bits contain the image color depth in bytes per pixel (8-bit color depth -> 1; 16-bit color depth -> 2; 32-bit color depth -> 4). The next 13 bits contain the image width. The last 16 bits contain the image's height. Please note the intrinsic nature of the header allows only for sizes up to `8191 * 65535` pixels:

```freebasic
' inside FB namespace (extracted from fbgfx.bi)

Type _OLD_HEADER Field = 1

    bpp : 3 As UShort

    Width : 13 As UShort

    height As UShort

End Type
```

The actual pixel data follows the header, and is compacted one row of pixels after another; no data alignment is assumed.  
 The final size of the chunk can then be computed using the formula:

`size = 4 + ( width * height * bytes_per_pixel )`

**New-style** chunk header consists of 32 bytes. The first dword (32 bits) must be equal to the value 7, allowing GfxLib to identify the new type of chunk. The second dword contains the image color depth in bytes per pixel. The third and fourth dwords contain the image width and height respectively, effectively removing the image size limit enforced by the old-style image chunks. The fifth dword contains the pixel row pitch in bytes; this tells how many bytes a row of pixels in the image takes up. The pitch in new-style chunks is always padded to a multiple of 16, to allow pixels' row data to be aligned on the paragraph boundary. The remaining 3 dwords (total 12 bytes) of the header are currently unused and reserved for future use:

```freebasic
' inside FB namespace (extracted from fbgfx.bi)

Type IMAGE Field = 1  '' in FB namespace

    Union

        old As _OLD_HEADER

        Type As ULong

    End Union

    bpp As Long

    Width As ULong

    height As ULong

    pitch As ULong

    _reserved(1 To 12) As UByte

End Type
```

The final size of the image is:

`size = 32 + ( ( ( ( width * bytes_per_pixel ) + &hF ) and not &hF ) * height )`

The format of images created by [`ImageCreate`](Imagecreate) and [`Get`](Get-Graphics) depend on the dialect used. In the *[-lang fb](Compiler-Option-Lang)* dialect, images will be created with the new-style header. In the *[-lang fblite](Compiler-Option-Lang)* and *[-lang qb](Compiler-Option-Lang)* dialects, the old-style image header is created.

 All graphics primitives can work with both old-style and new-style image chunks. For easy access to image information, [`ImageInfo`](Imageinfo) can be used to obtain useful properties of an image buffer - such as its dimensions, color depth, pitch, and a pointer to the pixel data - whichever format is used.  
 It is also possible to access the image header directly to access this information. For more information on acessing the header structure, please refer to [this example](Get-Put-Image-Header-Example).

See also

- [`Screen (Graphics)`](Screen-Graphics)
- [`ScreenRes`](Screenres)
- [`Get (Graphics)`](Get-Graphics)
- [`Put (Graphics)`](Put-Graphics)
- [`ImageCreate`](Imagecreate)
- [`ImageInfo`](Imageinfo)
- [`Trans`](Trans)
- [`Alpha`](Alpha)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
