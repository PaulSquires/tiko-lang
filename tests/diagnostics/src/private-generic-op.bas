'' A private operator used from outside: a generic instance's 'let' and 'str( )' through a
'' private cast -- fbc's error 202 on the refused lines.
type G( of T )
    i as T
    declare constructor( )
    private:
    declare operator let( byref as G( of T ) )
end type
constructor G( of T )( )
end constructor
operator G( of T ).let( byref r as G( of T ) )
end operator
type S
    i as integer
    declare constructor( )
    private:
    declare operator cast( ) as string
end type
constructor S( )
end constructor
operator S.cast( ) as string
    return ""
end operator
dim as G( of long ) a, b
b = a                                               '' 202
dim sv as S
print str( sv )                                     '' 202
