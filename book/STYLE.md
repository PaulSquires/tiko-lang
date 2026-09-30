# Style guide

How *The tiko Programming Language* is written. It was drafted after the first two chapters, so
every rule here comes from something that actually happened while writing them, not from taste
alone.

The design record — decisions, table of contents, coverage, roadmap — lives in
`C:\dev\docs\tiko-book\`. This file governs the prose and the listings.

## 1. The rule the whole book rests on

**Nothing is printed that was not compiled and run.**

A listing is a complete program in `examples/chNN/`, verified on **both** targets by
`tools/check-listings.sh` before the prose around it is written. The chapter includes it by
reference, so the two cannot drift.

The order is not negotiable, because it is what makes the book true:

1. Write the listing and its expected output.
2. Run the harness. Green on win64-msvc **and** linux-x86_64.
3. Then write the prose, describing what you just watched happen.

**When a listing fails, the compiler is wrong until proven otherwise.** File the defect, mark the
listing `blocked: Tnn`, and leave it failing. Never reshape a listing so the book agrees with a
bug — a reader who hits that bug is then reading a book that lies to them. Both pilot chapters
found real compiler defects this way; that is the process working.

**The outline is a hypothesis.** Chapter 16's outline promised diagnostics that name the
instantiation behind an error. The compiler declares that diagnostic and emits it from nowhere.
The chapter documents the gap instead, and the plan carries an amendment. Where the plan and the
compiler disagree, **the compiler wins and the plan gets corrected.**

## 2. Voice

- **Second person, present tense, direct.** "You write the code once" — not "one writes", not
  "we will now examine".
- **Say why, then show it.** A rule without its reason is a rule the reader will break the moment
  it is inconvenient.
- **No marketing adjectives.** Not *powerful*, *blazingly fast*, *elegant*, *simply*. The brand is
  carried by evidence; an adjective in its place reads as a substitute for one.
- **No "simply", "just", "obviously", "of course".** If it were obvious the sentence would not be
  needed, and the reader who does not find it obvious now feels stupid.
- **Short sentences for hard ideas.** Save the long ones for narrative.
- **Name the trade.** Generics cost binary size. `-exx` costs speed. Say so where the reader meets
  the choice.

## 3. What a chapter looks like

```
# Title                     one per file, sentence-style capitals after the first word
   intro                    two or three paragraphs: what this is for, why it exists
## Section                  the level the TOC lists
### Subsection              the deepest heading used
## Summary                  bullets, one per idea the reader must keep
## Exercises                numbered, each ending {solution="exNN-MM"} where one exists
```

- Open with the **problem**, not the feature. Chapter 16 opens with "a `Stack` of integers and a
  `Stack` of names are the same code twice", not with "generics are parameterised types".
- **At least one Pitfall per chapter** (B7), and it must be a real trap — something that compiles
  and does the wrong thing, not a reminder to read the manual.
- The last section before the Summary is usually **what it costs**.

## 4. Code in listings

The house style, matching tiko-lang's own README:

| Rule | |
|---|---|
| Keywords lowercase | `for each`, `end function` |
| Types and procedures PascalCase | `Map( of ustring, int32 )`, `ReadAllText` |
| Comments `''` | a lone `'` reads as old BASIC |
| Files | `.tiko` source, `.ti` headers |
| Strings | `ustring`, not `string` |
| Numbers | `int32`, `int64`, `float64`; `integer` only where pointer-sized is the point |
| Declaration | `var` where the type is obvious, `dim x as T` where it is not |
| Library | `#import "std/…"`; `#include` only where no module fronts the header |
| Width | **72 columns**, enforced by the harness |
| Flags | in the listing, as `#cmdline "-exx"` — a listing reproduces on its own |

**Never in an example:** line numbers, `goto`, `gosub`, `data`/`read`, `dim shared` globals,
`wend`, `screen` graphics, type-suffix sigils. Those belong to Chapter 30, where they are the
subject.

A listing is a whole program. If the prose needs a fragment, use an anchor — never paste.

## 5. Naming things in prose

- **tiko** is lowercase, including at the start of a sentence. It is the name of the language, not
  a proper noun to be dressed up.
- Keywords and code in backticks, spelled as they are written: `for each`, not "FOR EACH".
- Types keep the library's casing: `Optional( of T )`, `FB.HashOf`.
- Diagnostics by id and text: `TKO0720: no operator > compares this type`.
- The compiler is "the compiler" or "tiko". Not "the tiko compiler system", not "TIKO".

## 6. Callouts

Five kinds, each with one job:

| Block | For |
|---|---|
| ```` ```admonish danger title="Pitfall" ```` | Compiles, runs, does the wrong thing |
| ```` ```admonish note ```` | An aside the reader can skip |
| ```` ```admonish info title="On Windows" ```` / `"On Linux"` | Platform-specific material |
| ```` ```admonish tip title="Coming from FreeBASIC" ```` | Sparingly, and **never in Chapter 1** |
| ```` ```admonish warning title="Status in this version" ```` | A limit of the pinned compiler, naming its work item |

> **A callout containing a code fence needs four backticks.**
>
> An admonish block is itself a fence, so a three-backtick fence inside it closes it early
> and the rest of the callout leaks into the page as literal text, `</div>` and all.
> Open such a callout with `````` instead.
>
> It looks correct in the markdown either way; the damage shows only in the browser, which is
> why §9 says to look there. Two separate fence bugs have been shipped and then caught that
> way — including one in the first draft of this very section, where the example of the trap
> fell into it.
>
> This file is a repository document, not a book page: mdBook never renders it, so it uses a
> blockquote here rather than a live admonish block. pandoc reads an info string containing
> spaces and quotes as an **inline code span**, not a fence — which is what
> `tools/prep_admonish.py` exists to rewrite for the chapters.

## 7. Listings, anchors and output

````markdown
```tiko
{{#include ../examples/ch16/box.tiko}}
```

```text
{{#include ../examples/ch16/box.out}}
```
````

- Include part of a file with `{{#include ../examples/chNN/name.tiko:anchor}}`, where the region
  is marked `'' ANCHOR: name` … `'' ANCHOR_END: name`.
- **A whole-file include does not strip those comments.** So only put anchors in a file something
  includes partially, and when you do, always include it by anchor.
- Never select by line number. Line numbers drift; anchors do not.
- Output blocks are `text`, and their content comes from the `.out` file the harness compares
  against. Never retype output by hand.

## 8. Claims and evidence

- **A statement about behaviour is backed by a listing the harness runs.** If you cannot write
  that listing, you do not yet know the statement is true.
- **A statement about the compiler cites its source or a diagnostic id**, and is re-verified when
  the pin moves.
- **Sources that are off limits:** the FreeBASIC-manual pages in `wiki/` (GFDL, other authors'
  work — never copied), and tiko's own stale documents, notably the README's older sections. The
  author's own design docs under `C:\dev\docs` may be *adapted*, never transcribed.
- **Inherited documentation is a lead, not a fact.** Much of the plan's per-chapter detail came
  from fbc-modern's documents. Two chapters in, that material has been wrong about tiko twice.
  Probe before you write.

## 9. Before a chapter is done

Mechanical, in order:

1. `tools/check-listings.sh chNN` — green on both targets.
2. `build/site.sh` — builds, and the chapter's page has no unresolved `{{#include`, no stray
   `</div>`, no literal backticks.
3. **Look at the page in a browser.** Not the markdown. The four-backtick bug, the leaked `div`
   and the unstyled code block were all invisible in the source and obvious on screen.
4. `build/pdf.sh` — the chapter typesets; callouts and listings survive the second pipeline.
5. Summary bullets cover every section. Every exercise with a solution has one, and the solutions
   pass the harness like any listing.
6. Update `book.yaml`'s status and `src/SUMMARY.md`.

## 10. Lineage

The brand plan (`C:\dev\docs\tiko-brand\README.md`) governs this, and it is worth restating
because it is easy to drift:

**tiko is a compiled, statically typed language for building fast, self-contained programs.** Not
"a modern BASIC", not "a BASIC dialect". FreeBASIC appears in Chapter 30, Appendix D and the
licences — nowhere else, and never in an opening.

When the lineage does come up, own it as a decision: the syntax comes from the most readable
family of languages ever designed for people, and everything underneath was replaced.
Keyword-delimited blocks are a deliberate trade — `end function` tells a reviewer which block just
closed — presented the way Lua and Ada present theirs, without apology.
