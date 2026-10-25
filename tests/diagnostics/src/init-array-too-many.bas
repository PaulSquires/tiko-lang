'' More brace values than an array dimension holds: fbc's 65 ("Expected '}'") at lines 4,
'' 5, 6 and 11 (fbc-modern 1.20, 2026-10-25). Exactly full, short rows and an ellipsis
'' bound are fine.
dim a( 0 to 1 ) as long = { 1, 2, 3 }
dim g( 0 to 1, 0 to 1 ) as long = { { 1, 2, 3 }, { 4, 5 } }
dim h( 1 to 2, 0 to 1 ) as long = { { 1, 2 }, { 3, 4 }, { 5, 6 } }
dim ok1( 0 to 2 ) as long = { 1, 2, 3 }
dim ok2( 0 to 1, 0 to 2 ) as long = { { 1 }, { 4, 5, 6 } }
dim ok3( 0 to ... ) as long = { 1, 2, 3, 4 }
type R
    v( 0 to 1 ) as long = { 1, 2, 3 }
end type
