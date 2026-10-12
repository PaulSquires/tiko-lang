'' ucase-parity.bas -- ustr_casetable.o, asked about EVERY code unit.
''
'' This is the test that makes the generation method irrelevant. The table in
'' src/ustr/casetable.tiko was produced by calling fbc's own fb_hUStrToUpper and
'' fb_hUStrToLower once per BMP code unit and run-length encoding the result; if
'' that process went wrong ANYWHERE, this file finds it, because it re-asks all
'' 131,072 questions and compares the answers against the stock runtime.
''
'' A CHECKSUM RATHER THAN 131,072 LINES -- but not a checksum ALONE. A bare hash
'' says "different" without saying where, so the counts are printed too (a wrong
'' run boundary usually moves them) and then the individual mappings that
'' actually distinguish a real Unicode table from a plausible fake.
extern "c"
    declare function pUp alias "fb_hUStrToUpper" ( byval c as ushort ) as ushort
    declare function pLo alias "fb_hUStrToLower" ( byval c as ushort ) as ushort
end extern

dim as ulongint sumU = 0, sumL = 0
dim as integer nU = 0, nL = 0

'' Every unit, both directions. The checksum is position-dependent, so a mapping
'' landing on the right VALUE at the wrong CODE POINT still shows up.
for c as integer = 0 to 65535
    dim as ulongint u = pUp( c ), l = pLo( c )
    if( u <> c ) then nU += 1
    if( l <> c ) then nL += 1
    sumU = sumU * 31 + u + c
    sumL = sumL * 31 + l + c
next

print "upper: mapped="; nU; " sum="; hex$( sumU )
print "lower: mapped="; nL; " sum="; hex$( sumL )

'' The specific cases. Each is here because a wrong implementation passes the
'' others: ASCII alone passes an ASCII fold; the Latin-1 block passes a naive
'' +-32; U+00FF -> U+0178 is a 121 delta that no arithmetic rule produces; the
'' Turkish dotless i maps to plain I under the SIMPLE (locale-free) mapping, and
'' a locale-aware towupper on a Turkish locale would not.
dim as integer probe(0 to 15) = { &h0061, &h007A, &h00E9, &h00FF, &h0131, &h00DF, _
                                  &h03B1, &h03C2, &h0430, &h04CF, &h1E9E, &h2170, _
                                  &hD800, &hDFFF, &hFF41, &h0000 }
for i as integer = 0 to 15
    dim as integer c = probe(i)
    print "U+"; hex$( c, 4 ); "  up="; hex$( pUp( c ), 4 ); "  lo="; hex$( pLo( c ), 4 )
next

'' Round-trip stability: upper(upper(c)) must equal upper(c) for every unit, or
'' the table contains a chain and a second UCASE would keep changing the text.
dim as integer unstable = 0
for c as integer = 0 to 65535
    if( pUp( pUp( c ) ) <> pUp( c ) ) then unstable += 1
    if( pLo( pLo( c ) ) <> pLo( c ) ) then unstable += 1
next
print "non-idempotent mappings = "; unstable
