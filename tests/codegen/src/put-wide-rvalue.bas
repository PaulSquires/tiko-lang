dim as wstring * 8 w = wstr( "ab" )
dim as wstring ptr pw = @w
open "put-wide-rvalue.tmp" for binary as #1
put #1, , wstr( "cd" )
put #1, , w & wstr( "ef" )
put #1, , *pw
close #1
open "put-wide-rvalue.tmp" for binary as #1
dim as string b = space( lof( 1 ) )
get #1, 1, b
close #1
kill "put-wide-rvalue.tmp"
for i as long = 1 to len( b ) : print asc( b, i ); : next : print
