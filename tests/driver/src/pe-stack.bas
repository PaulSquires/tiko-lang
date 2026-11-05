'' THIS EXECUTABLE'S OWN STACK RESERVE AND COMMIT, read from its PE header: the
'' optional header's SizeOfStackReserve and SizeOfStackCommit (PE32+, offsets 72 and 80).
'' The loader sizes the main thread's stack from these, so they are what '-t' is for.
'' Used by tests/driver/pe-stack-*.test.
extern "windows"
    declare function GetModuleHandleA alias "GetModuleHandleA" ( byval modName as zstring ptr ) as any ptr
end extern

dim as ubyte ptr img = GetModuleHandleA( 0 )
dim as ubyte ptr opt = img + *cast( long ptr, img + &h3C ) + 24
print "magic=" & hex( *cast( ushort ptr, opt ) ) & ";"
print "reserve=" & *cast( ulongint ptr, opt + 72 ) & ";"
print "commit=" & *cast( ulongint ptr, opt + 80 ) & ";"
