'' '#UNDEF' OF A DECLARED SYMBOL, not a macro. fbc keeps both in one table and '#undef'
'' removes the first entry its lookup finds, from that line on. fbc-modern prints:
''
''    after: 457 | before: 123 | h:str | local: 2 | global: 1 | type: 7 | ns: 10 | ns2: 20
''
'' tiko kept every symbol: the second f1 was a duplicate, 'h( "x" )' still saw both
'' overloads, and a second namespace N reopened the first. crt/string.bi's '#undef
'' strstr' after shlwapi.bi's StrStr is the real-world case -- every call ambiguous.

function f1( ) as integer
    return 123
end function

'' Written BEFORE the '#undef', run after it: still the first f1.
private sub before_( )
    print "before:"; f1( )
end sub

#undef f1

function f1 alias "f1b"( byval k as integer ) as integer
    return 456 + k
end function

print "after:"; f1( 1 )
before_( )

'' One '#undef' removes the FIRST overload and leaves the rest.
function h overload( byval i as integer ) as string
    return "int"
end function
function h( byref s as string ) as string
    return "str"
end function
#undef h
print "h:"; h( "x" )

'' A local over a global: the local goes, the global shows through.
dim shared x as integer = 1
sub s( )
    dim x as integer = 2
    print "local:"; x
    #undef x
    print "global:"; x
end sub
s( )

'' A TYPE and a VARIABLE of one name: the one declared later goes first.
type FOO
    as integer a
end type
dim shared FOO as integer = 3
#undef FOO
dim as FOO v
v.a = 7
print "type:"; v.a

'' A namespace redeclared after '#undef' is a NEW one, not a reopening.
namespace N
    dim shared as integer i = 10
end namespace
print "ns:"; N.i
#undef N
namespace N alias "N2"
    dim shared as integer i = 20
end namespace
print "ns2:"; N.i
