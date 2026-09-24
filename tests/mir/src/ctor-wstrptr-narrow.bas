'' A NARROW STRING FOR A CONSTRUCTOR'S 'wstring ptr' PARAMETER IS WIDENED.
''
'' 'dim arialFontFamily as CGpFontFamily = "arial"' over 'byval pwszName as wstring ptr'
'' passed the narrow literal's bytes, and the constructor read them as UTF-16 -- garbage
'' up to the first pair of zero bytes. An ordinary call already converted. fbc passes
'' L"arial", and fb_StrToWstr for a variable or a concatenation; it prints what this file
'' prints, byte for byte -- goldenrun executes it.
type Coll
    as long x
end type
type Fam
    as long n
    declare constructor( byval pwszName as wstring ptr, byval pc as Coll ptr = 0 )
end type
constructor Fam( byval pwszName as wstring ptr, byval pc as Coll ptr = 0 )
    n = len( *pwszName )
    print *pwszName = "arial", *pwszName = "times", *pwszName = "fromvar", *pwszName = "fromvar!"
end constructor
dim a as Fam = "arial"
dim b as Fam = Fam( "times" )
dim s as string = "fromvar"
dim d as Fam = s
dim e as Fam = Fam( s & "!" )
print a.n, b.n, d.n, e.n
sub inproc( byref t as string )
    dim f as Fam = t
    print f.n
end sub
inproc( s )
