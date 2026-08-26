'' A 'string * N' ARGUMENT.
''
'' 'string * N' is an ARRAY of TY_FIXSTR and 'ustring * N' one of TY_FIXUSTR, and
'' neither is a string as far as the conversion table was concerned: every one scored
'' "impossible" against a plain 'string' parameter. That is not a diagnostic -- the
'' callee still binds, so the call comes out with a VOID result and whatever consumed
'' it declines. functions/temp-strings.bas lost twenty statements to it, one per row
'' that passed the file's 'f as string * 31'.
''
'' Measured: offered { byval string, byval zstring ptr, byval wstring ptr }, a
'' 'string * 31' argument takes the STRING overload -- _Z1G8FBSTRING -- and a
'' 'zstring * 31' takes _Z1GPc. The marshalling was already right: a temp descriptor,
'' fb_StrAssign with the source length &h8000000000000000 or 31, and fb_StrDelete after
'' the call. Only the ranking said no.
''
'' Run under fbc this prints ' 1 2 1'.

function g overload( byval s as string ) as integer : return 1 : end function
function g overload( byval p as zstring ptr ) as integer : return 2 : end function

dim f as string * 31 = "abc"
dim z as zstring * 31 = "abc"
dim uu as ustring * 8

function h( byval s as string ) as integer : return 1 : end function

print g( f ); g( z ); h( f )
