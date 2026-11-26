# Mini-XML examples

Mini-XML's C interface from tiko, through `vendor/mxml`, which comes with the toolchain. Each
example is one `.tiko` program, built on its own with `tiko <name>.tiko`.

| Folder | Shows |
| --- | --- |
| `01-parse` | load a document from a string; find elements by name, by attribute and by path; read attributes and text; report a broken document |
| `02-create` | build a document node by node -- elements, attributes, text, numbers, a comment, CDATA; indent it with a whitespace callback; save it into a tiko string, a buffer, and allocated memory |
| `03-walk` | every node of any document: a recursive walk and `mxmlWalkNext`; `walk FILE.xml` walks a file |
| `04-modify` | set and clear attributes, rename, replace text, insert, move, detach and delete elements; an index of elements by attribute |
| `05-files` | save and load a file; UTF-8 text; the whitespace a load keeps; a missing and a broken file |
| `06-callbacks` | a type callback (numbers as numbers), an entity callback, and SAX streaming that keeps one part of the document |

## Things to know

- **Load with `MXML_TYPE_OPAQUE`.** `mxmlOptionsSetTypeValue( opts, MXML_TYPE_OPAQUE )` makes an
  element's text one string. Without it, text is split into `MXML_TYPE_TEXT` nodes, one per
  word.
- **The root is the `<?xml ...?>` line** when the document has one -- a directive node, whose
  child is the document's element. Without it, the root is that element.
- **A search starts after the node it is given.** `mxmlFindElement( node, top, ... )` and
  `mxmlWalkNext` never return `node` itself: looking for `"tasks"` from the root `<tasks>` gives
  null.
- **A load keeps the whitespace between tags** as text nodes of their own. The `Find` routines
  and `mxmlFindPath` step over them; a walk over children sees them (`03-walk`, `05-files`).
- **A tree is freed once, from its root**, with `mxmlDelete`; deleting a node frees everything
  under it and takes it out of its parent. Strings Mini-XML returns belong to the tree: copy
  them (`*p` into a `ustring`) before it goes.
- **Saving.** `mxmlSaveAllocString`'s text is `malloc`'d, yours to `free( )`. `mxmlSaveString`
  fills your buffer and gives 0 when the document does not fit. `mxmlSaveIO` with a callback
  that appends saves into a tiko `string` of any length (`02-create`). Mini-XML adds no
  indentation of its own: a whitespace callback does.
- **Files go through C's `fopen` in text mode**: on Windows, lines are saved ending CR LF. A file
  that cannot be opened gives null without calling the error callback.
- **The `...f` routines are C's `printf`.** A `%s` argument is a `zstring ptr` -- `strptr( s )` --
  never the string itself.
- **In SAX, keeping a part needs three steps** (`06-callbacks`): `mxmlRetain` the element and
  every node read inside it, then `mxmlRemove` it from its parent at its close tag -- deleting an
  element frees everything under it, whatever its retain count.
- **A size_t is unsigned.** `mxmlElementGetAttrCount( node ) - 1` of an element with no attributes
  is huge: count in an `int64` (`03-walk`).

## Dynamic or static

Every example imports Mini-XML with

```
#import "vendor/mxml" link dynamic
```

which links the shared library and copies it beside the program -- `mxml.dll` on Windows,
`mxml_linux_x86_64.so` on Linux, `mxml_macos_arm64.dylib` on macOS, where the program finds it
beside itself. Change `dynamic` to `static` and Mini-XML is built into the program instead,
with nothing to copy.

These examples are Apache-2.0-licensed, as Mini-XML is.
