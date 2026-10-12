# The tiko Programming Language

The source of a book about [tiko](https://github.com/PaulSquires/tiko-lang), a
FreeBASIC-compatible compiler that targets Windows and Linux on x86-64 through LLVM.

Markdown in, PDF out. **Every listing in this book is a real program that is compiled and run on
both targets before the book builds** — the book cannot describe behaviour the compiler does not
have.

The design, the table of contents and the roadmap live in `C:\dev\docs\tiko-book\`.

Status: **Phase 2 — scaffolded.** One stub chapter proves the pipeline. Prose starts in Phase 3.

## Layout

| Path | What it is |
|---|---|
| `book.toml` | mdBook configuration: title, theme, preprocessors |
| `src/SUMMARY.md` | The table of contents that drives the site |
| `src/` | The prose. One file per chapter, plus the cover page |
| `book.yaml` | **The pin** — the exact toolchains every listing is verified against — and the per-chapter status |
| `examples/chNN/` | Every listing, with its expected output. Nothing is pasted into the prose |
| `tools/` | The listings harness, the generators, and the pandoc filters |
| `template/` | The typst template and the generated tiko syntax definition |
| `build/pdf.sh` | markdown → typst → PDF |
| `out/` | Build output. Not committed |

## Building

Requires mdbook **0.4.x** and mdbook-admonish (`cargo install mdbook --version '^0.4'
mdbook-admonish`), pandoc and typst for the PDF (both ship inside Quarto, and the scripts find
them there), Python 3, the pinned tiko toolchains, and WSL for the Linux target.

mdbook-admonish does not work under mdbook 0.5 — it fails on a minimal book — so the 0.4 line is
deliberate, and `build/site.sh` refuses to run under 0.5.

```bash
tools/check-listings.sh          # compile and run every listing, both targets
build/site.sh                    # the mdBook site -> book/  (published to tiko-lang.net/book)
build/site.sh --serve            # local preview with live reload
build/pdf.sh                     # the PDF edition, from the same src/
```

Useful variants:

```bash
tools/check-listings.sh ch01 --target windows-x86_64
build/pdf.sh --chapter 01 --png
```

## How a listing works

A listing is a complete program under `examples/chNN/`, beside the output it must produce.
Sources are `.tiko` and headers `.ti`; a legacy listing in the compatibility chapter is genuinely
named `.bas`:

| File | Meaning |
|---|---|
| `name.tiko` | The program. Compiler flags live inside it, as `#cmdline "-exx"` |
| `name.out` | Expected stdout, compared after CRLF normalisation |
| `name.exit` | Expected exit code, if not 0 |
| `name.args`, `name.stdin` | Arguments and input |
| `name.meta` | `targets:`, `expect: compile-error TKOnnnn`, `modules:`, `forward:` |

The prose includes it by reference, so the two can never drift:

````markdown
```tiko
{{#include ../examples/ch01/hello.tiko}}
```
````

Add `:anchor` to include part of a file — the region between `'' ANCHOR: name` and
`'' ANCHOR_END: name`. A whole-file include does **not** strip those comments, so only add
anchors to a file something includes partially.

## Rules

**[STYLE.md](STYLE.md) is the full style guide** — voice, chapter shape, code style, callouts,
evidence, and the checklist a chapter passes before it is done. The four rules below are the ones
it refuses to bend on.

1. **A failing listing is a compiler bug to file, not something to write around.** Work items
   are tracked in `C:\dev\docs\tiko-book\04-roadmap.md`.
2. **Never paste code into prose.** If it is not in `examples/`, it was never compiled.
3. **The pin is deliberate.** The harness refuses to run when `tiko --version` does not match
   `book.yaml`, because a stale toolchain produces a plausible result rather than an error.
4. **No FreeBASIC-manual text.** Those wiki pages are GFDL and other authors' work. This book's
   text is original.

## Licences

The text is CC BY-NC-SA 4.0 (`LICENSE`). Everything in `examples/`, `tools/` and `build/` is MIT
(`LICENSE-CODE`), so you can reuse listing code anywhere, including at work.
