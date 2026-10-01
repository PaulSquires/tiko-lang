'' Collection initialisers, a tiko extension: a brace list on a type that needs
'' construction calls its Add, PushBack or Push once per element, in order.
#include once "containers.bi"

'' A user type with Add -- it needs construction because of its dynamic array.
type Bag
    as string items( any )
    declare sub Add( byref s as string )
end type
sub Bag.Add( byref s as string )
    redim preserve items( ubound( items ) + 1 )
    items( ubound( items ) ) = s
end sub

'' PushBack only, with a written constructor that runs FIRST.
type Tally
    as long n
    declare constructor( )
    declare sub PushBack( byval v as long )
end type
constructor Tally( )
    n = 100
end constructor
sub Tally.PushBack( byval v as long )
    n = n * 2 + v
end sub

'' Plain data with a Push method: needs no construction, so it is not a collection, and its
'' initialiser stays a field list.
type Pod
    as long a, b
    declare sub Push( byval v as long )
end type
sub Pod.Push( byval v as long )
    a = -1
end sub

'' SHARED and NAMESPACE: filled in the module initialiser, before the first statement, and
'' read here from a procedure. A constant is fine in the list; a frame variable is not.
const K = 40
dim shared sa as FB.Array( of integer ) = { 1, 2, 3 }
dim shared sm as FB.Map( of ustring, long ) = { {"k", 7}, {"j", 8} }
dim shared sk as FB.LinkedList( of long ) = { K, K + 1 }
namespace NS
    dim nv as FB.Array( of ustring ) = { "p", "q" }
end namespace
sub ShowShared( )
    print "shared"; sa.Count( ); sa[2]; sm.Count( ); sm["j"]; sk.Count( ); NS.nv.Count( ); " "; NS.nv[1]
end sub

'' STATIC: filled once, inside the run-once guard.
sub Twice( )
    static s as FB.Array( of long ) = { 1, 2 }
    s.Push( 9 )
    print "static"; s.Count( )
end sub

sub InProc( byval k as long )
    dim x as integer = 5
    dim a as FB.Array( of integer ) = { x, x * 2, k + 1 }
    for i as integer = 0 to a.Count( ) - 1
        print a[i];
    next
    print
    if k > 0 then
        dim o as FB.OrderedSet( of long ) = { 3, 1, 2, 3 }
        print "oset"; o.Count( )
    end if
end sub

ShowShared( )

dim a as FB.Array( of integer ) = { 10, 20, 30 }
print a.Count( ); ":";
for i as integer = 0 to a.Count( ) - 1
    print a[i];
next
print

dim l as FB.LinkedList( of ustring ) = { "x", "y", "z" }
for each s as ustring in l
    print s;
next
print

'' Nested braces are the arguments of one call: m.Add( "a", 1 ) -- "a" converted to ustring.
dim m as FB.Map( of ustring, integer ) = { {"a", 1}, {"b", 2} }
print m.Count( ); m["a"]; m["b"]

dim st as FB.Set( of ustring ) = { "a", "b", "a" }
print "set"; st.Count( )
dim om as FB.OrderedMap( of long, ustring ) = { {2, "two"}, {1, "one"} }
print "omap"; om.Count( )

dim e as FB.Array( of integer ) = { }
print "empty"; e.Count( )

dim as FB.Array( of integer ) p = { 1 }, q = { 2, 3 }
print p.Count( ); q.Count( ); q[1]

dim bg as Bag = { "p", "q" & "r" }
print ubound( bg.items ); " "; bg.items( 0 ); bg.items( 1 )
dim ty as Tally = { 1, 2 }
print "tally"; ty.n
dim pd as Pod = ( 7, 8 )
print "pod"; pd.a; pd.b

Twice( )
Twice( )
InProc( 4 )
