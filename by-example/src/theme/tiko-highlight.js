// GENERATED from this template by tools/gen_syntax.py. Do not edit the copy in src/theme/.
//
// mdBook highlights with highlight.js, which has no tiko grammar. This registers one and
// re-highlights the tiko blocks, because mdBook has already run by the time additional-js
// executes. The word lists come from the compiler's own src/lexer/keywords.ti, so the site
// cannot disagree with tiko about what a keyword is.
//
// This file is a TEMPLATE with @PLACEHOLDERS@, kept as real JavaScript rather than built
// from a string in the generator: every previous attempt to emit it through nested quoting
// lost a backslash and shipped a file that failed with "Invalid or unexpected token".
(function () {
    function register() {
        if (typeof hljs === "undefined") return false;

        hljs.registerLanguage("tiko", function () {
            return {
                name: "tiko",
                case_insensitive: true,
                keywords: {
                    keyword: "__fastcall __thiscall abs abstract alias and andalso any as asm base boolean byref byte byval call case cast cbool cbyte cdbl cdecl channel cint class clng clngint common const constructor continue cptr cshort csign csng cubyte cuint culng culngint cunsg cushort cva_arg cva_copy cva_end cva_start declare defer delete destructor dim do double each else elseif end endif enum eqv exit export extends extern fix for frac from function goto if iif imp implements import in int integer is let lib long longint loop mod naked namespace new next not of operator or orelse overload override pascal pointer private procptr property protected ptr public receive rem return scope select send sgn shared shl short shr single spawn static stdcall step string sub then timeout to type typeof ubyte uinteger ulong ulongint union unsigned until ushort using ustring va_first var virtual wend while with wstring xor zstring",
                    built_in: "access acos append asc asin atan2 atn binary chr circle close color cos cvd cvi cvl cvlongint cvs cvshort data defbyte defdbl defined defint deflng deflongint defshort defsng defstr defubyte defuint defulng defulongint defushort draw dynamic encoding erase err error exp explicit field get gosub imagecreate include input instr instrrev lbound lcase len line local lock log lprint lset ltrim mid mkd mki mkl mklongint mks mkshort name on open option output paint palette peek point poke preserve preset print pset put random read redim restore resume rset rtrim sadd screen seek sin sizeof spc sqr str strptr swap tab tan threadcall trim ubound ucase unlock varptr view wchr width window winput write wstr",
                    literal: "true false"
                },
                contains: [
                    { className: "comment", begin: "''", end: "$" },
                    { className: "comment", begin: "\\brem\\b", end: "$" },
                    { className: "comment", begin: "/'", end: "'/", contains: ["self"] },
                    // A BLOCK STRING: '"""' that ends its line, closed by the first line that
                    // starts with '"""'. Ahead of the one-line rule, which would close it at '""'.
                    {
                        className: "string",
                        begin: "(?:[!$])?\"\"\"(?=[ \\t]*$)",
                        end: "^[ \\t]*\"\"\""
                    },
                    {
                        className: "string",
                        begin: "(?:[!$])?\"",
                        end: "\"",
                        illegal: "\\n",
                        contains: [{ begin: "\"\"" }]
                    },
                    {
                        className: "number",
                        begin: "&[hH][0-9a-fA-F]+|&[oO][0-7]+|&[bB][01]+|\\b\\d+(?:\\.\\d*)?(?:[eEdD][-+]?\\d+)?"
                    },
                    { className: "meta", begin: "^\\s*#\\s*[A-Za-z_]+" },
                    { className: "meta", begin: "\\b__[A-Z_]+__\\b" }
                ]
            };
        });
        return true;
    }

    function paint() {
        document.querySelectorAll("code.language-tiko").forEach(function (el) {
            if (el.dataset.tikoHighlighted) return;
            el.dataset.tikoHighlighted = "1";
            hljs.highlightBlock ? hljs.highlightBlock(el) : hljs.highlightElement(el);
        });
    }

    function start() {
        if (register()) {
            paint();
            return;
        }
        // highlight.js is not there yet; wait for it rather than failing silently.
        var tries = 0;
        var timer = setInterval(function () {
            if (register()) {
                clearInterval(timer);
                paint();
            } else if (++tries > 50) {
                clearInterval(timer);
                console.warn("tiko-highlight: highlight.js never appeared; listings are unstyled");
            }
        }, 50);
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", start);
    } else {
        start();
    }
})();
