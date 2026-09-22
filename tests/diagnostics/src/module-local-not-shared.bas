'' TKO0743 for fbc's error 42: a module-level variable is a local of MAIN, and a procedure
'' cannot see it unless it is SHARED. The accepted half below is as much of the rule as the
'' refused half -- every line was measured against fbc-modern.
''
'' The bodies are written over SEVERAL LINES on purpose: fbc skips to the end of the LINE
'' after an error, so a one-line 'sub f( ) : print n : end sub' swallows its own 'end sub'
'' and every later procedure becomes its error 61, "Illegal inside functions".
dim n as long = 5
static st as long = 6
var v = 7
common cm as long
redim ra( 2 ) as long

dim shared sh as long = 8
common shared csh as long
var shared vs = 9
const K = 10

namespace ns
    '' A namespace's own variables ARE visible to its procedures, shared or not.
    dim nv as long = 11
    sub inside( )
        print nv
    end sub
end namespace

type T
    v as long
    declare sub m( )
end type

'' -- refused: every module-level local, in every kind of body ------------------
sub bad1( )
    print n
end sub

function bad2( ) as long
    return st
end function

sub bad3( )
    print v
end sub

sub bad4( )
    print cm
end sub

sub bad5( )
    print ra( 0 )
end sub

sub T.m( )
    print n
end sub

'' -- accepted -----------------------------------------------------------------
sub good1( )
    print sh
    print csh
    print vs
    print K
end sub

sub good2( )
    '' A local of the same name shadows nothing and is always visible.
    dim n as long = 1
    print n
end sub

sub good3( )
    good1( )
end sub

'' ...and at MODULE level the same names are in scope, here and in a scope block.
print n, st, v, ra( 0 )
scope
    print n
end scope
ns.inside( )
