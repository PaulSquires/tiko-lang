'' 'SELECT CASE AS CONST' over an integer subject whose cases are constants it holds is
'' one LLVM 'switch' (mir/lowerswitch.tiko); anything else keeps the compare chain. Every
'' line below is fbc-modern 1.20's output for the same program: the switch's answers --
'' sparse and dense values, ranges, signed and unsigned subjects at every width, a
'' character read through a pointer, exit select, nesting, a string local across a
'' return, the int64 extremes -- and the chain's, for case values the subject cannot
'' hold, which are compared in the promoted type (300 over a ubyte, -1 over a ulongint).
function Dup( byval x as long ) as long
    select case as const x
    case 1 : return 10
    case 2 to 4 : return 20
    case else : return 99
    end select
end function
function Neg( byval x as long ) as long
    select case as const x
    case -3 to -1 : return 1
    case 0 : return 2
    case else : return 3
    end select
end function
function UB( byval x as ubyte ) as long
    select case as const x
    case 255 : return 1
    case 0 : return 2
    case else : return 3
    end select
end function
function ULI( byval x as ulongint ) as long
    select case as const x
    case &hFFFFFFFFFFFFFFFFull : return 1
    case 0 : return 2
    case else : return 3
    end select
end function
enum Color_ : Red_ = 1, Green_, Blue_ : end enum
function En( byval x as Color_ ) as long
    select case as const x
    case Red_ : return 1
    case Green_, Blue_ : return 2
    case else : return 3
    end select
end function
function NoElse( byval x as long ) as long
    dim as long r = 7
    select case as const x
    case 1 : r = 1
    end select
    return r
end function
print Dup( 1 ); Dup( 3 ); Dup( 5 )
print Neg( -2 ); Neg( 0 ); Neg( 1 )
print UB( 255 ); UB( 0 ); UB( 7 )
print ULI( &hFFFFFFFFFFFFFFFFull ); ULI( 0 ); ULI( 5 )
print En( Red_ ); En( Blue_ ); En( cast( Color_, 9 ) )
print NoElse( 1 ); NoElse( 2 )

function URange( byval x as ubyte ) as long
    select case as const x
    case 100 to 200 : return 1
    case 0 to 5, 250 to 255 : return 2
    case else : return 3
    end select
end function
function SRange( byval x as byte ) as long
    select case as const x
    case -128 to -100 : return 1
    case -5 to 5 : return 2
    case 120 to 127 : return 3
    case else : return 4
    end select
end function
function CountLetters( byval s as zstring ptr ) as long
    dim as long n = 0
    while (*s)[0] <> 0
        select case as const (*s)[0]
        case asc( "a" ) to asc( "z" ) : n += 1
        case asc( "0" ) to asc( "9" ) : n += 100
        end select
        s += 1
    wend
    return n
end function
function Ex( byval x as long ) as long
    dim as long r = 0
    select case as const x
    case 1
        r = 1
        if x = 1 then exit select
        r = 99
    case 2
        select case as const r
        case 0 : r = 20
        case else : r = 21
        end select
    end select
    return r
end function
function Str_( byval x as long ) as string
    dim as string t = "local"
    select case as const x
    case 1 : return t & "1"
    case 2 : t &= "2"
    end select
    return t
end function
function Big( byval x as longint ) as long
    select case as const x
    case 9223372036854775807 : return 1
    case 9223372036854775806 : return 2
    end select
    select case as const x
    case -9223372036854775807 - 1 : return 3
    case else : return 4
    end select
end function
function U16( byval x as ushort ) as long
    select case as const x
    case 65535 : return 1
    case 65530 to 65533 : return 2
    case else : return 3
    end select
end function
dim as zstring * 16 z = "ab3c99"
print URange( 150 ); URange( 0 ); URange( 255 ); URange( 99 ); URange( 201 )
print SRange( -128 ); SRange( -100 ); SRange( 0 ); SRange( 127 ); SRange( 50 )
print CountLetters( @z )
print Ex( 1 ); Ex( 2 ); Ex( 3 )
print Str_( 1 ); " "; Str_( 2 ); " "; Str_( 3 )
print Big( 9223372036854775807 ); Big( -9223372036854775807 - 1 ); Big( 0 ); Big( 5 )
print U16( 65535 ); U16( 65531 ); U16( 1 )

sub Probe_b1( )
    dim as boolean b = true
    select case as const b
    case true : print "t"
    case else : print "f"
    end select
end sub
Probe_b1( )
sub Probe_o1( )
    dim as ubyte b = 44
    select case as const b
    case 300 : print "300"
    case else : print "else"
    end select
end sub
Probe_o1( )
sub Probe_o2( )
    dim as byte b = -1
    select case as const b
    case 255 : print "255"
    case else : print "else"
    end select
end sub
Probe_o2( )
sub Probe_o3( )
    dim as ulongint u = &hFFFFFFFFFFFFFFFFull
    select case as const u
    case -1 : print "m1"
    case else : print "else"
    end select
end sub
Probe_o3( )
sub Probe_o4( )
    dim as long l = -1
    select case as const l
    case &hFFFFFFFF : print "ff"
    case else : print "else"
    end select
end sub
Probe_o4( )
sub Probe_p1( )
    dim as integer v = 2
    dim as integer ptr p = @v
    select case as const p
    case 0 : print "null"
    case else : print "else"
    end select
end sub
Probe_p1( )
sub Probe_l1( )
    dim as longint x = 5000000000
    select case as const x
    case 5000000000 : print "big"
    case else : print "else"
    end select
end sub
Probe_l1( )
