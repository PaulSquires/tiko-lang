'' A procedure's ADDRESS taken before its definition, then a direct call. '@X' met X
'' before 'sub X' and declared it with no parameters and no result, and every later
'' call bound to that empty declaration: 'verify: calls X with 2 arguments, which
'' declares 0'. Private or public made no difference; the order did. Found in
'' fbc-modern's fb/logerror.bi, where GetLogErrorHandler returns '@' a handler defined
'' below it. Each shape here is one the call side builds differently: a sub, a
'' function with a result, a string result (a pointer at the call), an aggregate
'' result (a hidden result pointer), and a call made AFTER the address but BEFORE the
'' definition. Output identical to fbc-modern's.

type Big
    as longint a, b, c, d
end type

type SubT as sub( byref s as string, byval n as long )
type FnT  as function( byval n as long ) as long
type StrT as function( byval n as long ) as string
type BigT as function( byval n as long ) as Big

declare sub PrivSub( byref s as string, byval n as long )
declare sub PubSub( byref s as string, byval n as long )
declare function Twice( byval n as long ) as long
declare function Words( byval n as long ) as string
declare function MakeBig( byval n as long ) as Big
declare sub Early( byref s as string, byval n as long )

private function GetPriv( ) as SubT
    return @PrivSub
end function

function GetPub( ) as SubT
    return @PubSub
end function

dim shared as FnT  pTwice
dim shared as StrT pWords
dim shared as BigT pBig
dim shared as SubT pEarly

private sub TakeAddresses( )
    pTwice = @Twice
    pWords = @Words
    pBig   = @MakeBig
    pEarly = @Early
end sub

'' After the address, before the definition.
private sub CallsEarly( )
    Early( "early, direct", 6 )
end sub

private sub PrivSub( byref s as string, byval n as long )
    print s; n
end sub

sub PubSub( byref s as string, byval n as long )
    print s; n
end sub

function Twice( byval n as long ) as long
    return n * 2
end function

function Words( byval n as long ) as string
    return "words " & n
end function

function MakeBig( byval n as long ) as Big
    dim as Big r
    r.a = n : r.b = n + 1 : r.c = n + 2 : r.d = n + 3
    return r
end function

sub Early( byref s as string, byval n as long )
    print s; n
end sub

TakeAddresses( )
CallsEarly( )

PrivSub( "private, direct", 1 )
GetPriv( )( "private, pointer", 1 )
PubSub( "public, direct", 2 )
GetPub( )( "public, pointer", 2 )
print "twice"; Twice( 3 ); pTwice( 4 )
print Words( 5 ); " / "; pWords( 5 )
dim as Big b1 = MakeBig( 10 ), b2 = pBig( 20 )
print "big"; b1.a; b1.d; b2.a; b2.d
pEarly( "early, pointer", 6 )
