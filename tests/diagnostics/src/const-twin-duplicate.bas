'' A top-level CONST does not make two overloads unless both parameters are BYREF.
type T
    x as long
end type
declare sub a1 overload( byref s as const string )
declare sub a1( byval s as string )
declare sub a2 overload( byval s as const string )
declare sub a2( byref s as string )
declare sub a3 overload( byref v as const long )
declare sub a3( byval v as long )
declare sub a4 overload( byval v as const long )
declare sub a4( byref v as long )
declare sub a5 overload( byref p as long const ptr )
declare sub a5( byval p as long ptr )
declare sub a6 overload( byref t_ as const T )
declare sub a6( byval t_ as T )
declare sub a7 overload( byref s as const string, byval n as long )
declare sub a7( byval s as string, byval n as long )

'' two overloads each: both byref, or a const below the top level
declare sub k1 overload( byref s as const string )
declare sub k1( byref s as string )
declare sub k2 overload( byref v as const long )
declare sub k2( byref v as long )
declare sub k3 overload( byval p as const long ptr )
declare sub k3( byval p as long ptr )
declare sub k4 overload( byref p as const long ptr )
declare sub k4( byval p as long ptr )
declare sub k5 overload( byref t_ as const T )
declare sub k5( byref t_ as T )
declare sub k6 overload( byref s as const string, byval n as long )
declare sub k6( byval s as string, byval n as integer )
