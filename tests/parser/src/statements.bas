namespace demo
const MAX = 10
type Point
    as long x, y
    declare function Norm( ) as double
end type
enum Colour
    Red = 1
    Green
end enum
dim shared as long total
sub Run( byval n as long, byref s as string = "hi" )
    dim as long i
    for i = 0 to n - 1 step 2
        if i mod 2 = 0 then
            total += i
        elseif i > 5 then
            exit for
        else
            print "odd", i
        end if
    next
    do while total < 100
        total *= 2
    loop
    select case total
        case 0, 1 : print "small"
        case 2 to 9 : print "mid"
        case else : print "big"
    end select
end sub
end namespace

'' A LABEL needs the colon. A bare identifier on a line of its own is a CALL with the
'' parentheses left off, not a label -- ':' and a newline are both TK_EOL and both one
'' byte, so telling them apart by length made every zero-argument bare call a label on
'' LF input, and looked correct only on CRLF.
sub Bare( )
end sub
Bare
theLabel:

'' UNNAMED parameters, which is how a procedure POINTER type is normally written -- the
'' names would be meaningless there. fbc accepts these in a DECLARE and in a type, and
'' rejects them in a definition (error 59), which is a semantic rule rather than a
'' syntactic one.
dim pf1 as sub( byref as long )
dim pf2 as sub( as long )
dim pf3 as sub( byval as long, as double )
dim pf4 as function( as long ) as long

'' A PARENTHESISED assignment target. The parentheses are permitted around an lvalue and
'' change nothing, so this is the same call-or-assign ambiguity as a bare name -- but a
'' statement starting with '(' was not reaching that path at all.
dim as long pv, parr(1 to 2)
dim pp as long ptr = @pv
(pv) = 5
(*pp) = 6
(parr(1)) = 7

'' 'UNSIGNED <int type>' is the only TWO-WORD type name FreeBASIC has -- measured sizes
'' 1/2/4/8/8, and 'SIGNED' is not a prefix at all. Without handling it the second word was
'' left behind and the declaration silently had the type 'unsigned', which no diagnostic
'' would ever mention.
dim as unsigned byte ub1
dim as unsigned short ub2
dim as unsigned long ub3
dim as unsigned integer ub4
dim as unsigned longint ub5

'' A TYPE ALIAS controls C++ mangling: C++ has three distinct char types where FreeBASIC
'' has BYTE and UBYTE, so plain 'char' cannot otherwise be spelled. fbc allows it on the
'' byte types only.
extern "c++"
    declare function cppchar( byval a as byte alias "char" ) as byte alias "char"
end extern

'' The varargs intrinsics. cva_start/cva_end/cva_copy are STATEMENTS; cva_arg is an
'' expression whose SECOND ARGUMENT IS A TYPE, which no ordinary argument list can parse.
'' All four were keywords with no parser at all, so each was "expected a statement".
sub Varia cdecl( byval n as long, ... )
    dim as any ptr vl, vl2
    dim as long got
    cva_start( vl, n )
    got = cva_arg( vl, long )
    cva_copy( vl2, vl )
    cva_end( vl2 )
    cva_end( vl )
end sub

'' Assignment THROUGH A POINTER. A statement may begin with the dereference operator, and
'' the target is an ordinary lvalue from there -- the same call-or-assign ambiguity as a
'' bare name, which a statement starting with '*' was not reaching.
dim as long dtgt
dim dp as long ptr = @dtgt
dim dpp as long ptr ptr = @dp
*dp = 5
**dpp = 6

'' A member DEFINITION carrying VIRTUAL. The modifier loop inside the procedure parser
'' already handled it; what was missing was the routing, so 'virtual' at statement level
'' never reached the declaration parser at all. ABSTRACT routes the same way -- fbc
'' rejects a body for one SEMANTICALLY (error 224), having parsed it first, so refusing
'' it here would report a syntax error for something that is not one.
type VBase extends Object
    declare virtual sub vs( )
end type
virtual sub VBase.vs( )
end sub

'' 'base.vs( )' -- a call on the BASE-class receiver. Like '.field' inside a WITH the
'' receiver is implicit, so it is the same call-or-assign ambiguity as a bare name.
type VDer extends VBase
    declare sub go( )
end type
sub VDer.go( )
    base.vs( )
end sub
