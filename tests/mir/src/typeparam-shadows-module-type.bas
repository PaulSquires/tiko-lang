'' A GENERIC'S TYPE PARAMETER SHADOWS A MODULE-LEVEL TYPE OF THE SAME NAME -- in the
'' TEMPLATE as well as in each instance.
''
'' An instance binds its parameters, and that binding was always asked first. The
'' template binds nothing, so 'as T' there went on to the ordinary lookup -- and a
'' program's own 'type T' is exactly what that finds. The template was then checked
'' with its parameter standing for the PROGRAM'S T, and the first operator T lacks was
'' an error in code nobody had called:
''
''     function IndexOf( of T )( ..., byref v as T )    fb/array.bi
''         if( a.items( k ) = v ) then                   TKO0720, no operator =
''
'' Any program that included containers.bi and declared a 'type T' got thirteen of
'' those, out of fb/array.bi, set.bi, orderedset.bi and sort.bi. fbc compiles it clean:
'' the parameter is the innermost name.
''
'' A LAMBDA INSIDE A GENERIC is a template too, and is hoisted to module level, where
'' no enclosing generic is on its scope chain -- fb/sort.bi's comparison lambda is
'' 'function( byref x as T, byref y as T ) as boolean : return x < y'. It now carries
'' the enclosing generic's parameter list from the parser.
''
'' Each shape below is one of those headers' spellings, written out here because a mir
'' test has no include path.
''
'' fbc prints, one per line:
''     truefalse   42   truefalse 4   truefalse   7 4
type T
    dim as long x
end type

'' A generic procedure -- IndexOf's shape. Never called, as in a file that merely
'' includes fb/array.bi.
function Uncalled( of T )( byref v as T, byref w as T ) as boolean
    return v = w
end function

'' ...and called, with T = LONG.
function Eq( of T )( byref v as T, byref w as T ) as boolean
    return v = w
end function
print Eq( 3, 3 ); Eq( 3, 4 )

'' The parameter as a local's type.
function Twice( of T )( byval v as T ) as T
    dim as T r = v + v
    return r
end function
print Twice( 21 )

'' A method of a generic TYPE -- set.bi's shape.
type Box( of T )
    dim as T v
    declare function Same( byref o as T ) as boolean
end type
function Box( of T ).Same( byref o as T ) as boolean
    return this.v = o
end function
dim as Box( of long ) b
b.v = 5
print b.Same( 5 ); b.Same( 6 ); sizeof( b )

'' A lambda inside a generic -- sort.bi's shape.
function Lt( of T )( byref a as T, byref c as T ) as boolean
    dim as function( byref as T, byref as T ) as boolean less = _
        function( byref x as T, byref y as T ) as boolean
            return x < y
        end function
    return less( a, c )
end function
print Lt( 1, 2 ); Lt( 2, 1 )

'' ...and a template that is never called holds a lambda too.
sub UncalledLambda( of T )( byref a as T )
    dim as function( byref as T, byref as T ) as boolean less = _
        function( byref x as T, byref y as T ) as boolean
            return x < y
        end function
end sub

'' Outside every generic, T is still the program's own T.
dim as T u
u.x = 7
print u.x; sizeof( u )
