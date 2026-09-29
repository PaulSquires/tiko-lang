# fbx

José Roca's **fbx** library -- Windows GUI, COM, ADO, GDI+, Direct2D, WebView2 and more -- as a
tiko package of modules. It was the toolchain's `inc/fbx` header library; the headers are gone
from the toolchain and this package is the only copy (ADR 0017 §20).

```freebasic
#import "fbx/gui"
#import "fbx/core"

dim as gui.CWindow pWindow
pWindow.Create( 0, "fbx through #import", @WndProc )
```

fbx is © José Roca, under the MIT license; each file keeps his notice.

## The modules

| Module | What | From |
|---|---|---|
| `fbx/core` | strings, variants, safe arrays, decimals and money, math, colours, JSON, and the COM base interfaces every other module builds on | `BSTRING`, `DWSTRING`, `DVARIANT`, `DSafeArray`, `CDEC`, `CDEC2`, `CInt96`, `CMoney`, `CStack`, `fbxStrProcs`, `fbxVarProcs`, `fbxMath`, `fbxColors`, `fbxJson` |
| `fbx/datetime` | dates and times | `fbxTime`, `CFileTime`, `CTime64`, `COleDateTime`, `CPowerTime` |
| `fbx/com` | COM helpers, late binding, streams | `fbxCOM`, `CDispInvoke`, `CStream` |
| `fbx/adodb` | ADO | `CADODB`, `CAdo*`, `fbxADO` |
| `fbx/odbc` | ODBC | `COdbc`, `COdbcDbc`, `COdbcStmt` |
| `fbx/gui` | windows, dialogs, and a wrapper per common control | `CWindow`, `CDialog`, `CTabPage`, `CXpButton`, `CMaskedEdit`, `CMemBmp`, `fbxWin`, `fbxWinCtrl`, `fbxButton` ... `fbxUpDown` |
| `fbx/dialogs` | open/save, file-dialog customisation, explorer browser, printing | `CIOpenSaveFile`, `CIFileDialog*`, `fbxOpenSaveFile`, `CExplorerBrowser`, `CPrint`, `fbxPrinter` |
| `fbx/richedit` | the Rich Edit control and its Text Object Model | `CRichEditCtx`, `CRichEditOleCallback`, `fbxRichEdit`, `fbxTOM`, `CText*` |
| `fbx/axhost` | ActiveX hosting, the WebBrowser control, MSHFlexGrid | `CAxHost*`, `CDocHostUIHandler`, `CWebCtx`, `CWebBrowserEvents`, `CHtmlDocumentEvents`, `fbxExDisp`, `MSHFlexGrid*` |
| `fbx/webview2` | WebView2 | `CWebView2`, `fbxWebView2`, `fbxWebView2Events` |
| `fbx/gdiplus` | GDI+ | `CGdiPlus`, `CGp*`, `fbxGdiPlus`, `fbxGdipObj` |
| `fbx/direct2d` | Direct2D, DirectWrite, DXGI, WIC | `fbxD2D1*`, `fbxDWrite`, `fbxDxgi`, `fbxWinCodec` |
| `fbx/scripting` | Scripting runtime, regular expressions, WSH, WMI | `CDicObj`, `CFileSys`, `CTextStream`, `fbxScrRun`, `CRegExp`, `fbxRegExp`, `fbxWsh`, `CWmiDisp`, `fbxWmiDisp`, `fbxWmiProcs` |
| `fbx/net` | WinHTTP, XmlLite, CDO mail | `CWinHttpRequest*`, `fbxWinHttpRequest`, `CXmlLite`, `fbxXmlLite`, `CDOMessage`, `fbxCDOSys` |
| `fbx/media` | CD and DirectSound audio, speech | `CCDAudio`, `CDSAudio`, `fbxSapi`, `fbxSpError` |
| `fbx/filesys` | files, paths, INI files, memory-mapped files, device I/O | `CFindFile`, `CIniFile`, `CMemMapFile`, `fbxFile`, `fbxPath`, `fbxIOCtl` |
| `fbx/opengl` | an OpenGL graphic control, GLUT helpers | `CGraphCtx`, `fbxGlut` |

Each header became a `.tiko` file of its module; where a header had a `.bi` and an `.inc` of
one name, the `.bi` is `<name>Defs.tiko`. Left out: `CAxHost_IDispatch - copia.inc` and
`DVARIANT_v01`..`_v03`, older copies of files that are here.

The modules import each other as the code needs, never in a circle:

    core <- datetime, com, gdiplus, direct2d, odbc
    com  <- adodb, scripting, media        gdiplus <- gui
    gui  <- dialogs, richedit, webview2, filesys (+ scripting), opengl (+ gdiplus)
    adodb <- axhost (+ gui), net

## What changed from the headers

- **Everything the headers declared at the top level is public**: types, procedures,
  constants, variables, enums and their members. fbx wrote its procedures `PRIVATE` -- a header
  library's way not to collide across translation units -- and a module's `private` means
  "not exported", so they are `PUBLIC` here.
- **Names are reached through the import**: `gui.CWindow`, or bare after `using gui`.
- **Macros** each module file defines are `#export`ed (`core.FBX_BSTR`). The ones several
  files of a module share live in the module's `<module>.ti` header, with every Windows header
  the module's files include; an importer gets those bare too, as it would from an `#include`.
- **Kept once**: the declarations several headers repeated under `#ifndef` guards -- the
  `fbx_IUnknown` / `fbx_IDispatch` base interfaces and `FBX_BSTR` (now `core`'s),
  `IDataSource` (`adodb`'s), the DDT callback macros (`gui`'s).
- **One addition**: `CRichEditCtx.GetRtf`, declared and called by `SaveRtf` and three others
  but commented out in the header. fbc emitted none of those unused `PRIVATE` methods; a
  module emits every method, so the package supplies it, marked `[pkg/fbx]`.

## Known gaps

- `fbx/datetime`'s `COleDateTime` needed a tiko fix (`this = <value>` in a constructor); a
  compiler older than this package will not build the module.
- A handful of fbx procedures do not lower in tiko, as they did not from the headers either
  (`JsonWriter` in `core` is the largest) -- the module compiles and links, and those
  statements are skipped. `TKO_TRACE_SKIP=1` lists them.
- The editor's parser and tiko-lsp list a module's public symbols but not its macros.
