'' A FIXED-LENGTH NARROW STRING CONVERTED THROUGH A 'byref as string' CONSTRUCTOR.
''
'' 'zstring * N' is an ARRAY of a character builtin, so IsStringType says no to it, and
'' LowerConvCtorInit_'s byref arm took its ADDRESS -- the constructor then read an
'' FBSTRING descriptor out of the characters. tiko-editor's theme writer is
''
''     function Theme_RoleName( byval idx as long ) as DWSTRING
''         return gThemeRoleDef(idx).name        '' name is 'zstring * 32'
''
'' and the DWSTRING built from it took its buffer pointer from the text 'role.bac', so
'' saving a theme died at 0xC0000005. With a small UDT the same IR answers quietly
'' wrong instead -- length 0 and an empty string -- which is what this file measures.
''
'' Measured, fbc builds a temporary descriptor and passes THAT:
''
''     memset( &TMP$6, 0, 24ll );
''     fb_StrAssign( (void*)&TMP$6, -1ll, (void*)GZ$, 32ll, 0 );
''     _ZN1UC1ER8FBSTRINGj( tmp$5, &TMP$6, 0u );
''     fb_StrAssign( (void*)GZ$, 32ll, (void*)&TMP$6, -1ll, 0 );
''     fb_StrDelete( (FBSTRING*)&TMP$6 );
''
'' The COPY-BACK is not emitted -- see ByvalStrTemp_'s own header, which records that
'' gap for every one of its callers. No assertion here depends on it.
''
'' The constructor carries a DEFAULTED second parameter because DWSTRING's does:
'' 'constructor( byref ansiStr as string, byval nCodePage as uint = 0 )' is the only
'' narrow constructor it has, so that is the one a fixed string converts through.
type U
    as long n
    as zstring * 40 txt
    declare constructor( )
    declare constructor( byref s as string, byval cp as ulong = 0 )
    declare destructor( )
end type
constructor U( ) : n = 0 : txt = "" : end constructor
constructor U( byref s as string, byval cp as ulong = 0 ) : n = len( s ) : txt = s : end constructor
destructor U( ) : end destructor

dim shared gz as zstring * 32
dim shared gf as string * 16

'' A LITERAL always worked -- it is a string to Check -- so a test carrying only that
'' one would pass on the broken compiler.
function FromLit( ) as U
    return "literal"
end function
function FromGlobalZ( ) as U
    return gz
end function
function FromLocalZ( ) as U
    dim as zstring * 32 z = "local-z"
    return z
end function
'' ...AND A 'string * N', the other fixed flavour StrArgOwnDescriptor_ names.
function FromFixedStr( ) as U
    return gf
end function

gz = "global-z"
gf = "fixed-s"
dim as U a = FromLit( )      : print "lit   "; a.n; " ["; a.txt; "]"
dim as U b = FromGlobalZ( )  : print "gz    "; b.n; " ["; b.txt; "]"
dim as U d = FromLocalZ( )   : print "localz"; d.n; " ["; d.txt; "]"
dim as U e = FromFixedStr( ) : print "fixed "; e.n; " ["; e.txt; "]"
