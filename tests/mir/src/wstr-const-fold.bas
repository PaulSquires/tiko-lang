'' 'wstr( <constant string> )' FOLDS TO A WIDE LITERAL, as fbc folds it, for every
'' constant shape and not only a bare literal. Measured, fbc:
''
''   @wstr( S )                         (uint16*)L"ab"
''   @wstr( chr( 34 ) )                 (uint16*)L"\x0022"
''   @wstr( S & chr( 65, 66 ) & "z" )   (uint16*)L"abABz"
''   @wstr( str( 12 ) & "x" )           (uint16*)L"12x"
''
'' Converted at run time instead, '@wstr( ... )' was the address of a temporary freed
'' at the end of the statement: fbx's TaskDialog footer showed garbage.
const S = "ab"
dim as const wstring ptr p1 = @wstr( S )
dim as const wstring ptr p2 = @wstr( chr( 34 ) )
dim as const wstring ptr p3 = @wstr( S & chr( 65, 66 ) & "z" )
dim as const wstring ptr p5 = @wstr( str( 12 ) & "x" )
dim as const wstring ptr p6 = @wstr( "<A HREF=" & chr( 34 ) & "u" & chr( 34 ) & ">" )
