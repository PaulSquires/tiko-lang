'' STRPTR OF A STRING ARRAY ELEMENT IS THE ELEMENT'S OWN BUFFER.
''
'' An element parses as a call, and the zstring-data path took every call for an
'' rvalue: it copied the element into a temporary, returned the temporary's buffer and
'' deleted it at the end of the statement. The pointer then read whatever the heap put
'' there next. Measured, after some churn: '-resource-dir=...' came back '####...', and
'' all four pointers compared unequal to the element's strptr. fbc prints '-1' four
'' times and the original texts. tiko's C importer builds libclang's argv this way.
function DataOf( av() as string, byval i as long ) as zstring ptr
    return strptr( av( i ) )
end function

dim as string av( 0 to 3 )
av( 0 ) = "-x"
av( 1 ) = "--target=" & "x86_64-pc-windows-msvc"
av( 2 ) = "-resource-dir=" & "C:\Program Files\LLVM\lib\clang\21"
av( 3 ) = "-std=c11"
dim as zstring ptr argv( 0 to 3 )
for i as long = 0 to 3
    argv( i ) = DataOf( av(), i )
next
dim as string junk( 0 to 50 )
for i as long = 0 to 50
    junk( i ) = string( 40 + i, asc( "#" ) )
next
for i as long = 0 to 3
    print i; " ["; *argv( i ); "] same="; (argv( i ) = strptr( av( i ) ))
next
