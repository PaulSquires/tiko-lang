[Home](Home) › [Tutorials](Category-Tutorials) › **libxml2**

# libxml2

De-facto standard library for accessing xml files.

 Website: http://xmlsoft.org/  
 Platforms supported: Win32, Linux  
 Headers to include: libxml/\*.bi  
 Header version: 2.6.17  
 Examples: in examples/xml/

Example

```freebasic
#include Once "libxml/xmlreader.bi"

#define NULL 0

Dim As String filename = Command(1)

If( Len( filename ) = 0 ) Then

    Print "Usage: libxml filename"

    End 1

End If

Dim As xmlTextReaderPtr reader = xmlReaderForFile( filename, NULL, 0 )

If (reader = NULL) Then

    Print "Unable to open "; filename

    End 1

End If

Dim As Integer ret = xmlTextReaderRead( reader )

Do While( ret = 1 )

    Dim As Const ZString Ptr constname = xmlTextReaderConstName( reader )

    Dim As Const ZString Ptr value = xmlTextReaderConstValue( reader )

    Print xmlTextReaderDepth( reader ); _

        xmlTextReaderNodeType( reader ); _

        " "; *constname; _

        xmlTextReaderIsEmptyElement(reader); _

        xmlTextReaderHasValue( reader ); _

        *value

    ret = xmlTextReaderRead( reader )

Loop

xmlFreeTextReader( reader )

If( ret <> 0 ) Then

    Print "failed to parse: "; filename

End If

xmlCleanupParser( )

xmlMemoryDump()
```

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
