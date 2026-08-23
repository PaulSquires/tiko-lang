'' 'cast( T, expr )' AND 'cptr( T, expr )' FOLD TO THEIR OPERAND in a constant. The
'' conversion does not change a compile-time INTEGER value -- narrowing is the caller's
'' business, and every use site coerces to its own type anyway.
''
'' inc/win/winerror.bi declares every COM result this way:
''
''     const S_OK = cast( HRESULT, &h00000000 )
''
'' so the constant had NO VALUE, and it was the USES that declined -- 'return S_OK',
'' 'if failed( hr )', '*ppv = 0 : return E_POINTER'. THE LINE THE COUNT POINTED AT
'' NEVER MENTIONED A CAST, which is why this hid: a survey that ranks declines by the
'' text of the line blames 'return', and fixing 'return' would have achieved nothing.
type HRESULT as long
const S_OK     = cast( HRESULT, &h00000000 )
const E_FAIL   = cast( HRESULT, &h80004005 )
const E_NOTIMP = cptr( any ptr, 0 )

'' As a RETURN value, in a COMPARISON, as a PRINT operand, and folded again inside
'' another constant expression.
function Ok( ) as HRESULT
    return S_OK
end function

function Failed( byval hr as HRESULT ) as long
    return -( hr = E_FAIL )
end function

const BOTH = S_OK + E_FAIL
dim as long r = Ok( )
dim as long f = Failed( E_FAIL )
print S_OK, E_FAIL, BOTH, r, f, E_NOTIMP
