'' A PROCEDURE POINTER RETURNING A STRING, called as a statement and as a value.
''
'' Since every call through a pointer carries a signature (lowersig.bas, PtrCallSigIndex_),
'' this one's result was typed as an aggregate with no size -- the call site treats a
'' var-length string result as a POINTER, the signature did not -- and the emitter refused
'' the module: "a function returning an aggregate by value; the ABI pass has not run".
'' fbc's functions/ignore-result.bas was the corpus file. fbc prints ' 3 abc3  4'.
dim shared as integer calls
function fstrres( ) as string
    calls += 1
    return "abc" & calls
end function
dim as function( ) as string pf = @fstrres
pf( )
pf( )
dim as string s = pf( )
print calls; " "; s; " "; len( pf( ) )
