' A STRING CONSTANT OVER A UNICODE-ESCAPED LITERAL, read into a USTRING: one character
' per escape, as the literal itself gives. tiko stored the six characters of the spelling.
const GLYPH = !"\uE73A"
const MIXED = !"a\u00E9\n"
const RAWESC = !""
const ALIAS_ = GLYPH

type Box
    s as ustring
end type

sub Show( byref tag as string, byref u as ustring )
    print tag; len( u ); " "; hex( asc( u ) ); " "; hex( asc( u, len( u ) ) )
end sub

dim as ustring a = GLYPH
Show( "dim", a )
dim as ustring b
b = GLYPH
Show( "assign", b )
dim as Box ptr p = new Box
p->s = GLYPH
Show( "field", p->s )
delete p
dim as ustring m = MIXED
Show( "mixed", m )
dim as ustring r = RAWESC
Show( "raw", r )
dim as ustring al = ALIAS_
Show( "alias", al )
dim as ustring lit = !"\uE73A"
Show( "literal", lit )
dim as wstring * 8 w = GLYPH
print "wstring"; len( w ); " "; hex( asc( w ) )
