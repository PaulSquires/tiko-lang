// Copyright (C) 2026 Paul Squires, PlanetSquires Software
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// ===========================================================================
// PlatTk.cxx -- Scintilla's platform layer (Platform.h) for tkControls.
//
// A port of PsPlatform's src/scintilla/PlatPs.cxx. Font, Window, ListBox, Menu
// and Platform are PlatPs's, renamed; the Surface is new. PlatPs drew with
// Blend2D into a CPU buffer. SurfaceTk forwards every primitive to the host's
// TkDrawApi and every text run to its TkTeApi (scintk.h), so this file has no
// graphics dependency at all -- tkCodeEdit draws with SDL_Renderer.
// ===========================================================================

#include <cstddef>
#include <cstdlib>
#include <cstring>
#include <cstdio>
#include <cstdarg>
#include <cmath>
#include <string>
#include <string_view>
#include <vector>
#include <map>
#include <memory>
#include <optional>
#include <set>
#include <algorithm>

// <cstdint> BEFORE the Scintilla headers, and it is not tidiness.
//
// ScintillaTypes.h uses intptr_t/uintptr_t without including <cstdint>, and
// Geometry.h does the same. That compiles wherever some earlier header happens
// to drag <cstdint> in transitively -- which is every MinGW build this project
// has ever done, and is NOT true of libstdc++ on Fedora 42 / GCC 15, where the
// transitive includes were pruned.
//
// FOUND ON THE FIRST LINUX BUILD, 7c step 16:
//     ScintillaTypes.h:701:18: error: 'intptr_t' does not name a type
//        using Position = intptr_t;
//
// Fixed HERE rather than in the vendored header: patching vendor code is a
// merge conflict every time Scintilla is updated, and the include is correct
// in this file regardless. ScintillaPs.cxx already had it, which is exactly
// why that file compiled and this one did not.
#include <cstdint>

#include "ScintillaTypes.h"
#include "ScintillaMessages.h"
#include "Debugging.h"
#include "Geometry.h"
#include "Platform.h"

/* THE TEXT ENGINE AND THE SHAPES ARE THE HOST'S, through the two tables in
 * scintk.h. They are registered once, before the first editor. */
#include "scintk.h"

using namespace Scintilla;
using namespace Scintilla::Internal;

// The font this renders with. Committed to the repository precisely so that
// this, like the golden images, is identical on every host.
// The DEFAULT font file, used when no resolver is installed or when the
// resolver cannot answer. Every probe and every host written before the
// resolver existed still works through this, which is why it stays.
static std::string g_fontPath;
extern "C" void PlatTk_SetFontPath(const char *p) { g_fontPath = p ? p : ""; }

static const TkTeApi   *g_te = nullptr;
static const TkDrawApi *g_draw = nullptr;
extern "C" SCITK_API void SciTk_SetTextApi(const TkTeApi *api) { g_te = api; }
extern "C" SCITK_API void SciTk_SetDrawApi(const TkDrawApi *api) { g_draw = api; }

// ---------------------------------------------------------------- font seam
// THE HOST ANSWERS "WHICH FILE IS Consolas BOLD ITALIC?", because only the host
// can. Scintilla names a font the way a human does -- face name, weight, italic
// -- and FreeType opens a file; the mapping lives in the registry on Windows
// and in fontconfig elsewhere, neither of which belongs in a platform layer
// that is also compiled into a headless test.
//
// IT WRITES INTO THE CALLER'S BUFFER rather than returning a pointer. A
// returned const char* would need the host to keep the string alive for a
// lifetime nothing here can state, and the FreeBASIC side of this seam has no
// natural place to keep one. Returns the number of bytes written, 0 for "I
// cannot answer that".
static SciTkFontResolver g_fontResolver = nullptr;
extern "C" SCITK_API void SciTk_SetFontResolver(SciTkFontResolver r) { g_fontResolver = r; }

// The fallback chain, newline-separated, each line "path" or "path|faceName".
// Applied to every Font as it is created. Set it BEFORE the styles are sent:
// a Font already built keeps the chain it was built with until the next
// restyle rebuilds it, which ViewStyle::Refresh does on any SCI_STYLESET*.
static std::string g_fallbackChain;
extern "C" SCITK_API void SciTk_SetFallbackChain(const char *p) { g_fallbackChain = p ? p : ""; }

// The display's vertical DPI. Scintilla turns a style's POINT size into pixels
// with DeviceHeightFont(points) = points * LogPixelsY() / 72, so this number
// alone decides how big the text comes out.
//
// IT WAS HARDCODED TO 96, and a DPI-aware host on a 150% display therefore
// rendered its editor at two thirds size while every other control scaled --
// reported against tiko as "the text is VERY small". Left at 96 this is exactly
// the old behaviour, so a host that never calls it is unaffected.
//
// Process-global, like g_fontPath, and for the same reason: Scintilla asks for
// it through a Surface that carries no host identity. Two editors on displays
// of different scale would need it per-instance; that is a real limit, and it
// is not reached while every editor in a window shares one monitor.
static int g_dpiY = 96;
extern "C" SCITK_API void SciTk_SetDpi(int dpi) { if (dpi >= 48 && dpi <= 960) g_dpiY = dpi; }

// ---------------------------------------------------------------- Font
// Scintilla hands us a FontParameters and expects an opaque Font back. Ours
// carries nothing but a handle to the host's text engine (TkTeApi), one face
// at one size -- exactly what a Scintilla Font is.
//
// THE SPIKE'S FontTk AND GlyphAtlas ARE GONE, some 120 lines of FreeType and
// HarfBuzz that duplicated the engine. What they computed -- ascent, descent,
// line height, the cell advance from HarfBuzz rather than FT_Load_Glyph, the
// shelf-packed A8 atlas -- the engine already computed, and having it twice
// meant two answers to questions like "where does the caret go inside a
// ligature" that must have one.
namespace {

// The file for one style of one family, from the host if it will answer.
//
// FALLING BACK TO REGULAR IS DELIBERATE. A family with no bold cut on disk
// renders regular rather than a synthesised embolden: emboldening an outline
// when a real bold exists elsewhere looks wrong, and every editor font in
// common use ships all four.
std::string ResolveFontFile(const char *faceName, bool bold, bool italic) {
	if (!g_fontResolver || !faceName || !*faceName) return g_fontPath;

	char buf[1024];
	int n = g_fontResolver(faceName, bold ? 1 : 0, italic ? 1 : 0, buf, sizeof(buf));
	if (n > 0 && n < static_cast<int>(sizeof(buf))) {
		buf[n] = '\0';
		return std::string(buf);
	}
	// The exact style is not on this machine. Ask for the regular cut before
	// giving up on the family entirely -- "Consolas has no italic" must not
	// become "Consolas is not installed".
	if (bold || italic) {
		n = g_fontResolver(faceName, 0, 0, buf, sizeof(buf));
		if (n > 0 && n < static_cast<int>(sizeof(buf))) {
			buf[n] = '\0';
			return std::string(buf);
		}
	}
	return g_fontPath;
}

// Add every chain entry to a freshly created engine. Refusals are expected and
// ignored: an entry naming a font this machine lacks must not stop the rest.
void ApplyFallbackChain(const TkTeApi *api, TkTeHandle te) {
	if (!api || !api->AddFallback || !te || g_fallbackChain.empty()) return;

	size_t i = 0;
	while (i < g_fallbackChain.size()) {
		size_t eol = g_fallbackChain.find('\n', i);
		if (eol == std::string::npos) eol = g_fallbackChain.size();
		std::string line = g_fallbackChain.substr(i, eol - i);
		i = eol + 1;
		if (line.empty()) continue;

		std::string path = line;
		std::string face;
		const size_t bar = line.find('|');
		if (bar != std::string::npos) {
			path = line.substr(0, bar);
			face = line.substr(bar + 1);
		}
		if (!path.empty()) api->AddFallback(te, path.c_str(), face.c_str());
	}
}

class FontTk : public Font {
public:
	TkTeHandle te = nullptr;
	int pxSize = 0;

	explicit FontTk(const FontParameters &fp) {
		pxSize = static_cast<int>(fp.size + 0.5);
		if (pxSize <= 0) pxSize = 10;

		// THE FACE NAME AND THE WEIGHT ARE READ NOW, and were dropped before.
		// fp carries everything Scintilla was told by SCI_STYLESETFONT,
		// SCI_STYLESETBOLD and SCI_STYLESETITALIC; this used fp.size alone, so
		// every style in every theme rendered in one file at one weight.
		//
		// SemiBold rather than Bold is the threshold because that is where
		// Scintilla's own ViewStyle puts it: FontWeight::Bold is 700 and a
		// style asking for 600 wants a heavier face, not a normal one.
		const bool bold = fp.weight >= Scintilla::FontWeight::SemiBold;
		const std::string entry = ResolveFontFile(fp.faceName, bold, fp.italic);

		// "path" or "path|faceName". THE PRIMARY CAN BE A COLLECTION: a user is
		// entitled to pick MS UI Gothic as their editor font, and index 0 of
		// msgothic.ttc is MS Gothic -- a different typeface, reported as a
		// success.
		std::string path = entry;
		std::string face;
		const size_t bar = entry.find('|');
		if (bar != std::string::npos) {
			path = entry.substr(0, bar);
			face = entry.substr(bar + 1);
		}

		const TkTeApi *api = g_te;
		if (api) {
			if (!face.empty() && api->CreateFace) {
				te = api->CreateFace(path.c_str(), face.c_str(), pxSize);
			} else {
				te = api->Create(path.c_str(), pxSize);
			}
			// A resolved path that will not open takes the editor down with it
			// -- Create failing is a Font with no engine, and every draw
			// through it is silently nothing. Retry the default before giving
			// up, so a stale registry entry degrades instead of blanking.
			if (!te && path != g_fontPath && !g_fontPath.empty()) {
				te = api->Create(g_fontPath.c_str(), pxSize);
			}
			ApplyFallbackChain(api, te);
		}
	}
	~FontTk() noexcept override {
		const TkTeApi *api = g_te;
		if (te && api) api->Destroy(te);
	}
	bool Ok() const noexcept { return te != nullptr; }
};

const FontTk *AsFontTk(const Font *f) { return static_cast<const FontTk *>(f); }

// Measure without a Surface. ListBoxTk sizes itself from real text widths and
// has no Surface to ask -- SurfaceImpl::WidthText is the same two lines, and
// this is deliberately not a third implementation of them.
XYPOSITION PlatTk_MeasureWidth(const Font *font_, const std::string &text) {
	const FontTk *f = AsFontTk(font_);
	if (!f || !f->Ok() || text.empty()) return 0;
	const TkTeApi *api = g_te;
	if (!api) return 0;
	return static_cast<XYPOSITION>(
		api->MeasureText64(f->te, text.data(), static_cast<int>(text.size())) / 64.0);
}

// ---------------------------------------------------------------- helpers
inline unsigned int Argb(ColourRGBA c) {
	return (static_cast<unsigned int>(c.GetAlpha()) << 24) |
	       (static_cast<unsigned int>(c.GetRed())   << 16) |
	       (static_cast<unsigned int>(c.GetGreen()) <<  8) |
	        static_cast<unsigned int>(c.GetBlue());
}
inline float F(XYPOSITION v) { return static_cast<float>(v); }

// ---------------------------------------------------------------- Surface
// THE HOST DRAWS. Where SurfacePs held a Blend2D context, SurfaceTk holds the
// host's target handle and forwards every primitive through TkDrawApi -- one
// call per primitive, in the editor's own pixels. tkCodeEdit implements the
// table over SDL_Renderer, drawing into the widget's render-target texture.
//
// A Surface with no target is legitimate: Scintilla measures text with one.
// Every draw below tolerates it, as SurfacePs tolerated a null context.
class SurfaceTk : public Surface {
	void      *target = nullptr;
	bool       ownsPixmap = false;
	SurfaceMode mode;
	int        clipDepth = 0;

	bool Can() const { return target != nullptr && g_draw != nullptr; }
public:
	SurfaceTk() = default;
	explicit SurfaceTk(void *t) : target(t) {}
	~SurfaceTk() noexcept override { Release(); }

	void *Target() const { return target; }

	void Init(WindowID) override {}
	void Init(SurfaceID sid, WindowID) override { target = sid; ownsPixmap = false; }
	std::unique_ptr<Surface> AllocatePixMap(int width, int height) override {
		auto s = std::make_unique<SurfaceTk>();
		if (g_draw && g_draw->PixmapCreate && width > 0 && height > 0) {
			s->target = g_draw->PixmapCreate(width, height);
			s->ownsPixmap = (s->target != nullptr);
		}
		return s;
	}
	void SetMode(SurfaceMode mode_) override { mode = mode_; }
	void Release() noexcept override {
		if (Can()) {
			while (clipDepth > 0) { g_draw->PopClip(target); clipDepth--; }
		}
		clipDepth = 0;
		if (ownsPixmap && target && g_draw && g_draw->PixmapDestroy) g_draw->PixmapDestroy(target);
		ownsPixmap = false;
		target = nullptr;
	}
	int SupportsFeature(Supports feature) noexcept override {
		switch (feature) {
		case Supports::LineDrawsFinal:        return 1;
		case Supports::FractionalStrokeWidth: return 1;
		case Supports::TranslucentStroke:     return 1;
		case Supports::PixelModification:     return 1;
		default:                              return 0;
		}
	}
	bool Initialised() override { return true; }
	int LogPixelsY() override { return g_dpiY; }
	int PixelDivisions() override { return 1; }
	int DeviceHeightFont(int points) override { return points * LogPixelsY() / 72; }

	void LineDraw(Point start, Point end, Stroke stroke) override {
		if (!Can()) return;
		g_draw->Line(target, F(start.x), F(start.y), F(end.x), F(end.y), F(stroke.width), Argb(stroke.colour));
	}
	void PolyLine(const Point *pts, size_t npts, Stroke stroke) override {
		if (!Can() || npts < 2) return;
		std::vector<float> xy(npts * 2);
		for (size_t i = 0; i < npts; i++) { xy[i * 2] = F(pts[i].x); xy[i * 2 + 1] = F(pts[i].y); }
		g_draw->PolyLine(target, xy.data(), static_cast<int>(npts), F(stroke.width), Argb(stroke.colour));
	}
	void Polygon(const Point *pts, size_t npts, FillStroke fillStroke) override {
		if (!Can() || npts < 3) return;
		std::vector<float> xy(npts * 2);
		for (size_t i = 0; i < npts; i++) { xy[i * 2] = F(pts[i].x); xy[i * 2 + 1] = F(pts[i].y); }
		g_draw->Polygon(target, xy.data(), static_cast<int>(npts), Argb(fillStroke.fill.colour),
		                Argb(fillStroke.stroke.colour), F(fillStroke.stroke.width));
	}
	void RectangleDraw(PRectangle rc, FillStroke fillStroke) override {
		if (!Can()) return;
		g_draw->FillRect(target, F(rc.left), F(rc.top), F(rc.Width()), F(rc.Height()), Argb(fillStroke.fill.colour));
		g_draw->FrameRect(target, F(rc.left), F(rc.top), F(rc.Width()), F(rc.Height()),
		                  F(fillStroke.stroke.width), Argb(fillStroke.stroke.colour));
	}
	void RectangleFrame(PRectangle rc, Stroke stroke) override {
		if (!Can()) return;
		g_draw->FrameRect(target, F(rc.left), F(rc.top), F(rc.Width()), F(rc.Height()),
		                  F(stroke.width), Argb(stroke.colour));
	}
	void FillRectangle(PRectangle rc, Fill fill) override {
		if (!Can()) return;
		g_draw->FillRect(target, F(rc.left), F(rc.top), F(rc.Width()), F(rc.Height()), Argb(fill.colour));
	}
	void FillRectangleAligned(PRectangle rc, Fill fill) override {
		FillRectangle(PixelAlign(rc, 1), fill);
	}
	void FillRectangle(PRectangle rc, Surface &surfacePattern) override {
		// The fold margin's hatching: a pixmap repeated across the rect.
		if (!Can()) return;
		SurfaceTk &sp = static_cast<SurfaceTk &>(surfacePattern);
		if (sp.Target())
			g_draw->TilePixmap(target, F(rc.left), F(rc.top), F(rc.Width()), F(rc.Height()), sp.Target());
		else
			g_draw->FillRect(target, F(rc.left), F(rc.top), F(rc.Width()), F(rc.Height()), 0xFF808080u);
	}
	void RoundedRectangle(PRectangle rc, FillStroke fillStroke) override {
		if (!Can()) return;
		g_draw->RoundRect(target, F(rc.left), F(rc.top), F(rc.Width()), F(rc.Height()), 3.0f,
		                  Argb(fillStroke.fill.colour), Argb(fillStroke.stroke.colour), F(fillStroke.stroke.width));
	}
	void AlphaRectangle(PRectangle rc, XYPOSITION cornerSize, FillStroke fillStroke) override {
		if (!Can()) return;
		if (cornerSize > 0) {
			g_draw->RoundRect(target, F(rc.left), F(rc.top), F(rc.Width()), F(rc.Height()), F(cornerSize),
			                  Argb(fillStroke.fill.colour), Argb(fillStroke.stroke.colour), F(fillStroke.stroke.width));
		} else {
			RectangleDraw(rc, fillStroke);
		}
	}
	void GradientRectangle(PRectangle rc, const std::vector<ColourStop> &stops,
	                       GradientOptions options) override {
		if (!Can() || stops.empty()) return;
		std::vector<float> pos;
		std::vector<unsigned int> col;
		for (const auto &s : stops) { pos.push_back(F(s.position)); col.push_back(Argb(s.colour)); }
		g_draw->Gradient(target, F(rc.left), F(rc.top), F(rc.Width()), F(rc.Height()), pos.data(), col.data(),
		                 static_cast<int>(stops.size()), options == GradientOptions::leftToRight ? 1 : 0);
	}
	void DrawRGBAImage(PRectangle rc, int width, int height,
	                   const unsigned char *pixelsImage) override {
		if (!Can() || !pixelsImage || width <= 0 || height <= 0) return;
		g_draw->Image(target, F(rc.left), F(rc.top), F(rc.Width()), F(rc.Height()), width, height, pixelsImage);
	}
	void Ellipse(PRectangle rc, FillStroke fillStroke) override {
		if (!Can()) return;
		g_draw->Ellipse(target, F(rc.left), F(rc.top), F(rc.Width()), F(rc.Height()),
		                Argb(fillStroke.fill.colour), Argb(fillStroke.stroke.colour), F(fillStroke.stroke.width));
	}
	void Stadium(PRectangle rc, FillStroke fillStroke, Ends) override {
		// A fully rounded rectangle; which caps are flat does not change the fit.
		if (!Can()) return;
		const XYPOSITION r = std::min(rc.Width(), rc.Height()) / 2.0;
		g_draw->RoundRect(target, F(rc.left), F(rc.top), F(rc.Width()), F(rc.Height()), F(r),
		                  Argb(fillStroke.fill.colour), Argb(fillStroke.stroke.colour), F(fillStroke.stroke.width));
	}
	void Copy(PRectangle rc, Point from, Surface &surfaceSource) override {
		if (!Can()) return;
		SurfaceTk &src = static_cast<SurfaceTk &>(surfaceSource);
		if (!src.Target()) return;
		g_draw->CopyPixmap(target, F(rc.left), F(rc.top), F(rc.Width()), F(rc.Height()),
		                   src.Target(), F(from.x), F(from.y));
	}

	// nullptr: Scintilla's own simple layout (PlatPs's choice, unchanged).
	std::unique_ptr<IScreenLineLayout> Layout(const IScreenLine *) override {
		return nullptr;
	}

	// ------------------------------------------------------------ text
	void DrawGlyphs(PRectangle rc, const FontTk *f, XYPOSITION ybase,
	                std::string_view text, ColourRGBA fore, bool clip) {
		if (!Can() || !f || !f->Ok() || text.empty() || !g_te) return;
		if (clip) g_draw->PushClip(target, F(rc.left), F(rc.top), F(rc.Width()), F(rc.Height()));
		g_te->DrawText(f->te, target, static_cast<int>(rc.left), static_cast<int>(ybase),
		               text.data(), static_cast<int>(text.size()), Argb(fore));
		if (clip) g_draw->PopClip(target);
	}

	void DrawTextNoClip(PRectangle rc, const Font *font_, XYPOSITION ybase,
	                    std::string_view text, ColourRGBA fore, ColourRGBA back) override {
		FillRectangle(rc, back);
		DrawGlyphs(rc, AsFontTk(font_), ybase, text, fore, false);
	}
	void DrawTextClipped(PRectangle rc, const Font *font_, XYPOSITION ybase,
	                     std::string_view text, ColourRGBA fore, ColourRGBA back) override {
		FillRectangle(rc, back);
		DrawGlyphs(rc, AsFontTk(font_), ybase, text, fore, true);
	}
	void DrawTextTransparent(PRectangle rc, const Font *font_, XYPOSITION ybase,
	                         std::string_view text, ColourRGBA fore) override {
		DrawGlyphs(rc, AsFontTk(font_), ybase, text, fore, false);
	}

	// The cumulative x after each BYTE; the host's cluster map is the authority.
	void MeasureWidths(const Font *font_, std::string_view text,
	                   XYPOSITION *positions) override {
		const FontTk *f = AsFontTk(font_);
		if (!f || !f->Ok() || text.empty() || !positions || !g_te) return;
		const size_t n = text.size();
		std::vector<int> x64(n, 0);
		g_te->MeasureWidths64(f->te, text.data(), static_cast<int>(n), x64.data());
		for (size_t i = 0; i < n; i++)
			positions[i] = static_cast<XYPOSITION>(x64[i] / 64.0);
	}
	XYPOSITION WidthText(const Font *font_, std::string_view text) override {
		return PlatTk_MeasureWidth(font_, std::string(text));
	}

	void DrawTextNoClipUTF8(PRectangle rc, const Font *f, XYPOSITION yb,
	                        std::string_view t, ColourRGBA fo, ColourRGBA ba) override {
		DrawTextNoClip(rc, f, yb, t, fo, ba);
	}
	void DrawTextClippedUTF8(PRectangle rc, const Font *f, XYPOSITION yb,
	                         std::string_view t, ColourRGBA fo, ColourRGBA ba) override {
		DrawTextClipped(rc, f, yb, t, fo, ba);
	}
	void DrawTextTransparentUTF8(PRectangle rc, const Font *f, XYPOSITION yb,
	                             std::string_view t, ColourRGBA fo) override {
		DrawTextTransparent(rc, f, yb, t, fo);
	}
	void MeasureWidthsUTF8(const Font *f, std::string_view t, XYPOSITION *p) override {
		MeasureWidths(f, t, p);
	}
	XYPOSITION WidthTextUTF8(const Font *f, std::string_view t) override {
		return WidthText(f, t);
	}

	XYPOSITION Ascent(const Font *font_) override {
		const FontTk *f = AsFontTk(font_);
		return (f && f->Ok() && g_te) ? g_te->Ascent(f->te) : 0;
	}
	XYPOSITION Descent(const Font *font_) override {
		const FontTk *f = AsFontTk(font_);
		return (f && f->Ok() && g_te) ? g_te->Descent(f->te) : 0;
	}
	XYPOSITION InternalLeading(const Font *) override { return 0; }
	XYPOSITION Height(const Font *font_) override {
		const FontTk *f = AsFontTk(font_);
		return (f && f->Ok() && g_te) ? g_te->Ascent(f->te) + g_te->Descent(f->te) : 0;
	}
	XYPOSITION AverageCharWidth(const Font *font_) override {
		const FontTk *f = AsFontTk(font_);
		return (f && f->Ok() && g_te) ? g_te->AverageCharWidth64(f->te) / 64.0 : 0;
	}

	void SetClip(PRectangle rc) override {
		if (!Can()) return;
		g_draw->PushClip(target, F(rc.left), F(rc.top), F(rc.Width()), F(rc.Height()));
		clipDepth++;
	}
	void PopClip() override {
		if (!Can() || clipDepth <= 0) return;
		g_draw->PopClip(target);
		clipDepth--;
	}
	void FlushCachedState() override {}
	void FlushDrawing() override {}
};

} // namespace

// ---------------------------------------------------------------- factories
std::shared_ptr<Font> Font::Allocate(const FontParameters &fp) {
	return std::make_shared<FontTk>(fp);
}
std::unique_ptr<Surface> Surface::Allocate(Technology) {
	return std::make_unique<SurfaceTk>();
}
// The shim points Scintilla at the host's view target with this.
std::unique_ptr<Surface> PlatTk_SurfaceForTarget(void *target) {
	return std::make_unique<SurfaceTk>(target);
}

// ---------------------------------------------------------------- Window
// Concrete in Platform.h, so the platform layer defines the bodies. The spike
// is headless: there is no OS window, and every geometry query answers from the
// single canvas the host set up. That is exactly what the toolkit will do too,
// since a Scintilla view is a PsWidget inside one OS window, not a window.
static PRectangle g_windowRect(0, 0, 800, 600);
void PlatTk_SetWindowRect(int w, int h) { g_windowRect = PRectangle(0, 0, w, h); }

// PER-EDITOR RECTS. g_windowRect above is the fallback and was, for a while,
// the ONLY answer -- which meant every editor in the process shared one size
// and a resized pane laid out against somebody else's. The symptom is not a
// wrong window: it is scrolling and wrapping that do not match what is on
// screen, which reads as a scrolling bug.
static std::map<void *, PRectangle> g_editorRects;
void PlatTk_SetEditorRect(void *wid, int w, int h) {
	if (wid) g_editorRects[wid] = PRectangle(0, 0, w, h);
}
// Who to tell when Scintilla wants pixels. Keyed on the WindowID, because
// Window's methods are not virtual and that id is all they have -- the same
// dispatch the rects above use.
namespace {
struct InvalidateSink { SciTkInvalidateFn fn; void *user; };
std::map<void *, InvalidateSink> g_invalidate;
std::map<void *, int> g_cursors;      // Window::SetCursor, per view
}

void PlatTk_ForgetEditor(void *wid) {
	if (wid) {
		g_editorRects.erase(wid);
		g_invalidate.erase(wid);
		g_cursors.erase(wid);
	}
}

extern "C" SCITK_API void SciTk_SetInvalidateCallback(void *p, SciTkInvalidateFn fn, void *user) {
	if (!p) return;
	if (fn) g_invalidate[p] = InvalidateSink{ fn, user };
	else    g_invalidate.erase(p);
}
namespace {
PRectangle EditorRect(void *wid) {
	if (wid) {
		const auto it = g_editorRects.find(wid);
		if (it != g_editorRects.end()) return it->second;
	}
	return g_windowRect;
}
}

// Window's methods are NOT virtual -- Platform.h declares them once and each
// platform defines them once. So a ListBox cannot override them, and these have
// to dispatch on `wid`, exactly as ScintillaWin does with its HWND.
//
// A ListBox sets its own wid to itself when created; anything else is the
// editor's own view, which is headless and answers from g_windowRect. Getting
// this wrong is not subtle -- the autocompletion list would resize the EDITOR.
namespace {
bool        PlatTk_IsListBox(WindowID wid) noexcept;
PRectangle  PlatTk_LbRect(WindowID wid) noexcept;
void        PlatTk_LbSetRect(WindowID wid, PRectangle rc) noexcept;
void        PlatTk_LbShow(WindowID wid, bool show) noexcept;
}

// ---- CALL TIPS: a third kind of WindowID ------------------------------------
// ScintillaTk::CreateCallTipWindow names the tip's window after its CallTip
// object and registers it here with the editor's host table; Window's methods
// then route show, hide, repaint and geometry to the host, which owns the popup
// surface and paints it with SciTk_PaintCallTip. Same "the control asks, the
// host owns the surface" split as the ListBox.
namespace {
struct CallTipEntry {
	void *editor = nullptr;
	const SciTkCallTipHost *host = nullptr;
	void *user = nullptr;
	PRectangle rc;
};
std::map<void *, CallTipEntry> g_callTips;
bool IsCallTip(WindowID wid) noexcept { return wid && g_callTips.count(wid) != 0; }
}

void PlatTk_CallTipRegister(void *wid, void *editor, const SciTkCallTipHost *host, void *user) {
	if (!wid) return;
	CallTipEntry &e = g_callTips[wid];
	e.editor = editor;
	e.host = host;
	e.user = user;
}
void PlatTk_CallTipForget(void *wid) {
	if (wid) g_callTips.erase(wid);
}

Window::~Window() noexcept = default;
void Window::Destroy() noexcept {
	if (PlatTk_IsListBox(wid)) PlatTk_LbShow(wid, false);
	if (IsCallTip(wid)) {
		const CallTipEntry &e = g_callTips[wid];
		if (e.host && e.host->Hide) e.host->Hide(e.user, e.editor);
	}
	wid = nullptr;
}
PRectangle Window::GetPosition() const {
	if (IsCallTip(wid)) return g_callTips[wid].rc;
	return PlatTk_IsListBox(wid) ? PlatTk_LbRect(wid) : EditorRect(wid);
}
void Window::SetPosition(PRectangle rc) {
	if (PlatTk_IsListBox(wid)) { PlatTk_LbSetRect(wid, rc); return; }
	if (IsCallTip(wid)) { g_callTips[wid].rc = rc; return; }
	g_windowRect = rc;
}
void Window::SetPositionRelative(PRectangle rc, const Window *) { SetPosition(rc); }
// A call tip paints itself from (0,0): CallTip::PaintCT reads its CLIENT rect.
PRectangle Window::GetClientPosition() const {
	if (IsCallTip(wid)) {
		const PRectangle rc = g_callTips[wid].rc;
		return PRectangle(0, 0, rc.Width(), rc.Height());
	}
	return GetPosition();
}
void Window::Show(bool show) {
	if (PlatTk_IsListBox(wid)) PlatTk_LbShow(wid, show);
	if (IsCallTip(wid)) {
		const CallTipEntry &e = g_callTips[wid];
		if (!e.host) return;
		if (show && e.host->Show)
			e.host->Show(e.user, e.editor, static_cast<int>(e.rc.left), static_cast<int>(e.rc.top),
			             static_cast<int>(e.rc.Width()), static_cast<int>(e.rc.Height()));
		else if (!show && e.host->Hide)
			e.host->Hide(e.user, e.editor);
	}
}
// THE REPAINT REQUEST. See the note in PsScintillaC.h -- these were no-ops,
// and the symptom was a completed word that did not appear until some later
// event happened to damage the pane.
void Window::InvalidateAll() {
	if (IsCallTip(wid)) {
		const CallTipEntry &e = g_callTips[wid];
		if (e.host && e.host->Invalidate) e.host->Invalidate(e.user, e.editor);
		return;
	}
	const auto it = g_invalidate.find(wid);
	if (it != g_invalidate.end() && it->second.fn)
		it->second.fn(it->second.user, wid, 0, 0, 0, 0);
}
void Window::InvalidateRectangle(PRectangle rc) {
	const auto it = g_invalidate.find(wid);
	if (it != g_invalidate.end() && it->second.fn)
		it->second.fn(it->second.user, wid,
			static_cast<int>(rc.left), static_cast<int>(rc.top),
			static_cast<int>(rc.Width()), static_cast<int>(rc.Height()));
}
// Recorded per view for SciTk_Cursor (g_cursors): the host owns the pointer and shows it.
void Window::SetCursor(Cursor curs) {
	cursorLast = curs;
	if (wid && !PlatTk_IsListBox(wid)) g_cursors[wid] = static_cast<int>(curs);
}
int PlatTk_CursorOf(void *wid) {
	const auto it = g_cursors.find(wid);
	return it == g_cursors.end() ? 0 : it->second;
}
// UNBOUNDED, deliberately. Scintilla uses this to flip a list or a tip above the
// caret when it would leave the monitor; it has no monitor here, only the
// editor, and answering with the editor flipped every list near the pane's
// bottom edge. The host places each popup against the real display bounds
// (tkHost_PlacePopup) instead.
PRectangle Window::GetMonitorRect(Point) { return PRectangle(-32000, -32000, 32000, 32000); }

// ---------------------------------------------------------------- ListBox
//
// The MODEL lives here; the SURFACE belongs to the host. See the long note in
// PsScintillaC.h -- this is the toolkit's standing "the control ASKS, the host
// OWNS the surface" rule written across a C ABI, and it is why there is no OS
// control here even on Windows.

namespace {

const SciTkListBoxHost *g_lbHost = nullptr;
void *g_lbUser = nullptr;

// Which WindowIDs are lists. Window's non-virtual methods have nothing else to
// go on; see the note above them.
std::set<void *> g_listBoxes;

class ListBoxTk : public ListBox {
public:
	struct Item {
		std::string text;
		int type = -1;
	};
	std::vector<Item> items;
	int selection = -1;
	int visibleRows = 5;
	int lineHeight = 12;
	int aveCharWidth = 8;
	IListBoxDelegate *delegate = nullptr;
	const Font *font = nullptr;
	ListOptions options;
	PRectangle lastRect = PRectangle(0, 0, 100, 100);

	void SetFont(const Font *f) override { font = f; }
	void Create(Window &, int, Point, int lineHeight_, bool, Technology) override {
		if (lineHeight_ > 0) lineHeight = lineHeight_;
		// The list IS its own window id. Window's non-virtual methods dispatch
		// on this; without it every SetPosition would resize the editor.
		wid = static_cast<WindowID>(this);
		g_listBoxes.insert(this);
	}
	void SetAverageCharWidth(int width) override { if (width > 0) aveCharWidth = width; }
	void SetVisibleRows(int rows) override { if (rows > 0) visibleRows = rows; }
	int GetVisibleRows() const override { return visibleRows; }

	// Sized from the WIDEST item measured through the font Scintilla gave us,
	// not from a character count times an average. Proportional fonts and
	// ligatures both make that estimate wrong, and a list that clips its
	// longest entry is the visible result.
	PRectangle GetDesiredRect() override {
		XYPOSITION widest = 0;
		for (const Item &it : items) {
			const XYPOSITION w = PlatTk_MeasureWidth(font, it.text);
			if (w > widest) widest = w;
		}
		if (widest <= 0)
			widest = static_cast<XYPOSITION>(aveCharWidth * 12);

		const int rows = std::min<int>(visibleRows,
			std::max<int>(1, static_cast<int>(items.size())));
		// Room for the type image and the frame. Scintilla hands this rect
		// straight to the host, so the padding belongs on this side.
		const XYPOSITION w = widest + static_cast<XYPOSITION>(aveCharWidth * 3);
		const XYPOSITION h = static_cast<XYPOSITION>(rows * lineHeight + 4);
		return PRectangle(0, 0, w, h);
	}

	// How far in from the list's left edge the caret sits, so the completion
	// lines up with what the user has already typed.
	int CaretFromEdge() override { return aveCharWidth * 2; }

	void Clear() noexcept override {
		items.clear();
		selection = -1;
	}
	void Append(char *s, int type) override {
		if (!s) return;
		items.push_back(Item{ std::string(s), type });
		if (g_lbHost && g_lbHost->ItemsChanged) g_lbHost->ItemsChanged(g_lbUser, this);
	}
	int Length() override { return static_cast<int>(items.size()); }

	void Select(int n) override {
		selection = n;
		if (g_lbHost && g_lbHost->SelectionChanged)
			g_lbHost->SelectionChanged(g_lbUser, this, n);
	}
	int GetSelection() override { return selection; }

	// Scintilla's contract: the first item starting with `prefix`, or -1.
	// CASE SENSITIVE, matching ScintillaWin -- autocompletion applies its own
	// case folding before the list is built, not here.
	int Find(const char *prefix) override {
		if (!prefix || !*prefix) return -1;
		const size_t n = strlen(prefix);
		for (size_t i = 0; i < items.size(); i++) {
			if (items[i].text.size() >= n &&
			    items[i].text.compare(0, n, prefix, n) == 0)
				return static_cast<int>(i);
		}
		return -1;
	}

	std::string GetValue(int n) override {
		return (n >= 0 && n < static_cast<int>(items.size()))
			? items[static_cast<size_t>(n)].text : std::string();
	}

	// Images are the host's business -- it draws the rows. The type INDEX is
	// carried per item and handed out by SciTk_LbType; storing pixel data here
	// would be keeping an image the drawing code never sees.
	void RegisterImage(int, const char *) override {}
	void RegisterRGBAImage(int, int, int, const unsigned char *) override {}
	void ClearRegisteredImages() override {}

	void SetDelegate(IListBoxDelegate *lbDelegate) override { delegate = lbDelegate; }

	// "item<typesep><type><separator>item..." -- Scintilla's own encoding for a
	// whole list in one string. Parsed here so every caller gets the same
	// answer; a host re-parsing it would be a second implementation of a format
	// that is not ours.
	void SetList(const char *list, char separator, char typesep) override {
		Clear();
		if (list) {
			const char *p = list;
			while (true) {
				const char *end = strchr(p, separator);
				std::string entry = end ? std::string(p, end - p) : std::string(p);
				if (!entry.empty()) {
					int type = -1;
					const size_t ts = entry.find(typesep);
					if (ts != std::string::npos) {
						type = atoi(entry.c_str() + ts + 1);
						entry.erase(ts);
					}
					items.push_back(Item{ entry, type });
				}
				if (!end) break;
				p = end + 1;
			}
		}
		if (g_lbHost && g_lbHost->ItemsChanged) g_lbHost->ItemsChanged(g_lbUser, this);
	}

	void SetOptions(ListOptions options_) override { options = options_; }

	// ---- Where show and hide arrive, routed by Window's dispatch above ---
	void OnShow(bool show) {
		if (!g_lbHost) return;
		if (show) {
			if (g_lbHost->Show)
				g_lbHost->Show(g_lbUser, this,
					static_cast<int>(lastRect.left), static_cast<int>(lastRect.top),
					static_cast<int>(lastRect.Width()), static_cast<int>(lastRect.Height()));
		} else if (g_lbHost->Hide) {
			g_lbHost->Hide(g_lbUser, this);
		}
	}

	~ListBoxTk() noexcept override { g_listBoxes.erase(this); }
};

ListBoxTk *AsLb(void *lb) { return static_cast<ListBoxTk *>(lb); }

bool PlatTk_IsListBox(WindowID wid) noexcept {
	return wid && g_listBoxes.count(wid) != 0;
}
PRectangle PlatTk_LbRect(WindowID wid) noexcept {
	return static_cast<ListBoxTk *>(wid)->lastRect;
}
void PlatTk_LbSetRect(WindowID wid, PRectangle rc) noexcept {
	static_cast<ListBoxTk *>(wid)->lastRect = rc;
}
void PlatTk_LbShow(WindowID wid, bool show) noexcept {
	static_cast<ListBoxTk *>(wid)->OnShow(show);
}

} // namespace

ListBox::ListBox() noexcept = default;
ListBox::~ListBox() noexcept = default;
std::unique_ptr<ListBox> ListBox::Allocate() { return std::make_unique<ListBoxTk>(); }

extern "C" {

SCITK_API void SciTk_SetListBoxHost(const SciTkListBoxHost *host, void *user) {
	g_lbHost = host;
	g_lbUser = user;
}

SCITK_API int SciTk_LbCount(void *lb) {
	return lb ? static_cast<int>(AsLb(lb)->items.size()) : 0;
}
SCITK_API const char *SciTk_LbText(void *lb, int n) {
	if (!lb) return "";
	ListBoxTk *p = AsLb(lb);
	if (n < 0 || n >= static_cast<int>(p->items.size())) return "";
	return p->items[static_cast<size_t>(n)].text.c_str();
}
SCITK_API int SciTk_LbType(void *lb, int n) {
	if (!lb) return -1;
	ListBoxTk *p = AsLb(lb);
	if (n < 0 || n >= static_cast<int>(p->items.size())) return -1;
	return p->items[static_cast<size_t>(n)].type;
}
SCITK_API int SciTk_LbSelection(void *lb)   { return lb ? AsLb(lb)->selection : -1; }
SCITK_API int SciTk_LbRowHeight(void *lb)   { return lb ? AsLb(lb)->lineHeight : 0; }
SCITK_API int SciTk_LbVisibleRows(void *lb) { return lb ? AsLb(lb)->visibleRows : 0; }

// Moving the highlight. Deliberately does NOT call the host's
// SelectionChanged back -- the host is what just moved it, and a round trip is
// how a selection ends up fighting itself.
SCITK_API void SciTk_LbSetSelection(void *lb, int n) {
	if (!lb) return;
	AsLb(lb)->selection = n;
}

// Completing the word. doubleClick is the event autocompletion listens for;
// selectionChange only moves the highlight, which is why activating sends the
// former even when it came from the Enter key.
SCITK_API void SciTk_LbActivate(void *lb, int n) {
	if (!lb) return;
	ListBoxTk *p = AsLb(lb);
	p->selection = n;
	if (p->delegate) {
		ListBoxEvent ev(ListBoxEvent::EventType::doubleClick);
		p->delegate->ListNotify(&ev);
	}
}

} // extern "C"

// ---------------------------------------------------------------- Menu
//
// ScintillaBase::ContextMenu calls CreatePopUp, then AddToPopUp once per item
// (overridden in ScintillaPs.cxx), then Show. Those three become the host's
// three. There is no HMENU and no OS menu on either platform -- tkPopupMenu is
// the menu, and it belongs to the host like every other surface.

namespace {
const SciTkMenuHost *g_menuHost = nullptr;
void *g_menuUser = nullptr;
}

const SciTkMenuHost *PlatTk_MenuHost() { return g_menuHost; }
void *PlatTk_MenuUser() { return g_menuUser; }

extern "C" SCITK_API void SciTk_SetMenuHost(const SciTkMenuHost *host, void *user) {
	g_menuHost = host;
	g_menuUser = user;
}

Menu::Menu() noexcept : mid(nullptr) {}
void Menu::CreatePopUp() {
	// Opaque and non-null. Scintilla only ever checks it against 0; it is
	// never an HMENU, and nothing dereferences it.
	mid = reinterpret_cast<MenuID>(1);
	if (g_menuHost && g_menuHost->Begin) g_menuHost->Begin(g_menuUser);
}
void Menu::Destroy() noexcept { mid = nullptr; }
void Menu::Show(Point pt, const Window &) {
	if (g_menuHost && g_menuHost->Show)
		g_menuHost->Show(g_menuUser, static_cast<int>(pt.x), static_cast<int>(pt.y));
	Destroy();
}

// ---------------------------------------------------------------- Platform
namespace Scintilla::Internal::Platform {

// Debugging.h declares these and the core calls them through PLATFORM_ASSERT.
// They are the platform's to define -- easy to miss, because nothing needs them
// until link time and the error names a symbol rather than a missing feature.
//
// Assert does NOT abort here. A failed Scintilla assertion inside a spike is
// information, not a reason to kill the process before it can report anything;
// the real backend should route this to the toolkit's logging.
void Assert(const char *c, const char *file, int line) noexcept {
	fprintf(stderr, "Scintilla assertion: %s  (%s:%d)\n", c, file, line);
	fflush(stderr);
}
bool ShowAssertionPopUps(bool) noexcept { return false; }
void DebugPrintf(const char *format, ...) noexcept {
	va_list ap;
	va_start(ap, format);
	vfprintf(stderr, format, ap);
	va_end(ap);
}

ColourRGBA Chrome()          { return ColourRGBA(0xE0, 0xE0, 0xE0); }
ColourRGBA ChromeHighlight() { return ColourRGBA(0xFF, 0xFF, 0xFF); }
const char *DefaultFont()    { return "Cascadia Code"; }
int DefaultFontSize()        { return 10; }
unsigned int DoubleClickTime() { return 500; }
}
