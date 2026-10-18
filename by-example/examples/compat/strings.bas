'' string is the legacy type: a run of bytes. ustring is text: a run
'' of characters. The same literal, with one accented letter:
dim as string bytes = "café"
dim as ustring text = "café"

print "string:  "; bytes; ", len"; len( bytes )
print "ustring: "; text; ", len"; len( text )

'' ucase knows the accented letter only as text.
print "ucase:   "; ucase( bytes ); " / "; ucase( text )

'' asc reads a byte from a string, a code point from a ustring.
print "asc 4:  "; asc( bytes, 4 ); " /"; asc( text, 4 )
