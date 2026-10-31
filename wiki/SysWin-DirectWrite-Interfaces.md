[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/direct2d](SysWin-Direct2D) › **DirectWrite interfaces and types**

# DirectWrite interfaces and types

Lists the DirectWrite interfaces, enumerations and structures of sys/win/direct2d.

**DirectWrite** is the Windows text engine: it finds fonts, lays text out in lines, measures it
and shapes it into glyphs. Direct2D draws what it lays out. `sys/win/direct2d` declares the
whole DirectWrite API, from the first version to the eighth factory, and no class wraps it: a
program works with the interfaces themselves.

**Where the objects come from.** Everything starts from a factory, made with
`DWriteCreateFactory`, which `sys/win/direct2d` declares as

```freebasic
declare function DWriteCreateFactory lib "dwrite" alias "DWriteCreateFactory" ( byval factoryType as DWRITE_FACTORY_TYPE, byref riid as IID, byref factory as any ptr ) as HRESULT
```

Pass `IID_IDWriteFactory` and an `IDWriteFactory ptr`, or the identifier of a later version
(`IID_IDWriteFactory1` … `IID_IDWriteFactory8`) and a pointer of that type. The factory gives
the installed fonts (`GetSystemFontCollection`), text formats (`CreateTextFormat`), text
layouts (`CreateTextLayout`), rendering parameters and the GDI bridge (`GetGdiInterop`); those
objects give the rest. A [CID2D1RenderTarget](CID2D1RenderTarget) draws them: `DrawText`
takes an `IDWriteTextFormat ptr`, `DrawTextLayout` an `IDWriteTextLayout ptr`, and
`SetTextRenderingParams` an `IDWriteRenderingParams ptr`.

**Calling a method.** Each interface `IDWriteX` is a name for the type `IDWriteX_`, which
declares the methods and extends its parent, so `p->Method( ... )` calls one and a pointer to a
later version reaches every method of the earlier ones. A parameter that receives an object is
`byref ... ptr`: pass the pointer variable itself. Where Windows gives a later interface a
second method of an existing name, the declaration here adds a suffix: `IDWriteFontFace1` has
`GetMetrics1`, `IDWriteFont3` has `CreateFontFace3`, `IDWriteFontSet` has `GetPropertyValues_2`
and `GetPropertyValues_3`.

**Releasing.** Every pointer a factory or a method hands out holds one reference, which is
yours: call `Release` on it when done, or `D2D1_SafeRelease`, which also sets the variable to
`NULL`.

**Identifiers.** `IID_IDWriteAsyncResult` … `IID_IDWriteTypography` are `GUID` variables, one
per interface, passed straight to `DWriteCreateFactory` or `QueryInterface`.

**Getters that return a value.** Many DirectWrite methods give their answer as the function's
result rather than through a parameter: counts, weights, styles, lengths. They are declared
here with a `byref` parameter and an `HRESULT` result, and the value arrives in the **result**;
the parameter is left as it was. `IDWriteFontCollection.GetFontFamilyCount`,
`IDWriteFontList.GetFontCount`, `IDWriteLocalizedStrings.GetCount`, `IDWriteFont.GetWeight`,
`IDWriteTextFormat.GetFontWeight` and `GetFontFamilyNameLength` all behave so. A getter whose
value is a `single`, such as `IDWriteTextFormat.GetFontSize` or
`IDWriteRenderingParams.GetGamma`, gives neither: its result is an unrelated number and the
parameter is not written. Keep the size you passed to `CreateTextFormat` instead.

**True or false answers.** A parameter in which Windows writes a `BOOL` (four bytes) is
declared in several methods as `byref ... as boolean` (one byte): `FindFamilyName`,
`IDWriteFont.HasCharacter`, `IDWriteTextLayout.HitTestPoint` and others. Windows still writes
four bytes, over whatever follows the variable. Dim a `BOOL` and pass
`*cast( boolean ptr, @b )`, as the example does.

**Text.** Methods that return a string fill a `wstring` buffer you supply with its size;
assign the buffer to a `ustring` to print it or keep it.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/direct2d"
using win, direct2d
```

## Example

A console program that opens the installed fonts, counts the families, finds one and reads its
name, then lays out a line of text and measures it:

```freebasic
#import "sys/win"
#import "sys/win/direct2d"
using win, direct2d

function main() as long
    ' The root object: a shared DirectWrite factory.
    dim pFactory as IDWriteFactory ptr
    dim hr as HRESULT = DWriteCreateFactory( DWRITE_FACTORY_TYPE_SHARED, IID_IDWriteFactory, pFactory )
    if hr <> S_OK then print "DWriteCreateFactory failed: &h"; hex( hr ) : return 1

    ' The fonts installed on this computer. The count is the method's result.
    dim pFonts as IDWriteFontCollection ptr
    pFactory->GetSystemFontCollection( pFonts )
    dim unused as UINT32
    print "font families:"; pFonts->GetFontFamilyCount( unused )

    ' Find one family and read its first name. "found" is a BOOL: Windows writes four bytes.
    dim idx as UINT32, found as BOOL
    pFonts->FindFamilyName( "Segoe UI", @idx, *cast( boolean ptr, @found ) )
    if found then
        dim pFamily as IDWriteFontFamily ptr
        pFonts->GetFontFamily( idx, pFamily )
        dim pNames as IDWriteLocalizedStrings ptr
        pFamily->GetFamilyNames( pNames )
        dim wszName as wstring * 100
        pNames->GetString( 0, wszName, 100 )
        dim sName as ustring = wszName
        print "found "; sName; " at index "; idx; ", fonts in it:"; pFamily->GetFontCount( unused )
        pNames->Release()
        pFamily->Release()
    end if

    ' Format a line of text, lay it out and measure it.
    dim pFormat as IDWriteTextFormat ptr
    pFactory->CreateTextFormat( "Segoe UI", NULL, DWRITE_FONT_WEIGHT_NORMAL, DWRITE_FONT_STYLE_NORMAL, _
                                DWRITE_FONT_STRETCH_NORMAL, 24, "en-us", pFormat )
    dim wszText as wstring * 64 = "Hello, DirectWrite"
    dim pLayout as IDWriteTextLayout ptr
    pFactory->CreateTextLayout( wszText, len( wszText ), pFormat, 1000, 100, pLayout )
    dim tm as DWRITE_TEXT_METRICS
    pLayout->GetMetrics( tm )
    print "laid out in "; tm.lineCount; " line,"; cint( tm.width ); " x"; cint( tm.height ); " DIPs"

    pLayout->Release()
    pFormat->Release()
    pFonts->Release()
    pFactory->Release()
    return 0
end function

end main()
```

On a Windows 11 computer it printed:

```text
font families: 273
found Segoe UI at index 51, fonts in it: 18
laid out in 1 line, 187 x 32 DIPs
```

The numbers depend on the fonts installed.

## Types

The tables list every type the DirectWrite part of `sys/win/direct2d` declares. The enumeration
types are `long`s; their values are separate constants, written bare after `using direct2d`
(`DWRITE_FONT_WEIGHT_BOLD`). `DWRITE_MEASURING_MODE`, `DWRITE_GLYPH_IMAGE_FORMATS` and the
`D2D1_*` types are declared with Direct2D: see [Direct2D interfaces](SysWin-Direct2D-Interfaces).

### Interfaces

| Interface | Methods declared in | Extends | Is | Microsoft Learn |
| --- | --- | --- | --- | --- |
| `IDWriteFontFileLoader` | `IDWriteFontFileLoader_` | `ComUnknown` | Implemented by a program to open font file streams from a key. | [IDWriteFontFileLoader](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritefontfileloader) |
| `IDWriteLocalFontFileLoader` | `IDWriteLocalFontFileLoader_` | `IDWriteFontFileLoader` | The built-in loader for font files on disk; gives a file's path and time. | [IDWriteLocalFontFileLoader](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritelocalfontfileloader) |
| `IDWriteFontFileStream` | `IDWriteFontFileStream_` | `ComUnknown` | Implemented by a loader to read the bytes of a font file. | [IDWriteFontFileStream](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritefontfilestream) |
| `IDWriteFontFile` | `IDWriteFontFile_` | `ComUnknown` | A reference to one font file and the loader that reads it; `Analyze` tells the file type. | [IDWriteFontFile](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritefontfile) |
| `IDWriteRenderingParams` | `IDWriteRenderingParams_` | `ComUnknown` | Settings for drawing glyphs: gamma, enhanced contrast, ClearType level, pixel geometry, rendering mode. | [IDWriteRenderingParams](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwriterenderingparams) |
| `IDWriteFontFace` | `IDWriteFontFace_` | `ComUnknown` | A font face as used for drawing: glyph indices and metrics, font tables, glyph outlines. | [IDWriteFontFace](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritefontface) |
| `IDWriteFontCollectionLoader` | `IDWriteFontCollectionLoader_` | `ComUnknown` | Implemented by a program to build a custom font collection from a key. | [IDWriteFontCollectionLoader](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritefontcollectionloader) |
| `IDWriteFontFileEnumerator` | `IDWriteFontFileEnumerator_` | `ComUnknown` | Implemented by a program to hand out the files of a custom collection. | [IDWriteFontFileEnumerator](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritefontfileenumerator) |
| `IDWriteLocalizedStrings` | `IDWriteLocalizedStrings_` | `ComUnknown` | Strings indexed by locale name, such as a family's names in several languages. | [IDWriteLocalizedStrings](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritelocalizedstrings) |
| `IDWriteFontCollection` | `IDWriteFontCollection_` | `ComUnknown` | A collection of font families, such as the fonts installed on the computer (`IDWriteFactory.GetSystemFontCollection`). | [IDWriteFontCollection](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritefontcollection) |
| `IDWriteFontList` | `IDWriteFontList_` | `ComUnknown` | A list of fonts. | [IDWriteFontList](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritefontlist) |
| `IDWriteFontFamily` | `IDWriteFontFamily_` | `IDWriteFontList` | The fonts of one family, which share a design and differ in weight, stretch or style. | [IDWriteFontFamily](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritefontfamily) |
| `IDWriteFont` | `IDWriteFont_` | `ComUnknown` | One font of a family: weight, stretch, style, metrics, names, character coverage. | [IDWriteFont](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritefont) |
| `IDWriteTextFormat` | `IDWriteTextFormat_` | `ComUnknown` | The font, size, alignment, wrapping, tab stops and line spacing of text. From `IDWriteFactory.CreateTextFormat`; the render target's `DrawText` takes one. | [IDWriteTextFormat](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritetextformat) |
| `IDWriteTypography` | `IDWriteTypography_` | `ComUnknown` | A list of OpenType features to apply to a range of a text layout. | [IDWriteTypography](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritetypography) |
| `IDWriteNumberSubstitution` | `IDWriteNumberSubstitution_` | `ComUnknown` | How digits are shaped for a locale; it has no methods of its own. | [IDWriteNumberSubstitution](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritenumbersubstitution) |
| `IDWriteTextAnalysisSource` | `IDWriteTextAnalysisSource_` | `ComUnknown` | Implemented by a program to give the text analyser its text, locale and reading direction. | [IDWriteTextAnalysisSource](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritetextanalysissource) |
| `IDWriteTextAnalysisSink` | `IDWriteTextAnalysisSink_` | `ComUnknown` | Implemented by a program to receive the results of a text analysis. | [IDWriteTextAnalysisSink](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritetextanalysissink) |
| `IDWriteTextAnalyzer` | `IDWriteTextAnalyzer_` | `ComUnknown` | Low-level text analysis: scripts, bidirectional levels, line breaks, glyph shaping and placement. | [IDWriteTextAnalyzer](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritetextanalyzer) |
| `IDWriteInlineObject` | `IDWriteInlineObject_` | `ComUnknown` | Implemented by a program to place an object, such as an image, inside a text layout. | [IDWriteInlineObject](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwriteinlineobject) |
| `IDWritePixelSnapping` | `IDWritePixelSnapping_` | `ComUnknown` | The base of `IDWriteTextRenderer`: pixel snapping, the current transform and pixels per DIP. | [IDWritePixelSnapping](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritepixelsnapping) |
| `IDWriteTextRenderer` | `IDWriteTextRenderer_` | `IDWritePixelSnapping` | Implemented by a program to receive the glyph runs, underlines, strikethroughs and inline objects of `IDWriteTextLayout.Draw`. | [IDWriteTextRenderer](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritetextrenderer) |
| `IDWriteTextLayout` | `IDWriteTextLayout_` | `IDWriteTextFormat` | A string laid out in a box with a text format, with formatting per range, metrics and hit testing. From `IDWriteFactory.CreateTextLayout`; the render target's `DrawTextLayout` takes one. | [IDWriteTextLayout](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritetextlayout) |
| `IDWriteBitmapRenderTarget` | `IDWriteBitmapRenderTarget_` | `ComUnknown` | A 32-bit DIB with its own memory DC that glyph runs are drawn into, for GDI programs. From `IDWriteGdiInterop.CreateBitmapRenderTarget`. | [IDWriteBitmapRenderTarget](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritebitmaprendertarget) |
| `IDWriteGdiInterop` | `IDWriteGdiInterop_` | `ComUnknown` | Converts between DirectWrite fonts and `LOGFONTW` or a device context's font, and creates bitmap render targets. | [IDWriteGdiInterop](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritegdiinterop) |
| `IDWriteGlyphRunAnalysis` | `IDWriteGlyphRunAnalysis_` | `ComUnknown` | Rasterises a glyph run into an alpha texture. | [IDWriteGlyphRunAnalysis](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwriteglyphrunanalysis) |
| `IDWriteFactory` | `IDWriteFactory_` | `ComUnknown` | The root object: creates text formats, text layouts, font file references, typography and rendering parameters, and gives the installed fonts. From `DWriteCreateFactory`. | [IDWriteFactory](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nn-dwrite-idwritefactory) |
| `IDWriteFactory1` | `IDWriteFactory1_` | `IDWriteFactory` | Adds the EUDC font collection and rendering parameters with grayscale contrast. | [IDWriteFactory1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/nn-dwrite_1-idwritefactory1) |
| `IDWriteFontFace1` | `IDWriteFontFace1_` | `IDWriteFontFace` | Adds extended and caret metrics, Unicode ranges, glyph advances and kerning. | [IDWriteFontFace1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/nn-dwrite_1-idwritefontface1) |
| `IDWriteFont1` | `IDWriteFont1_` | `IDWriteFont` | Adds extended metrics, PANOSE values, Unicode ranges and a monospace test. | [IDWriteFont1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/nn-dwrite_1-idwritefont1) |
| `IDWriteRenderingParams1` | `IDWriteRenderingParams1_` | `IDWriteRenderingParams` | Adds the grayscale enhanced contrast. | [IDWriteRenderingParams1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/nn-dwrite_1-idwriterenderingparams1) |
| `IDWriteTextAnalyzer1` | `IDWriteTextAnalyzer1_` | `IDWriteTextAnalyzer` | Adds character spacing, baselines, vertical glyph orientation and justification. | [IDWriteTextAnalyzer1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/nn-dwrite_1-idwritetextanalyzer1) |
| `IDWriteTextAnalysisSource1` | `IDWriteTextAnalysisSource1_` | `IDWriteTextAnalysisSource` | Adds vertical glyph orientation. | [IDWriteTextAnalysisSource1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/nn-dwrite_1-idwritetextanalysissource1) |
| `IDWriteTextAnalysisSink1` | `IDWriteTextAnalysisSink1_` | `IDWriteTextAnalysisSink` | Adds glyph orientation results. | [IDWriteTextAnalysisSink1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/nn-dwrite_1-idwritetextanalysissink1) |
| `IDWriteTextLayout1` | `IDWriteTextLayout1_` | `IDWriteTextLayout` | Adds pair kerning and character spacing per range. | [IDWriteTextLayout1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/nn-dwrite_1-idwritetextlayout1) |
| `IDWriteBitmapRenderTarget1` | `IDWriteBitmapRenderTarget1_` | `IDWriteBitmapRenderTarget` | Adds the text antialiasing mode. | [IDWriteBitmapRenderTarget1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/nn-dwrite_1-idwritebitmaprendertarget1) |
| `IDWriteTextRenderer1` | `IDWriteTextRenderer1_` | `IDWriteTextRenderer` | Adds the orientation angle to each callback. | [IDWriteTextRenderer1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_2/nn-dwrite_2-idwritetextrenderer1) |
| `IDWriteTextFormat1` | `IDWriteTextFormat1_` | `IDWriteTextFormat` | Adds vertical glyph orientation, last-line wrapping, optical alignment and font fallback. | [IDWriteTextFormat1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_2/nn-dwrite_2-idwritetextformat1) |
| `IDWriteTextLayout2` | `IDWriteTextLayout2_` | `IDWriteTextLayout1` | Adds `GetMetrics2`, vertical glyph orientation, last-line wrapping, optical alignment and font fallback. | [IDWriteTextLayout2](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_2/nn-dwrite_2-idwritetextlayout2) |
| `IDWriteTextAnalyzer2` | `IDWriteTextAnalyzer2_` | `IDWriteTextAnalyzer1` | Adds orientation transforms and OpenType feature queries. | [IDWriteTextAnalyzer2](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_2/nn-dwrite_2-idwritetextanalyzer2) |
| `IDWriteFontFallback` | `IDWriteFontFallback_` | `ComUnknown` | Maps a run of text to the fonts that can display it. | [IDWriteFontFallback](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_2/nn-dwrite_2-idwritefontfallback) |
| `IDWriteFontFallbackBuilder` | `IDWriteFontFallbackBuilder_` | `ComUnknown` | Builds a custom font fallback from Unicode-range mappings. | [IDWriteFontFallbackBuilder](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_2/nn-dwrite_2-idwritefontfallbackbuilder) |
| `IDWriteFont2` | `IDWriteFont2_` | `IDWriteFont1` | Adds a test for colour glyphs. | [IDWriteFont2](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_2/nn-dwrite_2-idwritefont2) |
| `IDWriteFontFace2` | `IDWriteFontFace2_` | `IDWriteFontFace1` | Adds colour palettes and recommended rendering modes. | [IDWriteFontFace2](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_2/nn-dwrite_2-idwritefontface2) |
| `IDWriteColorGlyphRunEnumerator` | `IDWriteColorGlyphRunEnumerator_` | `ComUnknown` | Walks the coloured layers of a glyph run, from `IDWriteFactory2.TranslateColorGlyphRun`. | [IDWriteColorGlyphRunEnumerator](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_2/nn-dwrite_2-idwritecolorglyphrunenumerator) |
| `IDWriteRenderingParams2` | `IDWriteRenderingParams2_` | `IDWriteRenderingParams1` | Adds the grid-fit mode. | [IDWriteRenderingParams2](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_2/nn-dwrite_2-idwriterenderingparams2) |
| `IDWriteFactory2` | `IDWriteFactory2_` | `IDWriteFactory1` | Adds the system font fallback, fallback builders and colour glyph translation. | [IDWriteFactory2](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_2/nn-dwrite_2-idwritefactory2) |
| `IDWriteRenderingParams3` | `IDWriteRenderingParams3_` | `IDWriteRenderingParams2` | Adds the rendering mode as a `DWRITE_RENDERING_MODE1`. | [IDWriteRenderingParams3](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwriterenderingparams3) |
| `IDWriteFactory3` | `IDWriteFactory3_` | `IDWriteFactory2` | Adds font sets, font face references, glyph run analysis with antialias mode and the font download queue. | [IDWriteFactory3](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefactory3) |
| `IDWriteFontSet` | `IDWriteFontSet_` | `ComUnknown` | A set of font face references with their properties, searchable by property. | [IDWriteFontSet](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontset) |
| `IDWriteFontSetBuilder` | `IDWriteFontSetBuilder_` | `ComUnknown` | Builds a font set from face references and other sets. | [IDWriteFontSetBuilder](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontsetbuilder) |
| `IDWriteFontCollection1` | `IDWriteFontCollection1_` | `IDWriteFontCollection` | Adds the font set the collection is built on. | [IDWriteFontCollection1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontcollection1) |
| `IDWriteFontFamily1` | `IDWriteFontFamily1_` | `IDWriteFontFamily` | Adds locality and face references for its fonts. | [IDWriteFontFamily1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontfamily1) |
| `IDWriteFontList1` | `IDWriteFontList1_` | `IDWriteFontList` | Adds locality and face references. | [IDWriteFontList1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontlist1) |
| `IDWriteFontFaceReference` | `IDWriteFontFaceReference_` | `ComUnknown` | A reference to a face in a local or remote font file, which creates the face when needed. | [IDWriteFontFaceReference](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontfacereference) |
| `IDWriteFont3` | `IDWriteFont3_` | `IDWriteFont2` | Adds font face references, locality and comparison. `IID_IDWriteFont3` holds the same value as `IID_IDWriteFont2`. | [IDWriteFont3](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefont3) |
| `IDWriteFontFace3` | `IDWriteFontFace3_` | `IDWriteFontFace2` | Adds the face reference, names, PANOSE values and character tests. | [IDWriteFontFace3](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontface3) |
| `IDWriteStringList` | `IDWriteStringList_` | `ComUnknown` | A list of strings, each with a locale name. | [IDWriteStringList](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritestringlist) |
| `IDWriteFontDownloadListener` | `IDWriteFontDownloadListener_` | `ComUnknown` | Implemented by a program to hear that queued font downloads have finished. | [IDWriteFontDownloadListener](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontdownloadlistener) |
| `IDWriteFontDownloadQueue` | `IDWriteFontDownloadQueue_` | `ComUnknown` | The queue of pending downloads of remote fonts. | [IDWriteFontDownloadQueue](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontdownloadqueue) |
| `IDWriteGdiInterop1` | `IDWriteGdiInterop1_` | `IDWriteGdiInterop` | Adds font signatures and matching a `LOGFONTW` within a font set. | [IDWriteGdiInterop1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritegdiinterop1) |
| `IDWriteTextFormat2` | `IDWriteTextFormat2_` | `IDWriteTextFormat1` | Adds line spacing as a `DWRITE_LINE_SPACING`. | [IDWriteTextFormat2](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritetextformat2) |
| `IDWriteTextLayout3` | `IDWriteTextLayout3_` | `IDWriteTextLayout2` | Adds line spacing as a `DWRITE_LINE_SPACING`, line metrics with leading and `InvalidateLayout`. | [IDWriteTextLayout3](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritetextlayout3) |
| `IDWriteColorGlyphRunEnumerator1` | `IDWriteColorGlyphRunEnumerator1_` | `IDWriteColorGlyphRunEnumerator` | Adds the image format and measuring mode of each layer. | [IDWriteColorGlyphRunEnumerator1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritecolorglyphrunenumerator1) |
| `IDWriteFontFace4` | `IDWriteFontFace4_` | `IDWriteFontFace3` | Adds glyph images in SVG, PNG, JPEG or TIFF form. | [IDWriteFontFace4](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontface4) |
| `IDWriteFactory4` | `IDWriteFactory4_` | `IDWriteFactory3` | Adds colour glyph translation with image formats, and glyph origins. | [IDWriteFactory4](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefactory4) |
| `IDWriteFontSetBuilder1` | `IDWriteFontSetBuilder1_` | `IDWriteFontSetBuilder` | Adds every face of a font file. | [IDWriteFontSetBuilder1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontsetbuilder1) |
| `IDWriteAsyncResult` | `IDWriteAsyncResult_` | `ComUnknown` | The wait handle and result of an asynchronous font download. | [IDWriteAsyncResult](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwriteasyncresult) |
| `IDWriteRemoteFontFileStream` | `IDWriteRemoteFontFileStream_` | `IDWriteFontFileStream` | A stream over a font file that may be only partly downloaded. | [IDWriteRemoteFontFileStream](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwriteremotefontfilestream) |
| `IDWriteRemoteFontFileLoader` | `IDWriteRemoteFontFileLoader_` | `IDWriteFontFileLoader` | The built-in loader for fonts that are downloaded. | [IDWriteRemoteFontFileLoader](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwriteremotefontfileloader) |
| `IDWriteInMemoryFontFileLoader` | `IDWriteInMemoryFontFileLoader_` | `IDWriteFontFileLoader` | A built-in loader for font files held in memory. | [IDWriteInMemoryFontFileLoader](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwriteinmemoryfontfileloader) |
| `IDWriteFactory5` | `IDWriteFactory5_` | `IDWriteFactory4` | Adds font set builders, in-memory and HTTP font file loaders, and WOFF unpacking. | [IDWriteFactory5](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefactory5) |
| `IDWriteFactory6` | `IDWriteFactory6_` | `IDWriteFactory5` | Adds font resources, variable-font axes and typographic font collections. | [IDWriteFactory6](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefactory6) |
| `IDWriteFontFace5` | `IDWriteFontFace5_` | `IDWriteFontFace4` | Adds variable-font axis values and the font resource. | [IDWriteFontFace5](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontface5) |
| `IDWriteFontResource` | `IDWriteFontResource_` | `ComUnknown` | A face of a font file with its variable-font axes, which creates faces at chosen axis values. | [IDWriteFontResource](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontresource) |
| `IDWriteFontFaceReference1` | `IDWriteFontFaceReference1_` | `IDWriteFontFaceReference` | Adds axis values. | [IDWriteFontFaceReference1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontfacereference1) |
| `IDWriteFontSetBuilder2` | `IDWriteFontSetBuilder2_` | `IDWriteFontSetBuilder1` | Adds fonts with axis ranges and properties, and font files by path. | [IDWriteFontSetBuilder2](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontsetbuilder2) |
| `IDWriteFontSet1` | `IDWriteFontSet1_` | `IDWriteFontSet` | Adds matching and filtering by axis values and properties, and font resources. | [IDWriteFontSet1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontset1) |
| `IDWriteFontList2` | `IDWriteFontList2_` | `IDWriteFontList1` | Adds the list's font set. | [IDWriteFontList2](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontlist2) |
| `IDWriteFontFamily2` | `IDWriteFontFamily2_` | `IDWriteFontFamily1` | Adds matching by axis values and the family's font set. | [IDWriteFontFamily2](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontfamily2) |
| `IDWriteFontCollection2` | `IDWriteFontCollection2_` | `IDWriteFontCollection1` | Adds the family model and matching by axis values. | [IDWriteFontCollection2](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontcollection2) |
| `IDWriteTextLayout4` | `IDWriteTextLayout4_` | `IDWriteTextLayout3` | Adds variable-font axis values per range. | [IDWriteTextLayout4](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritetextlayout4) |
| `IDWriteTextFormat3` | `IDWriteTextFormat3_` | `IDWriteTextFormat2` | Adds variable-font axis values. | [IDWriteTextFormat3](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritetextformat3) |
| `IDWriteFontFallback1` | `IDWriteFontFallback1_` | `IDWriteFontFallback` | Adds mapping with variable-font axis values. | [IDWriteFontFallback1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontfallback1) |
| `IDWriteFontSet2` | `IDWriteFontSet2_` | `IDWriteFontSet1` | Adds an event that is signalled when the set is out of date. | [IDWriteFontSet2](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontset2) |
| `IDWriteFontCollection3` | `IDWriteFontCollection3_` | `IDWriteFontCollection2` | Adds an event that is signalled when the collection is out of date. | [IDWriteFontCollection3](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontcollection3) |
| `IDWriteFactory7` | `IDWriteFactory7_` | `IDWriteFactory6` | Adds system font sets and collections that can include downloadable fonts. | [IDWriteFactory7](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefactory7) |
| `IDWriteFontSet3` | `IDWriteFontSet3_` | `IDWriteFontSet2` | Adds the source type and source name of each font. | [IDWriteFontSet3](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontset3) |
| `IDWriteFontFace6` | `IDWriteFontFace6_` | `IDWriteFontFace5` | Adds family and face names for a chosen family model. | — |
| `IDWriteFontSet4` | `IDWriteFontSet4_` | `IDWriteFontSet3` | Adds conversion from weight, stretch and style to axis values, and matching with simulations. | [IDWriteFontSet4](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/nn-dwrite_3-idwritefontset4) |
| `IDWriteBitmapRenderTarget2` | `IDWriteBitmapRenderTarget2_` | `IDWriteBitmapRenderTarget1` | Adds direct access to the bitmap's pixels. | — |
| `IDWriteBitmapRenderTarget3` | `IDWriteBitmapRenderTarget3_` | `IDWriteBitmapRenderTarget2` | Adds drawing of colour glyph runs. | — |
| `IDWritePaintReader` | `IDWritePaintReader_` | `ComUnknown` | Reads the paint tree of a COLR version 1 colour glyph. | — |
| `IDWriteFontFace7` | `IDWriteFontFace7_` | `IDWriteFontFace6` | Adds reading of colour (COLR) paint data. | — |
| `IDWriteFactory8` | `IDWriteFactory8_` | `IDWriteFactory7` | Adds colour glyph translation at a given paint feature level. | — |

### Enumerations

| Type | Values | Is | Microsoft Learn |
| --- | --- | --- | --- |
| `DWRITE_FONT_FILE_TYPE` | `DWRITE_FONT_FILE_TYPE_*` | The format of a font file: CFF, TrueType, OpenType collection, Type 1, vector, bitmap. | [DWRITE_FONT_FILE_TYPE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_font_file_type) |
| `DWRITE_FONT_FACE_TYPE` | `DWRITE_FONT_FACE_TYPE_*` | The format of a font face: CFF, TrueType, collection member, Type 1, vector, bitmap, raw CFF. | [DWRITE_FONT_FACE_TYPE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_font_face_type) |
| `DWRITE_FONT_SIMULATIONS` | `DWRITE_FONT_SIMULATIONS_*` | Simulated bold and oblique, which can be combined with `or`. | [DWRITE_FONT_SIMULATIONS](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_font_simulations) |
| `DWRITE_FONT_WEIGHT` | `DWRITE_FONT_WEIGHT_*` | Font weights from thin (100) through normal (400) and bold (700) to extra black (950). | [DWRITE_FONT_WEIGHT](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_font_weight) |
| `DWRITE_FONT_STRETCH` | `DWRITE_FONT_STRETCH_*` | Font widths from ultra-condensed (1) through normal (5) to ultra-expanded (9). | [DWRITE_FONT_STRETCH](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_font_stretch) |
| `DWRITE_FONT_STYLE` | `DWRITE_FONT_STYLE_*` | Normal, oblique, italic. | [DWRITE_FONT_STYLE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_font_style) |
| `DWRITE_INFORMATIONAL_STRING_ID` | `DWRITE_INFORMATIONAL_STRING_*` | Which string to read from a font: copyright, version, designer, family names, full name, sample text … | [DWRITE_INFORMATIONAL_STRING_ID](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_informational_string_id) |
| `DWRITE_FACTORY_TYPE` | `DWRITE_FACTORY_TYPE_*` | A shared factory, whose cached font data other components reuse, or an isolated one. | [DWRITE_FACTORY_TYPE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_factory_type) |
| `DWRITE_PIXEL_GEOMETRY` | `DWRITE_PIXEL_GEOMETRY_*` | The order of the sub-pixels of the display: flat, RGB, BGR. | [DWRITE_PIXEL_GEOMETRY](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_pixel_geometry) |
| `DWRITE_RENDERING_MODE` | `DWRITE_RENDERING_MODE_*` | How glyphs are rasterised: aliased, GDI classic or natural, natural, symmetric, outline. | [DWRITE_RENDERING_MODE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_rendering_mode) |
| `DWRITE_READING_DIRECTION` | `DWRITE_READING_DIRECTION_*` | Direction of reading within a line: left to right, right to left, top to bottom, bottom to top. | [DWRITE_READING_DIRECTION](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_reading_direction) |
| `DWRITE_FLOW_DIRECTION` | `DWRITE_FLOW_DIRECTION_*` | Direction in which lines follow one another. | [DWRITE_FLOW_DIRECTION](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_flow_direction) |
| `DWRITE_TEXT_ALIGNMENT` | `DWRITE_TEXT_ALIGNMENT_*` | Horizontal alignment: leading, trailing, centre, justified. | [DWRITE_TEXT_ALIGNMENT](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_text_alignment) |
| `DWRITE_PARAGRAPH_ALIGNMENT` | `DWRITE_PARAGRAPH_ALIGNMENT_*` | Vertical alignment in the layout box: near, far, centre. | [DWRITE_PARAGRAPH_ALIGNMENT](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_paragraph_alignment) |
| `DWRITE_WORD_WRAPPING` | `DWRITE_WORD_WRAPPING_*` | Wrapping: wrap, no wrap, emergency break, whole word, character. | [DWRITE_WORD_WRAPPING](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_word_wrapping) |
| `DWRITE_LINE_SPACING_METHOD` | `DWRITE_LINE_SPACING_METHOD_*` | Line spacing: default, uniform, proportional. | [DWRITE_LINE_SPACING_METHOD](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_line_spacing_method) |
| `DWRITE_TRIMMING_GRANULARITY` | `DWRITE_TRIMMING_GRANULARITY_*` | Where text that does not fit is cut: nowhere, at a character, at a word. | [DWRITE_TRIMMING_GRANULARITY](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_trimming_granularity) |
| `DWRITE_FONT_FEATURE_TAG` | `DWRITE_FONT_FEATURE_TAG_*` | OpenType feature tags: kerning, ligatures, small capitals, stylistic sets, tabular figures … | [DWRITE_FONT_FEATURE_TAG](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_font_feature_tag) |
| `DWRITE_SCRIPT_SHAPES` | `DWRITE_SCRIPT_SHAPES_*` | Whether a script run is drawn or has no visual form. | [DWRITE_SCRIPT_SHAPES](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_script_shapes) |
| `DWRITE_BREAK_CONDITION` | `DWRITE_BREAK_CONDITION_*` | Whether a line may break before or after a character. | [DWRITE_BREAK_CONDITION](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_break_condition) |
| `DWRITE_NUMBER_SUBSTITUTION_METHOD` | `DWRITE_NUMBER_SUBSTITUTION_METHOD_*` | How digits are substituted: from the culture, contextual, none, national, traditional. | [DWRITE_NUMBER_SUBSTITUTION_METHOD](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_number_substitution_method) |
| `DWRITE_TEXTURE_TYPE` | `DWRITE_TEXTURE_ALIASED_1x1`, `DWRITE_TEXTURE_CLEARTYPE_3x1` | Alpha texture type of a glyph run analysis: aliased 1×1 or ClearType 3×1. | [DWRITE_TEXTURE_TYPE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_texture_type) |
| `DWRITE_PANOSE_FAMILY` | `DWRITE_PANOSE_FAMILY_*` | PANOSE family kind: text and display, script, decorative, symbol. | [DWRITE_PANOSE_FAMILY](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_family) |
| `DWRITE_PANOSE_SERIF_STYLE` | `DWRITE_PANOSE_SERIF_STYLE_*` | PANOSE serif style. | [DWRITE_PANOSE_SERIF_STYLE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_serif_style) |
| `DWRITE_PANOSE_WEIGHT` | `DWRITE_PANOSE_WEIGHT_*` | PANOSE weight. | [DWRITE_PANOSE_WEIGHT](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_weight) |
| `DWRITE_PANOSE_PROPORTION` | `DWRITE_PANOSE_PROPORTION_*` | PANOSE proportion. | [DWRITE_PANOSE_PROPORTION](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_proportion) |
| `DWRITE_PANOSE_CONTRAST` | `DWRITE_PANOSE_CONTRAST_*` | PANOSE stroke contrast. | [DWRITE_PANOSE_CONTRAST](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_contrast) |
| `DWRITE_PANOSE_STROKE_VARIATION` | `DWRITE_PANOSE_STROKE_VARIATION_*` | PANOSE stroke variation. | [DWRITE_PANOSE_STROKE_VARIATION](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_stroke_variation) |
| `DWRITE_PANOSE_ARM_STYLE` | `DWRITE_PANOSE_ARM_STYLE_*` | PANOSE arm style. | [DWRITE_PANOSE_ARM_STYLE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_arm_style) |
| `DWRITE_PANOSE_LETTERFORM` | `DWRITE_PANOSE_LETTERFORM_*` | PANOSE letterform. | [DWRITE_PANOSE_LETTERFORM](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_letterform) |
| `DWRITE_PANOSE_MIDLINE` | `DWRITE_PANOSE_MIDLINE_*` | PANOSE midline. | [DWRITE_PANOSE_MIDLINE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_midline) |
| `DWRITE_PANOSE_XHEIGHT` | `DWRITE_PANOSE_XHEIGHT_*` | PANOSE x-height. | [DWRITE_PANOSE_XHEIGHT](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_xheight) |
| `DWRITE_PANOSE_TOOL_KIND` | `DWRITE_PANOSE_TOOL_KIND_*` | PANOSE tool kind, for script fonts. | [DWRITE_PANOSE_TOOL_KIND](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_tool_kind) |
| `DWRITE_PANOSE_SPACING` | `DWRITE_PANOSE_SPACING_*` | PANOSE spacing: proportional or monospaced. | [DWRITE_PANOSE_SPACING](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_spacing) |
| `DWRITE_PANOSE_ASPECT_RATIO` | `DWRITE_PANOSE_ASPECT_RATIO_*` | PANOSE aspect ratio, for script fonts. | [DWRITE_PANOSE_ASPECT_RATIO](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_aspect_ratio) |
| `DWRITE_PANOSE_SCRIPT_TOPOLOGY` | `DWRITE_PANOSE_SCRIPT_TOPOLOGY_*` | PANOSE script topology. | [DWRITE_PANOSE_SCRIPT_TOPOLOGY](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_script_topology) |
| `DWRITE_PANOSE_SCRIPT_FORM` | `DWRITE_PANOSE_SCRIPT_FORM_*` | PANOSE script form. | [DWRITE_PANOSE_SCRIPT_FORM](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_script_form) |
| `DWRITE_PANOSE_FINIALS` | `DWRITE_PANOSE_FINIALS_*` | PANOSE finials. | [DWRITE_PANOSE_FINIALS](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_finials) |
| `DWRITE_PANOSE_XASCENT` | `DWRITE_PANOSE_XASCENT_*` | PANOSE x-ascent. | [DWRITE_PANOSE_XASCENT](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_xascent) |
| `DWRITE_PANOSE_DECORATIVE_CLASS` | `DWRITE_PANOSE_DECORATIVE_CLASS_*` | PANOSE decorative class. | [DWRITE_PANOSE_DECORATIVE_CLASS](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_decorative_class) |
| `DWRITE_PANOSE_ASPECT` | `DWRITE_PANOSE_ASPECT_*` | PANOSE aspect, for decorative fonts. | [DWRITE_PANOSE_ASPECT](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_aspect) |
| `DWRITE_PANOSE_FILL` | `DWRITE_PANOSE_FILL_*` | PANOSE fill. | [DWRITE_PANOSE_FILL](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_fill) |
| `DWRITE_PANOSE_LINING` | `DWRITE_PANOSE_LINING_*` | PANOSE lining. | [DWRITE_PANOSE_LINING](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_lining) |
| `DWRITE_PANOSE_DECORATIVE_TOPOLOGY` | `DWRITE_PANOSE_DECORATIVE_TOPOLOGY_*` | PANOSE decorative topology. | [DWRITE_PANOSE_DECORATIVE_TOPOLOGY](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_decorative_topology) |
| `DWRITE_PANOSE_CHARACTER_RANGES` | `DWRITE_PANOSE_CHARACTER_RANGES_*` | PANOSE character ranges. | [DWRITE_PANOSE_CHARACTER_RANGES](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_character_ranges) |
| `DWRITE_PANOSE_SYMBOL_KIND` | `DWRITE_PANOSE_SYMBOL_KIND_*` | PANOSE symbol kind. | [DWRITE_PANOSE_SYMBOL_KIND](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_symbol_kind) |
| `DWRITE_PANOSE_SYMBOL_ASPECT_RATIO` | `DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_*` | PANOSE symbol aspect ratio. | [DWRITE_PANOSE_SYMBOL_ASPECT_RATIO](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_panose_symbol_aspect_ratio) |
| `DWRITE_OUTLINE_THRESHOLD` | `DWRITE_OUTLINE_THRESHOLD_*` | Whether outlines of large text are antialiased or aliased. | [DWRITE_OUTLINE_THRESHOLD](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_outline_threshold) |
| `DWRITE_BASELINE` | `DWRITE_BASELINE_*` | Baselines: roman, central, math, hanging, ideographic bottom and top, minimum, maximum. | [DWRITE_BASELINE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_baseline) |
| `DWRITE_VERTICAL_GLYPH_ORIENTATION` | `DWRITE_VERTICAL_GLYPH_ORIENTATION_*` | Glyphs in vertical text: default or stacked. | [DWRITE_VERTICAL_GLYPH_ORIENTATION](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_vertical_glyph_orientation) |
| `DWRITE_GLYPH_ORIENTATION_ANGLE` | `DWRITE_GLYPH_ORIENTATION_ANGLE_*` | Glyph rotation in steps of 90 degrees. | [DWRITE_GLYPH_ORIENTATION_ANGLE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_glyph_orientation_angle) |
| `DWRITE_TEXT_ANTIALIAS_MODE` | `DWRITE_TEXT_ANTIALIAS_MODE_*` | ClearType or grayscale antialiasing. | [DWRITE_TEXT_ANTIALIAS_MODE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ne-dwrite_1-dwrite_text_antialias_mode) |
| `DWRITE_OPTICAL_ALIGNMENT` | `DWRITE_OPTICAL_ALIGNMENT_*` | Whether lines align to glyph edges, ignoring side bearings. | [DWRITE_OPTICAL_ALIGNMENT](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_2/ne-dwrite_2-dwrite_optical_alignment) |
| `DWRITE_GRID_FIT_MODE` | `DWRITE_GRID_FIT_MODE_*` | Whether glyph outlines are fitted to the pixel grid. | [DWRITE_GRID_FIT_MODE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_2/ne-dwrite_2-dwrite_grid_fit_mode) |
| `DWRITE_FONT_PROPERTY_ID` | `DWRITE_FONT_PROPERTY_ID_*` | Font properties a font set can be searched by: family names, full name, weight, stretch, style, script tags … | [DWRITE_FONT_PROPERTY_ID](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/ne-dwrite_3-dwrite_font_property_id) |
| `DWRITE_LOCALITY` | `DWRITE_LOCALITY_*` | Where a font's data is: remote, partly local, local. | [DWRITE_LOCALITY](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/ne-dwrite_3-dwrite_locality) |
| `DWRITE_RENDERING_MODE1` | `DWRITE_RENDERING_MODE1_*` | Rendering modes, adding natural symmetric downsampled. | [DWRITE_RENDERING_MODE1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/ne-dwrite_3-dwrite_rendering_mode1) |
| `DWRITE_FONT_LINE_GAP_USAGE` | `DWRITE_FONT_LINE_GAP_USAGE_*` | Whether the font's line gap is added to line height. | [DWRITE_FONT_LINE_GAP_USAGE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/ne-dwrite_3-dwrite_font_line_gap_usage) |
| `DWRITE_CONTAINER_TYPE` | `DWRITE_CONTAINER_TYPE_*` | The packaging of a font file: none, WOFF, WOFF2. | [DWRITE_CONTAINER_TYPE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/ne-dwrite_3-dwrite_container_type) |
| `DWRITE_FONT_AXIS_TAG` | `DWRITE_FONT_AXIS_TAG_*` | Variable-font axes: weight, width, slant, optical size, italic. | [DWRITE_FONT_AXIS_TAG](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/ne-dwrite_3-dwrite_font_axis_tag) |
| `DWRITE_FONT_FAMILY_MODEL` | `DWRITE_FONT_FAMILY_MODEL_*` | How fonts are grouped into families: typographic or weight-stretch-style. | [DWRITE_FONT_FAMILY_MODEL](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/ne-dwrite_3-dwrite_font_family_model) |
| `DWRITE_AUTOMATIC_FONT_AXES` | `DWRITE_AUTOMATIC_FONT_AXES_*` | Axes set automatically: none, optical size. | [DWRITE_AUTOMATIC_FONT_AXES](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/ne-dwrite_3-dwrite_automatic_font_axes) |
| `DWRITE_FONT_AXIS_ATTRIBUTES` | `DWRITE_FONT_AXIS_ATTRIBUTES_*` | Attributes of an axis: variable, hidden. | [DWRITE_FONT_AXIS_ATTRIBUTES](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/ne-dwrite_3-dwrite_font_axis_attributes) |
| `DWRITE_FONT_SOURCE_TYPE` | `DWRITE_FONT_SOURCE_TYPE_*` | Where a font comes from: per machine, per user, an app package, a font provider. | [DWRITE_FONT_SOURCE_TYPE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/ne-dwrite_3-dwrite_font_source_type) |
| `DWRITE_PAINT_FEATURE_LEVEL` | `DWRITE_PAINT_FEATURE_LEVEL_*` | Level of colour-font support: none, COLR version 0, COLR version 1. Declared `as INT32`. | — |
| `DWRITE_PAINT_ATTRIBUTES` | `DWRITE_PAINT_ATTRIBUTES_*` | What a colour glyph's paint uses: the palette, the text colour. | — |
| `DWRITE_COLOR_COMPOSITE_MODE` | `DWRITE_COLOR_COMPOSITE_*` | Compositing modes of COLR paint: Porter-Duff and blend modes. | — |
| `DWRITE_PAINT_TYPE` | `DWRITE_PAINT_TYPE_*` | Kinds of COLR paint element: layers, solid glyph, gradients, transforms, composite … | — |

### Structures

| Type | Is | Microsoft Learn |
| --- | --- | --- |
| `DWRITE_FONT_METRICS` | Metrics of a face in design units: units per em, ascent, descent, line gap, cap height, x-height, underline and strikethrough. | [DWRITE_FONT_METRICS](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_font_metrics) |
| `DWRITE_GLYPH_METRICS` | Advance and side bearings of one glyph, in design units. | [DWRITE_GLYPH_METRICS](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_glyph_metrics) |
| `DWRITE_GLYPH_OFFSET` | A glyph's offset from its normal position, along and across the run. | [DWRITE_GLYPH_OFFSET](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_glyph_offset) |
| `DWRITE_MATRIX` | A 2D transform (`m11` … `dy`). | [DWRITE_MATRIX](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_matrix) |
| `DWRITE_TEXT_RANGE` | A range of text: start position and length. | [DWRITE_TEXT_RANGE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_text_range) |
| `DWRITE_FONT_FEATURE` | An OpenType feature tag and its parameter. | [DWRITE_FONT_FEATURE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_font_feature) |
| `DWRITE_TYPOGRAPHIC_FEATURES` | A pointer to an array of features and their count. | [DWRITE_TYPOGRAPHIC_FEATURES](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_typographic_features) |
| `DWRITE_TRIMMING` | Trimming granularity, delimiter character and delimiter count. | [DWRITE_TRIMMING](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_trimming) |
| `DWRITE_SCRIPT_ANALYSIS` | The script of a text run and whether it is drawn. | [DWRITE_SCRIPT_ANALYSIS](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_script_analysis) |
| `DWRITE_LINE_BREAKPOINT` | Break conditions before and after a character, whitespace and soft hyphen bits. | [DWRITE_LINE_BREAKPOINT](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_line_breakpoint) |
| `DWRITE_SHAPING_TEXT_PROPERTIES` | Per-character shaping bits. | [DWRITE_SHAPING_TEXT_PROPERTIES](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_shaping_text_properties) |
| `DWRITE_SHAPING_GLYPH_PROPERTIES` | Per-glyph shaping bits: justification, cluster start, diacritic, zero width. | [DWRITE_SHAPING_GLYPH_PROPERTIES](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_shaping_glyph_properties) |
| `DWRITE_GLYPH_RUN` | A run of glyphs of one face and size: indices, advances, offsets, sideways flag, bidi level. | [DWRITE_GLYPH_RUN](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_glyph_run) |
| `DWRITE_GLYPH_RUN_DESCRIPTION` | The text a glyph run came from: locale, string and cluster map. | [DWRITE_GLYPH_RUN_DESCRIPTION](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_glyph_run_description) |
| `DWRITE_UNDERLINE` | Width, thickness, offset, run height and direction of an underline. | [DWRITE_UNDERLINE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_underline) |
| `DWRITE_STRIKETHROUGH` | Width, thickness, offset and direction of a strikethrough. | [DWRITE_STRIKETHROUGH](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_strikethrough) |
| `DWRITE_LINE_METRICS` | Length, trailing whitespace, newline length, height and baseline of a line. | [DWRITE_LINE_METRICS](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_line_metrics) |
| `DWRITE_CLUSTER_METRICS` | Width and length of a cluster, with wrap, whitespace, newline and direction bits. | [DWRITE_CLUSTER_METRICS](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_cluster_metrics) |
| `DWRITE_TEXT_METRICS` | The size of laid-out text: left, top, width, height, layout box, line count. | [DWRITE_TEXT_METRICS](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_text_metrics) |
| `DWRITE_INLINE_OBJECT_METRICS` | Width, height and baseline of an inline object. | [DWRITE_INLINE_OBJECT_METRICS](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_inline_object_metrics) |
| `DWRITE_OVERHANG_METRICS` | How far the drawn text extends beyond the layout box on each side. | [DWRITE_OVERHANG_METRICS](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_overhang_metrics) |
| `DWRITE_HIT_TEST_METRICS` | Text position, length and rectangle of a hit-test result. | [DWRITE_HIT_TEST_METRICS](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_hit_test_metrics) |
| `DWRITE_FONT_METRICS1` | `DWRITE_FONT_METRICS` plus glyph box, sub- and superscript positions and sizes. | [DWRITE_FONT_METRICS1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ns-dwrite_1-dwrite_font_metrics1) |
| `DWRITE_CARET_METRICS` | Slope and offset of the caret for a face. | [DWRITE_CARET_METRICS](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ns-dwrite_1-dwrite_caret_metrics) |
| `DWRITE_PANOSE` | The ten PANOSE bytes, as a union: `values`, or the `text`, `script`, `decorative` and `symbol` views of their meaning. | [DWRITE_PANOSE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ns-dwrite_1-dwrite_panose) |
| `DWRITE_UNICODE_RANGE` | A range of code points, first and last. | [DWRITE_UNICODE_RANGE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ns-dwrite_1-dwrite_unicode_range) |
| `DWRITE_SCRIPT_PROPERTIES` | ISO script code and number and the writing traits of a script. | [DWRITE_SCRIPT_PROPERTIES](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ns-dwrite_1-dwrite_script_properties) |
| `DWRITE_JUSTIFICATION_OPPORTUNITY` | How much a glyph may expand or compress when a line is justified. | [DWRITE_JUSTIFICATION_OPPORTUNITY](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_1/ns-dwrite_1-dwrite_justification_opportunity) |
| `DWRITE_TEXT_METRICS1` | `DWRITE_TEXT_METRICS` plus the height including trailing whitespace. | [DWRITE_TEXT_METRICS1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_2/ns-dwrite_2-dwrite_text_metrics1) |
| `D3DCOLORVALUE` | A colour as four `single` values `r`, `g`, `b`, `a` from 0 to 1 (also `dvR` … `dvA`). | [D3DCOLORVALUE](https://learn.microsoft.com/en-us/windows/win32/direct3d9/d3dcolorvalue) |
| `DWRITE_COLOR_GLYPH_RUN` | One colour layer of a glyph run: the run, its origin, colour and palette index. | [DWRITE_COLOR_GLYPH_RUN](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_2/ns-dwrite_2-dwrite_color_glyph_run) |
| `DWRITE_FONT_PROPERTY` | A font property id, its value and locale name. | [DWRITE_FONT_PROPERTY](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/ns-dwrite_3-dwrite_font_property) |
| `DWRITE_LINE_METRICS1` | `DWRITE_LINE_METRICS` plus leading before and after. | [DWRITE_LINE_METRICS1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/ns-dwrite_3-dwrite_line_metrics1) |
| `DWRITE_LINE_SPACING` | Line spacing method, height, baseline, leading and line-gap usage. | [DWRITE_LINE_SPACING](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/ns-dwrite_3-dwrite_line_spacing) |
| `DWRITE_COLOR_GLYPH_RUN1` | `DWRITE_COLOR_GLYPH_RUN` plus image format and measuring mode. | [DWRITE_COLOR_GLYPH_RUN1](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/ns-dwrite_3-dwrite_color_glyph_run1) |
| `DWRITE_GLYPH_IMAGE_DATA` | The data of a glyph image (PNG, SVG …) with its size and origins. | [DWRITE_GLYPH_IMAGE_DATA](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/ns-dwrite_3-dwrite_glyph_image_data) |
| `DWRITE_FILE_FRAGMENT` | A byte range of a font file to download. | [DWRITE_FILE_FRAGMENT](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/ns-dwrite_3-dwrite_file_fragment) |
| `DWRITE_FONT_AXIS_VALUE` | A variable-font axis and its value. | [DWRITE_FONT_AXIS_VALUE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/ns-dwrite_3-dwrite_font_axis_value) |
| `DWRITE_FONT_AXIS_RANGE` | A variable-font axis and its minimum and maximum. | [DWRITE_FONT_AXIS_RANGE](https://learn.microsoft.com/en-us/windows/win32/api/dwrite_3/ns-dwrite_3-dwrite_font_axis_range) |
| `DWRITE_BITMAP_DATA_BGRA32` | Width, height and pixel pointer of a bitmap render target's pixels. | — |
| `DWRITE_PAINT_COLOR` | A COLR paint colour: value, palette index, alpha and attributes. | — |
| `DWRITE_PAINT_ELEMENT` | One node of a COLR paint tree: its `paintType` and a union `PAINT_UNION` of the per-type data (`PAINT_LAYERS`, `PAINT_SOLID_GLYPH`, `PAINT_LINEAR_GRADIENT`, `PAINT_RADIAL_GRADIENT`, `PAINT_SWEEP_GRADIENT`, `PAINT_GLYPH`, `PAINT_COLOR_GLYPH`, `PAINT_COMPOSITE` …). | — |

### Other types

| Type | Declared as | Is | Microsoft Learn |
| --- | --- | --- | --- |
| `DWRITE_COLOR_F` | `D3DCOLORVALUE` | A `D3DCOLORVALUE`, the colour type of colour glyph runs and palettes. | — |

## Using the interfaces

Short pieces that start from a factory.

A later version of an interface, from `QueryInterface` with its identifier:

**Example**

```freebasic
dim pF as IDWriteFactory ptr, pF2 as IDWriteFactory2 ptr
DWriteCreateFactory( DWRITE_FACTORY_TYPE_SHARED, IID_IDWriteFactory, pF )
if pF->QueryInterface( @IID_IDWriteFactory2, cast( any ptr ptr, @pF2 ) ) = S_OK then pF2->Release()
pF->Release()
```

A value that comes back as the result:

**Example**

```freebasic
dim pF as IDWriteFactory ptr, pFmt as IDWriteTextFormat ptr, unused as DWRITE_FONT_WEIGHT
DWriteCreateFactory( DWRITE_FACTORY_TYPE_SHARED, IID_IDWriteFactory, pF )
pF->CreateTextFormat( "Segoe UI", NULL, DWRITE_FONT_WEIGHT_BOLD, DWRITE_FONT_STYLE_NORMAL, DWRITE_FONT_STRETCH_NORMAL, 20, "en-us", pFmt )
print "weight:"; pFmt->GetFontWeight( unused )      ' weight: 700
pFmt->Release() : pF->Release()
```

A `BOOL` answer through a `boolean` parameter:

**Example**

```freebasic
dim pF as IDWriteFactory ptr, pFonts as IDWriteFontCollection ptr
DWriteCreateFactory( DWRITE_FACTORY_TYPE_SHARED, IID_IDWriteFactory, pF )
pF->GetSystemFontCollection( pFonts )
dim idx as UINT32, found as BOOL
pFonts->FindFamilyName( "Arial", @idx, *cast( boolean ptr, @found ) )
pFonts->Release() : pF->Release()
```

Microsoft Learn: [DirectWrite](https://learn.microsoft.com/en-us/windows/win32/directwrite/direct-write-portal),
[DWriteCreateFactory](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nf-dwrite-dwritecreatefactory)

## See also

- [sys/win/direct2d](SysWin-Direct2D)
- [CID2D1RenderTarget](CID2D1RenderTarget) for `DrawText` and `DrawTextLayout`
- [Direct2D interfaces](SysWin-Direct2D-Interfaces), [DXGI interfaces and types](SysWin-DXGI-Interfaces), [WIC interfaces and types](SysWin-WIC-Interfaces)
- [Direct2D helpers](SysWin-Direct2D-Helpers) for `D2D1_SafeRelease`
- [Fonts](SysWin-Fonts) for GDI fonts
