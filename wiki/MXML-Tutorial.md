[Home](Home) › [Using C Libraries](Using-C-Libraries-Tutorial) › **Mini-XML**

# Mini-XML Tutorial

> 📘 **Start with:** [Vendor Packages](Vendor-Packages), what a vendor package is and how `link static` and `link dynamic` work.
>
> Measured with Mini-XML 4.0.6 (built from master past it) and tiko, on Windows, Linux and macOS.

[Mini-XML](https://www.msweet.org/mxml/) is a small XML library in C: it loads a document into a tree of nodes, finds, walks and changes them, builds new documents and saves them, and can stream a document through a callback without keeping it. It needs no other library, and it does not expand DTD entities, so a document cannot make it build an entity bomb.

tiko ships it as a [vendor package](Vendor-Packages). One line gives a program Mini-XML's whole C API and links the library:

```freebasic
#import "vendor/mxml"
```

There is nothing to download, no header to translate, no `#foreignlib` and nothing on the command line, on Windows, Linux and macOS. The names are the ones [Mini-XML's documentation](https://www.msweet.org/mxml/mxml.html) uses -- `mxmlLoadString`, `mxmlFindElement`, `mxmlElementGetAttr`, `mxmlNewElement`, `mxmlDelete`. More programs are in the toolchain's `examples/mxml`.

---

## 1. Reading

The program loads a document from a string and prints each entry's attribute and the text of two of its elements:

```freebasic
'' Reading XML with Mini-XML, one of the vendor packages.
#import "vendor/mxml"

dim as string feed = _
    !"<?xml version=\"1.0\"?>\n" & _
    !"<feed>\n" & _
    !"  <entry id=\"1\"><title>Hello, XML</title><views>120</views></entry>\n" & _
    !"  <entry id=\"2\"><title>Café notes</title><views>45</views></entry>\n" & _
    !"</feed>\n"

'' Each element's text as one string, spaces and all.
dim as mxml_options_t ptr opts = mxmlOptionsNew( )
mxmlOptionsSetTypeValue( opts, MXML_TYPE_OPAQUE )

dim as mxml_node_t ptr xml = mxmlLoadString( nullptr, opts, feed )
if xml = nullptr then
    print "not XML"
    end 1
end if

'' Every <entry>, in order: each search starts after the last one found.
dim as mxml_node_t ptr e = mxmlFindElement( xml, xml, "entry", _
    nullptr, nullptr, MXML_DESCEND_ALL )
while e
    dim as ustring title = *mxmlGetOpaque( mxmlFindPath( e, "title" ) )
    dim as int32 views = valint( *mxmlGetOpaque( mxmlFindPath( e, "views" ) ) )
    print *mxmlElementGetAttr( e, "id" ) & ": " & title & " (" & views & " views)"
    e = mxmlFindElement( e, xml, "entry", nullptr, nullptr, MXML_DESCEND_ALL )
wend

mxmlDelete( xml )        ' the whole tree, once
mxmlOptionsDelete( opts )
```

```
1: Hello, XML (120 views)
2: Café notes (45 views)
```

- **`MXML_TYPE_OPAQUE`** makes each element's text one string. Without it Mini-XML splits text into `MXML_TYPE_TEXT` nodes, one per word.
- **The root is the `<?xml ...?>` line** when there is one: a directive node, with the document's element as its child. Without it the root is that element.
- **A search starts after the node it is given**: `mxmlFindElement( node, top, ... )` never returns `node` itself, which is what lets the loop pass the last entry back in. From the root `<feed>` of a document without `<?xml?>`, a search for `"feed"` finds nothing.
- **`mxmlFindPath`** follows element names (`"*"` is any one level), and when the element it reaches holds a value, returns the value node -- so `mxmlGetOpaque` of it is the text.
- **Strings Mini-XML returns belong to the tree.** `*p` copies one into a `ustring`; text is UTF-8, as a `ustring` is.
- **`mxmlDelete` on the root frees everything**, once. A missing element, attribute or path is a null pointer, and so is a broken document: its error goes to an error callback (`mxmlOptionsSetErrorCallback`), or to stderr without one.

## 2. Writing

The program builds a document node by node and saves it into a tiko string:

```freebasic
'' Writing XML with Mini-XML.
#import "vendor/mxml"

'' mxmlSaveIO hands the text over in pieces; this appends each one
'' to the tiko string 'cbdata' points at.
function AppendText cdecl( byval cbdata as any ptr, byval bytes as any ptr, _
        byval count as uinteger ) as uinteger
    dim as string piece = space( count )
    memcpy( strptr( piece ), bytes, count )
    *cast( string ptr, cbdata ) &= piece
    return count
end function

'' A line break after every close tag, and after an open tag whose
'' first child is an element.
function Breaks cdecl( byval cbdata as any ptr, byval node as mxml_node_t ptr, _
        byval when as mxml_ws_t ) as const zstring ptr
    if when = MXML_WS_AFTER_CLOSE then return @!"\n"
    if when = MXML_WS_AFTER_OPEN andalso _
       mxmlGetType( mxmlGetFirstChild( node ) ) = MXML_TYPE_ELEMENT then
        return @!"\n"
    end if
    return nullptr
end function

dim as mxml_node_t ptr xml = mxmlNewXML( "1.0" )
dim as mxml_node_t ptr people = mxmlNewElement( xml, "people" )
dim as string names(0 to 1) = { "Ana & Bo", "Zoë" }
for i as int32 = 0 to 1
    dim as mxml_node_t ptr p = mxmlNewElement( people, "person" )
    mxmlElementSetAttrf( p, "n", "%d", i + 1 )     ' C's printf
    mxmlNewOpaque( p, names(i) )                    ' escaped when saved
next

dim as mxml_options_t ptr opts = mxmlOptionsNew( )
mxmlOptionsSetWhitespaceCallback( opts, @Breaks, nullptr )
dim as string text
mxmlSaveIO( xml, opts, @AppendText, @text )
print text;

mxmlOptionsDelete( opts )
mxmlDelete( xml )
```

```
<?xml version="1.0" encoding="utf-8"?>
<people>
<person n="1">Ana &amp; Bo</person>
<person n="2">Zoë</person>
</people>
```

- **Every `mxmlNew...` takes the parent first.** `mxmlNewElement( nullptr, ... )` makes a node with none, which `mxmlAdd` puts in place later.
- **Mini-XML adds no whitespace of its own.** A whitespace callback says what goes before and after each tag: `MXML_WS_BEFORE_OPEN`, `MXML_WS_AFTER_OPEN`, `MXML_WS_BEFORE_CLOSE`, `MXML_WS_AFTER_CLOSE`. The strings it returns must outlive the call: a literal, or a `static`.
- **Three ways to save into memory:** `mxmlSaveIO` with a callback, as here, into a string of any length; `mxmlSaveAllocString`, whose text is `malloc`'d and yours to `free( )`; and `mxmlSaveString` into a buffer of yours, which gives 0 when the document does not fit -- it does not say how much room was needed. To a file: `mxmlSaveFilename`.
- **The `...f` routines are C's `printf`**: an `int32` for `%d`, a `float64` for `%g`, and for `%s` a `zstring ptr` -- `strptr( s )`, never the string.
- **Callbacks are `cdecl`**, and receive back the `cbdata` pointer they were registered with.

## 3. Streaming

With a SAX callback Mini-XML hands over each node as it reads it -- an element as it opens and as it closes, and each value -- and releases it afterwards, so a document of any size goes through in the memory of a node or two:

```freebasic
'' Streaming XML with Mini-XML's SAX callback: nothing is kept, so a
'' document of any size goes through in the memory of one node.
#import "vendor/mxml"

type Totals
    orders as int32
    amount as float64
    inAmount as boolean
end type

function OnNode cdecl( byval cbdata as any ptr, byval node as mxml_node_t ptr, _
        byval ev as mxml_sax_event_t ) as boolean
    dim as Totals ptr t = cbdata
    select case ev
    case MXML_SAX_EVENT_ELEMENT_OPEN
        if *mxmlGetElement( node ) = "order" then t->orders += 1
        t->inAmount = ( *mxmlGetElement( node ) = "amount" )
    case MXML_SAX_EVENT_DATA
        if t->inAmount then t->amount += val( *mxmlGetOpaque( node ) )
    case MXML_SAX_EVENT_ELEMENT_CLOSE
        t->inAmount = false
    end select
    return true          ' false stops the load
end function

dim as string doc = "<orders>"
for i as int32 = 1 to 10000
    doc &= "<order id=""" & i & """><amount>" & ( i mod 7 ) & ".50</amount></order>"
next
doc &= "</orders>"

dim as Totals t
dim as mxml_options_t ptr opts = mxmlOptionsNew( )
mxmlOptionsSetTypeValue( opts, MXML_TYPE_OPAQUE )
mxmlOptionsSetSAXCallback( opts, @OnNode, @t )
dim as mxml_node_t ptr xml = mxmlLoadString( nullptr, opts, doc )
print len( doc ) & " bytes, " & t.orders & " orders, total " & t.amount
print "tree kept: " & iif( xml, "yes", "no" )
mxmlOptionsDelete( opts )
```

```
458911 bytes, 10000 orders, total 34998
tree kept: no
```

The root is released at its close tag like everything else, so the load gives back nothing. **To keep part of the document**, `mxmlRetain` the element when it opens and every node read inside it, then `mxmlRemove` it from its parent at its close tag: deleting an element frees everything under it, whatever its retain count, so a part left inside its parent is freed when the parent closes. The part is then the program's, to `mxmlDelete`. `examples/mxml/06-callbacks` does this.

## 4. More programs

The toolchain's `examples/mxml`, each built with `tiko <name>.tiko`:

| Folder | Shows |
| --- | --- |
| `01-parse` | find elements by name, by attribute and by path; attributes and text; a broken document |
| `02-create` | every kind of node; an indenting whitespace callback; saving into a string, a buffer and allocated memory |
| `03-walk` | every node of a document, recursively and with `mxmlWalkNext`; `walk FILE.xml` walks a file |
| `04-modify` | set and clear attributes, rename, replace text, insert, move, detach and delete; an index by attribute |
| `05-files` | save and load a file; UTF-8 text; removing the whitespace a load keeps; missing and broken files |
| `06-callbacks` | a type callback (numbers as numbers), an entity callback, and SAX keeping one part |

## 5. In a project

A [`tiko build`](Category-Tiko-Build) project needs nothing in its `tiko.toml` for Mini-XML: the import says it all. `tiko build`'s `copy_to` copies the shared library along with the program.

## 6. Shipping the program

- **Linked dynamically** (the default): ship the library the build put beside the program -- `mxml.dll`, `mxml_linux_x86_64.so` or `mxml_macos_arm64.dylib`.
- **Linked statically** (`#import "vendor/mxml" link static`): the program alone.

Mini-XML is under the Apache License 2.0: a program you distribute with Mini-XML in it, linked either way, gives its recipients a copy of the licence and of Mini-XML's NOTICE. Both are in `pkg/vendor/mxml/LICENSE` in the toolchain.

## 7. Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| every word of an element's text is a node of its own | the load made `MXML_TYPE_TEXT` nodes; set `mxmlOptionsSetTypeValue( opts, MXML_TYPE_OPAQUE )` |
| `mxmlFindElement` gives null for the document's own root element | a search starts after the node it is given; the root is that node |
| a walk over children prints blank text nodes | the line breaks and indentation between tags are kept as text nodes; skip or delete the blank ones (`examples/mxml/05-files`) |
| every line is doubled when a loaded document is saved | those kept whitespace nodes, plus the whitespace callback's own; delete the blank nodes after loading |
| `mxmlLoadFilename` gives null and the error callback is never called | the file could not be opened: Mini-XML calls the callback only for what it reads |
| a file saved on Windows has CR LF line ends | `mxmlSaveFilename` uses C's `fopen` in text mode; `mxmlLoadFilename` reads either |
| a loop `for i = 0 to mxmlElementGetAttrCount( node ) - 1` never ends | the count is an unsigned `size_t`, and `0 - 1` of one is huge; count in an `int64` |
| a node kept from a SAX callback is empty, or the program crashes after the load | retain every node inside it too, and `mxmlRemove` it from its parent at its close tag (section 3) |
| `TKO0600: 'append' is already declared` on a callback | `Append` is a tiko built-in; name the function something else |
| the program exits at once with `-1073741515` (Windows) | `mxml.dll` is not beside the program |

---

**Next:** [SQLite](SQLite-Tutorial) · [PCRE2](PCRE2-Tutorial) · [Vendor Packages](Vendor-Packages)

[Home](Home)
