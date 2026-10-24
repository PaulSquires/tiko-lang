'' A DLL whose export returns a STRING -- a temporary descriptor from the DLL's own pool,
'' which the host never hands back. See dll-string-results.test.
function DllWord cdecl alias "dll_word" ( byval n as long ) as string export
    return string( n, "x" )
end function
