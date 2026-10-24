'' 300 calls: past the 256 descriptors of the DLL's temporary pool.
#foreignlib WORDS dynamic "words"
declare function DllWord cdecl lib WORDS alias "dll_word" ( byval n as long ) as string
dim as long total = 0, empties = 0
for i as long = 1 to 300
    dim as long l = len( DllWord( i mod 7 + 1 ) )
    total += l
    if l = 0 then empties += 1
next
print "total"; total
print "empty"; empties
