'' A STRING CONSTANT whose initialiser is 'str' or 'chr'.
''
'' ConstVal carries a longint and nothing else, so the constant evaluator has no string
'' channel at all and a string constant is folded by its own walk over the initialiser.
'' That walk knew literals, concatenation and 'wstr', so 'const F = str( 16 )' had no
'' text -- and a constant with no text declines at every USE of it, not at the
'' declaration, which is where the trail goes cold.
''
'' THE TWO INTRINSICS ARE THE TWO FBC FOLDS, and that was established by asking fbc to
'' accept each one as a constant initialiser rather than by reasoning about which could
'' be folded:
''
''     const a = str( 16 )        "16"      accepted
''     const g = str( 1.5 )       "1.5"
''     const k = str( 1e-7 )      "1e-07"
''     const e = chr( 65 )        "A"
''     const f = hex( 255 )                 fbc error 11, expected constant
''     const c = lcase( "AbC" )             fbc error 11
''     const h = trim( "  x  " )            fbc error 11
''
'' So hex, oct, bin, lcase, ucase, left, right, mid and trim are NOT folded: folding
'' them would accept a program fbc refuses.
''
'' A FLOAT ARGUMENT RENDERS THROUGH StrOfDouble -- the sixteen-significant-digit
'' expansion check-str gates against fbc's own STR( ) -- and not through the integer
'' folder, which would answer "1" for 1.5.
const A_ = str( 16 )
const B_ = str( -3 )
const C_ = chr( 65 )
const D_ = str( 1.5 )
const E_ = str( 1e-7 )
const F_ = "x" & str( 7 ) & chr( 90 )

sub s1( )
    dim as string s
    s = A_ : print s
    s = B_ : print s
    s = C_ : print s
    s = D_ : print s
    s = E_ : print s
    s = F_ : print s
end sub

s1( )
