'' 'BYREF' IS NOT A TRAILING MODIFIER. A byref result is spelled
'' 'function f( ) BYREF as T' -- the keyword sits between the parameter list and the AS --
'' and 'function f( ) as T byref' is fbc error 3, "Expected End-of-Line".
''
'' The trailing-modifier loop consumes 'static', 'const', 'export', 'alias "x"', 'lib "y"'
'' and the calling conventions without looking at them, so it swallowed this too and the
'' wrong spelling compiled clean.

'' -- refused ------------------------------------------------------------------
declare function bad1( ) as integer byref
declare function bad2( ) as string byref

'' -- accepted -----------------------------------------------------------------
dim shared as integer target_

function good1( ) byref as integer
    return target_
end function

declare function good2( ) as integer
