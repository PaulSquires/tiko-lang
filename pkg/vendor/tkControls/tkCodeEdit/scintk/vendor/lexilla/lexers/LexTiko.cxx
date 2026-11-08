// Scintilla source code edit control
/** @file LexVB.cxx
 ** Lexer for Visual Basic and VBScript.
 **/
// Copyright 1998-2005 by Neil Hodgson <neilh@scintilla.org>
// The License.txt file describes the conditions under which this software may be distributed.

#include <cstdlib>
#include <cassert>
#include <cstring>

#include <string>
#include <string_view>
#include <map>

#include "ILexer.h"
#include "Scintilla.h"
#include "SciLexer.h"

#include "WordList.h"
#include "LexAccessor.h"
#include "Accessor.h"
#include "StyleContext.h"
#include "CharacterSet.h"
#include "LexerModule.h"
#include "OptionSet.h"
#include "DefaultLexer.h"

using namespace Scintilla;
using namespace Lexilla;

namespace {

// Internal state, highlighted as number
constexpr int SCE_B_FILENUMBER = SCE_B_DEFAULT + 100;
constexpr int SCE_B_MULTILINECOMMENT = 19;

bool IsVBComment(Accessor &styler, Sci_Position pos, Sci_Position len) {
	return len > 0 && styler[pos] == '\'';
}

// tiko BLOCK STRINGS:
//     dim as string s = """
//         body, verbatim
//     """
// The opener is """ followed only by spaces/tabs to the end of its line ("""abc""" stays an
// ordinary string). The closer is the first later line that starts -- after spaces/tabs --
// with """; the rest of that line is ordinary code. The whole block is styled SCE_B_STRING.
// A line's LINE STATE is 1 when the NEXT line starts inside a block, which is how a lex that
// begins mid-document knows where it is.

// """ at pos, then only blanks to end of line (or of the document).
bool IsBlockOpener(Accessor &styler, Sci_Position pos) {
	if (styler.SafeGetCharAt(pos, '\n') != '\"' || styler.SafeGetCharAt(pos + 1, '\n') != '\"' ||
	    styler.SafeGetCharAt(pos + 2, '\n') != '\"') {
		return false;
	}
	for (Sci_Position p = pos + 3; ; p++) {
		const char c = styler.SafeGetCharAt(p, '\n');
		if (c == ' ' || c == '\t') {
			continue;
		}
		return c == '\r' || c == '\n';
	}
}

// For the line starting at lineStart: the position just past its closing """, or -1 if the
// line is not a closer.
Sci_Position BlockCloserEnd(Accessor &styler, Sci_Position lineStart) {
	Sci_Position p = lineStart;
	while (styler.SafeGetCharAt(p, '\n') == ' ' || styler.SafeGetCharAt(p, '\n') == '\t') {
		p++;
	}
	if (styler.SafeGetCharAt(p, '\n') == '\"' && styler.SafeGetCharAt(p + 1, '\n') == '\"' &&
	    styler.SafeGetCharAt(p + 2, '\n') == '\"') {
		return p + 3;
	}
	return -1;
}

// Identifier characters
constexpr bool IsTypeCharacter(int ch) noexcept {
	return ch == '%' || ch == '&' || ch == '@' || ch == '!' || ch == '#' || ch == '$';
}

// Brace characters
constexpr bool IsBraceCharacter(int ch) noexcept {
	if (ch == '(' || ch == ')' || ch == '@' || ch == '[' || ch == ']' || ch == '{' || ch == '}') return true;
	return false;
}

// Extended to accept accented characters
constexpr bool IsAWordChar(int ch) noexcept {
	return !IsASCII(ch) ||
	       (IsAlphaNumeric(ch) || ch == '.' || ch == '_');
}

constexpr bool IsAWordStart(int ch) noexcept {
	return !IsASCII(ch) ||
	       (IsUpperOrLowerCase(ch) || ch == '_');
}

constexpr bool IsANumberChar(int ch) noexcept {
	// Not exactly following number definition (several dots are seen as OK, etc.)
	// but probably enough in most cases.
	return IsAHeXDigit(ch) || AnyOf(ch, '.', '-', '+', '_');
}

// Options used for LexerVB
struct OptionsVB {
	bool fold = false;
	bool allowMultilineStr = false;
};

const char * const vbWordListDesc[] = {
	"Keywords",
	"user1",
	"user2",
	"user3",
	nullptr
};

struct OptionSetVB : public OptionSet<OptionsVB> {
	OptionSetVB() {
		DefineProperty("fold", &OptionsVB::fold);

		DefineProperty("lexer.vb.strings.multiline", &OptionsVB::allowMultilineStr,
			"Set to 1 to allow strings to continue over line ends.");

		DefineWordListSets(vbWordListDesc);
	}
};

LexicalClass lexicalClasses[] = {
	// Lexer vb SCLEX_VB SCE_B_:
	0, "SCE_B_DEFAULT", "default", "White space",
	1, "SCE_B_COMMENT", "comment", "Comment: '",
	2, "SCE_B_NUMBER", "literal numeric", "Number",
	3, "SCE_B_KEYWORD", "keyword", "Keyword",
	4, "SCE_B_STRING", "literal string", "Double quoted string",
	5, "SCE_B_PREPROCESSOR", "preprocessor", "Preprocessor",
	6, "SCE_B_OPERATOR", "operator", "Operators",
	7, "SCE_B_IDENTIFIER", "identifier", "Identifiers",
	8, "SCE_B_DATE", "literal date", "Date",  // we use for @()[]{} brace characters
	9, "SCE_B_STRINGEOL", "error literal string", "End of line where string is not closed",
	10, "SCE_B_KEYWORD2", "identifier", "Keywords2",
	11, "SCE_B_KEYWORD3", "identifier", "Keywords3",
	12, "SCE_B_KEYWORD4", "identifier", "Keywords4",
};

class LexerVB : public DefaultLexer {
	bool vbScriptSyntax;
	WordList keywords;
	WordList keywords2;
	WordList keywords3;
	WordList keywords4;
	OptionsVB options;
	OptionSetVB osVB;
public:
	LexerVB(const char *languageName_, int language_, bool vbScriptSyntax_) :
		DefaultLexer(languageName_, language_, lexicalClasses, std::size(lexicalClasses)),
		vbScriptSyntax(vbScriptSyntax_) {
	}
	// Deleted so LexerVB objects can not be copied.
	LexerVB(const LexerVB &) = delete;
	LexerVB(LexerVB &&) = delete;
	void operator=(const LexerVB &) = delete;
	void operator=(LexerVB &&) = delete;
	~LexerVB() override = default;
	void SCI_METHOD Release() override {
		delete this;
	}
	int SCI_METHOD Version() const override {
		return lvRelease5;
	}
	const char *SCI_METHOD PropertyNames() override {
		return osVB.PropertyNames();
	}
	int SCI_METHOD PropertyType(const char *name) override {
		return osVB.PropertyType(name);
	}
	const char *SCI_METHOD DescribeProperty(const char *name) override {
		return osVB.DescribeProperty(name);
	}
	Sci_Position SCI_METHOD PropertySet(const char *key, const char *val) override;
	const char *SCI_METHOD PropertyGet(const char *key) override {
		return osVB.PropertyGet(key);
	}
	const char *SCI_METHOD DescribeWordListSets() override {
		return osVB.DescribeWordListSets();
	}
	Sci_Position SCI_METHOD WordListSet(int n, const char *wl) override;

	void CheckIdentifier(Lexilla::StyleContext &sc);

	void SCI_METHOD Lex(Sci_PositionU startPos, Sci_Position length, int initStyle, IDocument *pAccess) override;
	void SCI_METHOD Fold(Sci_PositionU startPos, Sci_Position length, int initStyle, IDocument *pAccess) override;

	void *SCI_METHOD PrivateCall(int, void *) override {
		return nullptr;
	}
	static ILexer5 *LexerFactoryVB() {
		return new LexerVB("vb", SCLEX_VB, false);
	}
	static ILexer5 *LexerFactoryVBScript() {
		return new LexerVB("vbscript", SCLEX_VBSCRIPT, true);
	}
};

Sci_Position SCI_METHOD LexerVB::PropertySet(const char *key, const char *val) {
	if (osVB.PropertySet(&options, key, val)) {
		return 0;
	}
	return -1;
}

Sci_Position SCI_METHOD LexerVB::WordListSet(int n, const char *wl) {
	WordList *wordListN = nullptr;
	switch (n) {
	case 0:
		wordListN = &keywords;
		break;
	case 1:
		wordListN = &keywords2;
		break;
	case 2:
		wordListN = &keywords3;
		break;
	case 3:
		wordListN = &keywords4;
		break;
	default:
		break;
	}
	Sci_Position firstModification = -1;
	if (wordListN && wordListN->Set(wl, true)) {
		firstModification = 0;
	}
	return firstModification;
}

// tiko's property sections: `set` ... `end set` (and `get` ... `end get`). `get` is a reserved
// word and in the keyword list; `set` is not -- it names std's containers.Set -- so it is a
// keyword only ALONE ON ITS LINE (blanks, then the line end or a comment) or AFTER `end`.
// An auto-property's accessor clause, `get, set` / `get, private set` / `get, init`, makes
// `set` and `init` keywords too.
static Sci_Position SkipBlanksBack(StyleContext &sc, Sci_Position p) {
	while (sc.GetRelative(p) == ' ' || sc.GetRelative(p) == '\t') p--;
	return p;
}

// The word `w` (lower case) ending at `p`, a whole word: `p` moves to the character before it.
static bool WordEndsAt(StyleContext &sc, Sci_Position &p, const char *w) {
	const Sci_Position n = static_cast<Sci_Position>(strlen(w));
	for (Sci_Position i = 0; i < n; i++) {
		if (MakeLowerCase(sc.GetRelative(p - i)) != w[n - 1 - i]) return false;
	}
	if (IsAWordChar(sc.GetRelative(p - n))) return false;
	p -= n;
	return true;
}

static bool IsAccessorClause(StyleContext &sc, const char *s) {
	if (strcmp(s, "set") != 0 && strcmp(s, "init") != 0) return false;
	Sci_Position p = SkipBlanksBack(sc, -sc.LengthCurrent() - 1);
	Sci_Position q = p;
	if (WordEndsAt(sc, q, "private") || WordEndsAt(sc, q, "protected") || WordEndsAt(sc, q, "public")) {
		p = SkipBlanksBack(sc, q);
	}
	if (sc.GetRelative(p) != ',') return false;
	p = SkipBlanksBack(sc, p - 1);
	return WordEndsAt(sc, p, "get");
}

static bool IsSetSection(StyleContext &sc, const char *s) {
	if (IsAccessorClause(sc, s)) return true;     // `get, set`
	if (strcmp(s, "set") != 0) return false;
	const Sci_Position len = sc.LengthCurrent();
	Sci_Position back = -len - 1;
	while (sc.GetRelative(back) == ' ' || sc.GetRelative(back) == '\t') back--;
	const int before = sc.GetRelative(back);
	if (MakeLowerCase(before) == 'd' && MakeLowerCase(sc.GetRelative(back - 1)) == 'n' &&
	    MakeLowerCase(sc.GetRelative(back - 2)) == 'e' && !IsAWordChar(sc.GetRelative(back - 3)) &&
	    back < -len - 1) {
		return true;                              // `end set`
	}
	if (before != '\n' && before != '\r' && before != '\0') return false;
	Sci_Position ahead = 0;
	while (sc.GetRelative(ahead) == ' ' || sc.GetRelative(ahead) == '\t') ahead++;
	const int after = sc.GetRelative(ahead);
	return after == '\n' || after == '\r' || after == '\0' || after == '\'';
}

void LexerVB::CheckIdentifier(StyleContext &sc) {
	// In Basic (except VBScript), a variable name or a function name
	// can end with a special character indicating the type of the value
	// held or returned.
	bool skipType = false;
	if (!vbScriptSyntax && IsTypeCharacter(sc.ch)) {
		sc.Forward();	// Skip it
		skipType = true;
	}
	char s[100];
	sc.GetCurrentLowered(s, sizeof(s));
	if (skipType) {
		s[strlen(s) - 1] = '\0';
	}
	if (strcmp(s, "rem") == 0) {
		sc.ChangeState(SCE_B_COMMENT);
	} else {
		if (keywords.InList(s) || IsSetSection(sc, s)) {
			sc.ChangeState(SCE_B_KEYWORD);
		} else if (keywords2.InList(s)) {
			sc.ChangeState(SCE_B_KEYWORD2);
		} else if (keywords3.InList(s)) {
			sc.ChangeState(SCE_B_KEYWORD3);
		} else if (keywords4.InList(s)) {
			sc.ChangeState(SCE_B_KEYWORD4);
		}	// Else, it is really an identifier...
		sc.SetState(SCE_B_DEFAULT);
	}
}

void LexerVB::Lex(Sci_PositionU startPos, Sci_Position length, int initStyle, IDocument *pAccess) {
	Accessor styler(pAccess, nullptr);

	styler.StartAt(startPos);

	int visibleChars = 0;

	// Do not leak onto next line
	if (initStyle == SCE_B_STRINGEOL || initStyle == SCE_B_COMMENT || initStyle == SCE_B_PREPROCESSOR) {
		initStyle = SCE_B_DEFAULT;
	}

	// Inside a block string? Scintilla always starts a lex at a line start, so the previous
	// line's state answers it. An ordinary string never crosses a line end, so a STRING
	// initStyle that is NOT a block is a leftover and is dropped.
	const Sci_Position lineFirst = styler.GetLine(startPos);
	bool inBlock = (lineFirst > 0) && (styler.GetLineState(lineFirst - 1) == 1);
	Sci_Position closerEnd = -1;
	if (inBlock) {
		initStyle = SCE_B_STRING;
	} else if (initStyle == SCE_B_STRING) {
		initStyle = SCE_B_DEFAULT;
	}

	StyleContext sc(startPos, length, initStyle, styler);

	for (; sc.More(); sc.Forward()) {

		// A block string's body: everything is string until the closer's """ is passed.
		if (inBlock) {
			if (sc.atLineStart) {
				closerEnd = BlockCloserEnd(styler, sc.currentPos);
			}
			if (closerEnd >= 0 && static_cast<Sci_Position>(sc.currentPos) >= closerEnd) {
				// Past the closer: this character is ordinary code again.
				inBlock = false;
				closerEnd = -1;
				sc.SetState(SCE_B_DEFAULT);
			} else {
				if (sc.atLineEnd) {
					styler.SetLineState(sc.currentLine, 1);
					visibleChars = 0;
				}
				continue;
			}
		}

		// Determine if the current state should terminate.
		if (sc.state == SCE_B_MULTILINECOMMENT) {
			// Multiline comment
			if (sc.Match(39, '/')) {
				sc.Forward();
				sc.ForwardSetState(SCE_B_DEFAULT);
			}
		} else if (sc.state == SCE_B_OPERATOR) {
			sc.SetState(SCE_B_DEFAULT);
		} else if (sc.state == SCE_B_IDENTIFIER) {
			if (!IsAWordChar(sc.ch)) {
				CheckIdentifier(sc);
			}
		} else if (sc.state == SCE_B_NUMBER) {
			// We stop the number definition on non-numerical non-dot non-eE non-sign char
			// Also accepts A-F for hex. numbers
			if (!IsANumberChar(sc.ch)) {
				sc.SetState(SCE_B_DEFAULT);
			}
		} else if (sc.state == SCE_B_STRING) {
			// VB doubles quotes to preserve them, so just end this string
			// state now as a following quote will start again
			if (sc.ch == '\"') {
				if (sc.chNext == '\"') {
					sc.Forward();
				} else {
					if (MakeLowerCase(sc.chNext) == 'c') {
						sc.Forward();
					}
					sc.ForwardSetState(SCE_B_DEFAULT);
				}
			} else if (sc.atLineEnd && !options.allowMultilineStr) {
				visibleChars = 0;
				sc.ChangeState(SCE_B_STRINGEOL);
				sc.ForwardSetState(SCE_B_DEFAULT);
			}
		} else if (sc.state == SCE_B_COMMENT) {
			if (sc.atLineEnd) {
				visibleChars = 0;
				sc.ForwardSetState(SCE_B_DEFAULT);
			}
		} else if (sc.state == SCE_B_PREPROCESSOR) {
			if (sc.atLineEnd) {
				visibleChars = 0;
				sc.ForwardSetState(SCE_B_DEFAULT);
			}
		} else if (sc.state == SCE_B_DATE) {   // we use this for brace characters
			sc.SetState(SCE_B_DEFAULT);
		}

		if (sc.state == SCE_B_DEFAULT) {
			if (sc.Match('/', 39)) {
				sc.SetState(SCE_B_MULTILINECOMMENT);
				sc.Forward();   // Eat the * so it isn't used for the end of the comment
			} else if (sc.ch == '\'') {
				sc.SetState(SCE_B_COMMENT);
			} else if (sc.ch == '\"' && IsBlockOpener(styler, sc.currentPos)) {
				// A block string's opener: the block branch above takes every character
				// from here to the closer.
				sc.SetState(SCE_B_STRING);
				inBlock = true;
				closerEnd = -1;
			} else if (sc.ch == '\"') {
				sc.SetState(SCE_B_STRING);
			} else if (sc.ch == '#' && visibleChars == 0) {
				// Preprocessor commands are alone on their line
				sc.SetState(SCE_B_PREPROCESSOR);

			} else if (IsBraceCharacter(sc.ch)) {
				sc.SetState(SCE_B_DATE);
			} else if (sc.ch == '&' && MakeLowerCase(sc.chNext) == 'h') {
				// Hexadecimal number
				sc.SetState(SCE_B_NUMBER);
				sc.Forward();
			} else if (sc.ch == '&' && MakeLowerCase(sc.chNext) == 'o') {
				// Octal number
				sc.SetState(SCE_B_NUMBER);
				sc.Forward();
			} else if (sc.ch == '&' && MakeLowerCase(sc.chNext) == 'b') {
				// Binary number
				sc.SetState(SCE_B_NUMBER);
				sc.Forward();
			} else if (IsADigit(sc.ch) || (sc.ch == '.' && IsADigit(sc.chNext))) {
				sc.SetState(SCE_B_NUMBER);
			} else if (IsAWordStart(sc.ch) ) {
				sc.SetState(SCE_B_IDENTIFIER);
			} else if (isoperator(sc.ch) || (sc.ch == '\\')) {	// Integer division
				sc.SetState(SCE_B_OPERATOR);
			}
		}

		if (sc.atLineEnd) {
			visibleChars = 0;
			// 1 = the next line starts inside a block string (an opener ended this line).
			styler.SetLineState(sc.currentLine, inBlock ? 1 : 0);
		}
		if (!IsASpace(sc.ch)) {
			visibleChars++;
		}
	}

	if (sc.state == SCE_B_IDENTIFIER && !IsAWordChar(sc.ch)) {
		CheckIdentifier(sc);
	}

	sc.Complete();
}

void LexerVB::Fold(Sci_PositionU startPos, Sci_Position length, int, IDocument *pAccess) {
	if (!options.fold)
		return;

	Accessor styler(pAccess, nullptr);
	const Sci_Position endPos = startPos + length;

	// Backtrack to previous line in case need to fix its fold status
	Sci_Position lineCurrent = styler.GetLine(startPos);
	if (startPos > 0) {
		if (lineCurrent > 0) {
			lineCurrent--;
			startPos = styler.LineStart(lineCurrent);
		}
	}
	int spaceFlags = 0;
	int indentCurrent = styler.IndentAmount(lineCurrent, &spaceFlags, IsVBComment);
	char chNext = styler[startPos];
	for (Sci_Position i = startPos; i < endPos; i++) {
		const char ch = chNext;
		chNext = styler.SafeGetCharAt(i + 1);

		if ((ch == '\r' && chNext != '\n') || (ch == '\n') || (i == endPos)) {
			int lev = indentCurrent;
			const int indentNext = styler.IndentAmount(lineCurrent + 1, &spaceFlags, IsVBComment);
			if (!(indentCurrent & SC_FOLDLEVELWHITEFLAG)) {
				// Only non whitespace lines can be headers
				if ((indentCurrent & SC_FOLDLEVELNUMBERMASK) < (indentNext & SC_FOLDLEVELNUMBERMASK)) {
					lev |= SC_FOLDLEVELHEADERFLAG;
				} else if (indentNext & SC_FOLDLEVELWHITEFLAG) {
					// Line after is blank so check the next - maybe should continue further?
					int spaceFlags2 = 0;
					const int indentNext2 = styler.IndentAmount(lineCurrent + 2, &spaceFlags2, IsVBComment);
					if ((indentCurrent & SC_FOLDLEVELNUMBERMASK) < (indentNext2 & SC_FOLDLEVELNUMBERMASK)) {
						lev |= SC_FOLDLEVELHEADERFLAG;
					}
				}
			}
			indentCurrent = indentNext;
			styler.SetLevel(lineCurrent, lev);
			lineCurrent++;
		}
	}
}

}

extern const LexerModule lmVB(SCLEX_VB, LexerVB::LexerFactoryVB, "tiko", vbWordListDesc);
extern const LexerModule lmVBScript(SCLEX_VBSCRIPT, LexerVB::LexerFactoryVBScript, "vbscript", vbWordListDesc);
