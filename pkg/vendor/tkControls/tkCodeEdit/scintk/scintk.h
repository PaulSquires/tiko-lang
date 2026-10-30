/* Copyright (C) 2026 Paul Squires, PlanetSquires Software
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

/* ===========================================================================
 * scintk.h -- the C ABI of scintk, Scintilla 5.5.7 + Lexilla on tkControls.
 * Mirrored, field for field, by tkCodeEdit/tkCodeEdit.tiko.
 *
 * A port of PsPlatform's src/scintilla (PsScintillaC.h, PsTextEngineC.h): the
 * editor host, the notification POD, the list box and menu models, the
 * clipboard and ticker hooks are PsPlatform's, renamed SciPs_ -> SciTk_.
 * What changed is the SURFACE. PsPlatform drew with Blend2D into a CPU buffer;
 * scintk draws through two tables the HOST registers -- text (TkTeApi, which
 * is PsTeApi) and shapes (TkDrawApi, new) -- so this library includes no SDL,
 * no FreeType and no Blend2D. tkCodeEdit implements both tables over the
 * window's SDL_Renderer, drawing into the widget's own render-target texture.
 *
 * WHY TABLES AND NOT IMPORTS (PsTextEngineC.h's reason, unchanged): a Windows
 * DLL must resolve every import when it is linked, so it cannot call back into
 * its host executable by name. The host registers procedure pointers instead.
 *
 * APPEND ONLY. A field inserted anywhere but the end of a table shifts every
 * later entry, and the result is not a compile error on either side -- it is a
 * call through the wrong pointer. tests/tkCodeEdit checks the order.
 *
 * Everything crossing this line is cdecl, UTF-8 with an explicit length, and
 * in the editor's own pixels (0,0 = its top left).
 * ===========================================================================
 */

#ifndef SCINTK_H
#define SCINTK_H

#include <stdint.h>

#if defined(_WIN32) && defined(SCITK_STATIC)
#  define SCITK_API              /* linked into the program: nothing to export from it */
#elif defined(_WIN32)
#  define SCITK_API __declspec(dllexport)
#else
#  define SCITK_API __attribute__((visibility("default")))
#endif

#ifdef __cplusplus
extern "C" {
#endif

/* ---- Text: PsTeApi, renamed ------------------------------------------------
 * A handle is ONE FONT AT ONE PIXEL SIZE, which is what Scintilla's Font is.
 * Positions are 26.6 fixed point (sixty-fourths of a pixel). `target` is the
 * drawing target handed to every TkDrawApi call (see below). */
typedef void *TkTeHandle;

typedef struct TkTeApi {
	TkTeHandle (*Create)(const char *fontPath, int pxSize);
	void       (*Destroy)(TkTeHandle h);
	int (*Ascent)(TkTeHandle h);             /* whole pixels */
	int (*Descent)(TkTeHandle h);            /* whole pixels, POSITIVE */
	int (*LineHeight)(TkTeHandle h);         /* whole pixels */
	int (*AverageCharWidth64)(TkTeHandle h); /* 26.6 */
	int (*MeasureText64)(TkTeHandle h, const char *utf8, int nBytes);
	/* The cumulative x after each BYTE, 26.6, nBytes entries: Scintilla's
	 * MeasureWidths contract. Every byte of one cluster gets the cluster's end. */
	void (*MeasureWidths64)(TkTeHandle h, const char *utf8, int nBytes, int *out64);
	int  (*XToIndex)(TkTeHandle h, const char *utf8, int nBytes, int x64);
	/* x, y whole pixels, y the BASELINE; argb 0xAARRGGBB. */
	void (*DrawText)(TkTeHandle h, void *target, int x, int y,
	                 const char *utf8, int nBytes, unsigned int argb);
	int  (*AddFallback)(TkTeHandle h, const char *fontPath, const char *faceName);
	TkTeHandle (*CreateFace)(const char *fontPath, const char *faceName, int pxSize);
} TkTeApi;

/* ---- Shapes: new -------------------------------------------------------------
 * `target` is either the view target the host passed to SciTk_Paint or a
 * pixmap PixmapCreate returned. Colours are 0xAARRGGBB, straight alpha. An
 * argb with alpha 0 draws nothing. Coordinates are float pixels. */
typedef struct TkDrawApi {
	void *(*PixmapCreate)(int w, int h);           /* cleared to transparent */
	void  (*PixmapDestroy)(void *pixmap);
	void  (*FillRect)(void *target, float x, float y, float w, float h, unsigned int argb);
	/* The frame sits INSIDE the rect: Scintilla's rectangles are outer bounds. */
	void  (*FrameRect)(void *target, float x, float y, float w, float h,
	                   float width, unsigned int argb);
	void  (*RoundRect)(void *target, float x, float y, float w, float h, float radius,
	                   unsigned int fill, unsigned int stroke, float width);
	void  (*Line)(void *target, float x1, float y1, float x2, float y2,
	              float width, unsigned int argb);
	void  (*PolyLine)(void *target, const float *xy, int nPoints, float width, unsigned int argb);
	void  (*Polygon)(void *target, const float *xy, int nPoints,
	                 unsigned int fill, unsigned int stroke, float width);
	void  (*Ellipse)(void *target, float x, float y, float w, float h,
	                 unsigned int fill, unsigned int stroke, float width);
	/* nStops positions in [0,1], ascending; horizontal != 0 = left to right. */
	void  (*Gradient)(void *target, float x, float y, float w, float h,
	                  const float *positions, const unsigned int *argb, int nStops, int horizontal);
	/* Straight RGBA bytes, width*height*4, scaled into the rect. */
	void  (*Image)(void *target, float x, float y, float w, float h,
	               int width, int height, const unsigned char *rgba);
	/* The source pixmap's (sx, sy, w, h) at (dx, dy). */
	void  (*CopyPixmap)(void *target, float dx, float dy, float w, float h,
	                    void *source, float sx, float sy);
	/* The rect filled with the source pixmap repeated from the rect's origin. */
	void  (*TilePixmap)(void *target, float x, float y, float w, float h, void *source);
	void  (*PushClip)(void *target, float x, float y, float w, float h);
	void  (*PopClip)(void *target);
} TkDrawApi;

/* Both before the first SciTk_Create. NULL text disables text; NULL shapes
 * disables drawing. The tables must outlive every editor. */
SCITK_API void SciTk_SetTextApi(const TkTeApi *api);
SCITK_API void SciTk_SetDrawApi(const TkDrawApi *api);
/* The display's vertical DPI: a style's point size becomes points*dpi/72 px. */
SCITK_API void SciTk_SetDpi(int dpi);
/* The font file used when a style's face cannot be resolved. */
SCITK_API void SciTk_SetFontPath(const char *path);
/* face/bold/italic -> font file; writes into out, returns bytes written, 0 = unknown. */
typedef int (*SciTkFontResolver)(const char *family, int bold, int italic, char *out, int cbOut);
SCITK_API void SciTk_SetFontResolver(SciTkFontResolver r);
/* Newline-separated "path" or "path|faceName", applied to every font made after. */
SCITK_API void SciTk_SetFallbackChain(const char *chain);

/* ---- The editor ------------------------------------------------------------- */
typedef struct SciTkNotification {
	int                 code;                  /* SCN_* */
	long long           position;
	int                 ch;
	int                 modifiers;
	int                 modificationType;
	const char         *text;                  /* borrowed: valid during the call only */
	long long           length;
	long long           linesAdded;
	int                 message;
	long long           wParam;
	long long           lParam;
	long long           line;
	int                 foldLevelNow;
	int                 foldLevelPrev;
	int                 margin;
	int                 listType;
	int                 x;
	int                 y;
	int                 token;
	long long           annotationLinesAdded;
	int                 updated;
	int                 listCompletionMethod;
} SciTkNotification;

typedef void (*SciTkNotifyFn)(void *user, const SciTkNotification *n);
/* The getter's string must stay valid until the call returns. */
typedef const char *(*SciTkClipGetFn)(void *user);
typedef void (*SciTkClipSetFn)(void *user, const char *utf8);
/* reason: 0 caret, 1 scroll, 2 widen, 3 dwell, 4 platform. running=1 arms a
 * repeating timer of millis that calls SciTk_Tick(reason); running=0 kills it.
 * Called from inside an edit: arm or kill and return, never re-enter. */
typedef void (*SciTkTickerFn)(void *user, int reason, int millis, int running);
/* Scintilla wants pixels; w = h = 0 means all of it. */
typedef void (*SciTkInvalidateFn)(void *user, void *editor, int x, int y, int w, int h);

SCITK_API void    *SciTk_Create(int w, int h);
SCITK_API void     SciTk_Destroy(void *p);
/* The direct function: the same shape as Scintilla_DirectFunction. */
SCITK_API intptr_t SciTk_Send(void *p, unsigned int msg, uintptr_t wParam, intptr_t lParam);
/* Paint the whole view into `target` (the host's view target), w x h pixels. */
SCITK_API int      SciTk_Paint(void *p, void *target, int w, int h);
SCITK_API void     SciTk_SetSize(void *p, int w, int h);
SCITK_API int      SciTk_NotifyCount(void *p);
SCITK_API const char *SciTk_ClipboardText(void *p);
/* Scintilla's Window::Cursor for this view: 0 invalid, 1 text, 2 arrow, 3 up,
 * 4 wait, 5 horizontal, 6 vertical, 7 reverseArrow, 8 hand. */
SCITK_API int      SciTk_Cursor(void *p);

/* key: a Scintilla Keys value (300 = Down ...) or, below 256, a character
 * code, letters UPPERCASE. mods: Scintilla's KeyMod. Returns 1 if consumed. */
SCITK_API int  SciTk_KeyDown(void *p, int key, int mods);
SCITK_API void SciTk_TextInput(void *p, const char *utf8, int nBytes);
SCITK_API void SciTk_MouseDown(void *p, int x, int y, unsigned int timeMs, int mods, int bRight);
SCITK_API void SciTk_MouseMove(void *p, int x, int y, unsigned int timeMs, int mods);
SCITK_API void SciTk_MouseUp(void *p, int x, int y, unsigned int timeMs, int mods);
SCITK_API void SciTk_SetFocus(void *p, int bFocused);

SCITK_API void SciTk_SetInvalidateCallback(void *p, SciTkInvalidateFn fn, void *user);
SCITK_API void SciTk_SetNotifyCallback(void *p, SciTkNotifyFn fn, void *user);
SCITK_API void SciTk_SetClipboardHooks(void *p, SciTkClipGetFn getFn, SciTkClipSetFn setFn, void *user);
SCITK_API void SciTk_SetTickerCallback(void *p, SciTkTickerFn fn, void *user);
SCITK_API void SciTk_Tick(void *p, int reason);
SCITK_API int  SciTk_TickerRunning(void *p, int reason);
SCITK_API int  SciTk_TickerInterval(void *p, int reason);

/* ---- The autocompletion list and the context menu (PsScintillaC.h) ---------- */
typedef struct SciTkListBoxHost {
	void (*Show)(void *user, void *lb, int x, int y, int w, int h);
	void (*Hide)(void *user, void *lb);
	void (*ItemsChanged)(void *user, void *lb);
	void (*SelectionChanged)(void *user, void *lb, int n);
} SciTkListBoxHost;
SCITK_API void        SciTk_SetListBoxHost(const SciTkListBoxHost *host, void *user);
SCITK_API int         SciTk_LbCount(void *lb);
SCITK_API const char *SciTk_LbText(void *lb, int n);
SCITK_API int         SciTk_LbType(void *lb, int n);
SCITK_API int         SciTk_LbSelection(void *lb);
SCITK_API int         SciTk_LbRowHeight(void *lb);
SCITK_API int         SciTk_LbVisibleRows(void *lb);
SCITK_API void        SciTk_LbSetSelection(void *lb, int n);
SCITK_API void        SciTk_LbActivate(void *lb, int n);

typedef struct SciTkMenuHost {
	void (*Begin)(void *user);
	void (*AddItem)(void *user, const char *label, int cmd, int bEnabled);
	void (*Show)(void *user, int x, int y);
} SciTkMenuHost;
SCITK_API void SciTk_SetMenuHost(const SciTkMenuHost *host, void *user);
SCITK_API void SciTk_MenuCommand(void *p, int cmd);
SCITK_API void SciTk_ContextMenu(void *p, int x, int y);

/* ---- Call tips (new in ABI 2) ------------------------------------------------
 * Scintilla decides when a tip shows and where (editor pixels); the host owns
 * the popup surface, paints it with SciTk_PaintCallTip and reports clicks.
 * Per editor: `editor` is the SciTk_Create handle. */
typedef struct SciTkCallTipHost {
	void (*Show)(void *user, void *editor, int x, int y, int w, int h);
	void (*Hide)(void *user, void *editor);
	void (*Invalidate)(void *user, void *editor);
} SciTkCallTipHost;
SCITK_API void SciTk_SetCallTipHost(void *p, const SciTkCallTipHost *host, void *user);
/* Paint the tip into `target` (a host target, w x h pixels, from (0,0)). */
SCITK_API int  SciTk_PaintCallTip(void *p, void *target, int w, int h);
/* A click at (x, y) in the tip's own pixels: SCN_CALLTIPCLICK follows. */
SCITK_API void SciTk_CallTipClick(void *p, int x, int y);

/* ---- Input methods (new in ABI 2) --------------------------------------------
 * The pre-edit (composition) string, inserted TENTATIVELY with the IME
 * indicator, replacing the previous one; cursorChars is the IME cursor in
 * characters from the start of the string (-1 = at its end). An empty string
 * ends the composition. The committed text arrives through SciTk_TextInput,
 * which removes the tentative text first. ScintillaGTK's inline IME, ported. */
SCITK_API void SciTk_ImeCompose(void *p, const char *utf8, int nBytes, int cursorChars);
/* Where the input method's candidate window goes: the main caret's point and
 * the line height, editor pixels. */
SCITK_API void SciTk_CaretRect(void *p, int *x, int *y, int *lineHeight);

/* ---- Per-editor DPI (new in ABI 2) -------------------------------------------
 * A style's point size becomes points*dpi/72 px. Each editor keeps its own and
 * restyles when it changes (a window moved to a monitor of another scale);
 * SciTk_SetDpi stays the default for editors that never set one. */
SCITK_API void SciTk_SetEditorDpi(void *p, int dpi);

/* ---- Lexilla ---------------------------------------------------------------
 * An ILexer5* for SCI_SETILEXER, or NULL. The only lexer built in is "tiko". */
SCITK_API void *SciTk_CreateLexer(const char *name);

/* The ABI's version: bumped whenever a table or a signature above changes. */
SCITK_API int SciTk_AbiVersion(void);
/* sizeof(SciTkNotification), for the host to check its mirror's layout. */
SCITK_API int SciTk_NotificationSize(void);
#define SCITK_ABI_VERSION 2

#ifdef __cplusplus
}
#endif

#endif /* SCINTK_H */
