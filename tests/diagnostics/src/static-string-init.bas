'' TWO RULES, both of which the compiler already knew and only DECLINED for.
''
'' A VAR-LEN STRING WITH STATIC STORAGE CANNOT BE INITIALISED -- fbc error 87. A static
'' string's storage is written by the LOADER, and a var-len string is a descriptor whose
'' data has to be allocated at run time; there is nothing for an initialiser to write.
''
'' IT IS THE STORAGE THAT DECIDES, NOT THE SCOPE, and a scope test gets it backwards both
'' ways. Measured:
''
''     dim shared s as string = "foo"           error 87
''     static s as string = "foo"               error 87    inside a sub
''     var shared s = "foo"                     error 87
''     namespace ns : dim s as string = "foo"   error 87    a NAMESPACE is static storage
''     dim s as string = "foo"                  OK          at MODULE level
''     dim s as string = "foo"                  OK          inside a sub
''     dim shared z as zstring * 8 = "foo"      OK          a FIXED string is not one
''
'' AND 'delete' TAKES A POINTER -- fbc error 28, measured over an integer and a single.

namespace ns
    '' -- refused
    dim s1 as string = "foo"
end namespace

'' -- refused ------------------------------------------------------------------
dim shared s2 as string = "foo"
var shared s3 = "foo"

sub refused( )
    static s4 as string = "foo"
    dim as integer n
    delete n
end sub

'' -- accepted -----------------------------------------------------------------
dim s5 as string = "foo"
var s6 = "foo"
dim shared z as zstring * 8 = "foo"
dim shared s7 as string

sub accepted( )
    dim s8 as string = "foo"
    dim as integer ptr p
    delete p
end sub
