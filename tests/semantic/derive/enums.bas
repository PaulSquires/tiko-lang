'' enums.bas -- RFC 0019 R9's oracle: enumname, enumcount and enumvalue, written out by hand.
''
'' THE RULES BEING PINNED (section 6):
''   enumname( v )      the spelling of the FIRST DECLARED constant whose value is v, as
''                      written in the declaration; "" when no constant has the value
''   enumcount( E )     the number of constants
''   enumvalue( E, i )  the i-th constant, counting from 0, in declaration order
''
'' Plain FreeBASIC (LONG, not int32), so fbc 1.20 runs it too and the .fbc-trace says the
'' hand-written answers are FreeBASIC's own. After P3 a twin using the intrinsics must print
'' this file's .p0-trace exactly.

'' Negative values, an implicit step, a gap, and a duplicate value (Cc and Dup share 10).
enum Sparse
    Neg = -3
    Next1
    Cc = 10
    Dup = 10
    Big = 2147483647
end enum

'' An EXPLICIT enum: its constants are reached only qualified.
enum Mode explicit
    Off
    On_
end enum

namespace Ns
    enum Inner
        First = 5
        Second
    end enum
end namespace

function SparseName( byval v as Sparse ) as string
    select case v
    case Sparse.Neg   : return "Neg"
    case Sparse.Next1 : return "Next1"
    case Sparse.Cc    : return "Cc"
    case Sparse.Dup   : return "Dup"        '' never reached: Cc is declared first
    case Sparse.Big   : return "Big"
    end select
    return ""
end function

const SPARSE_COUNT = 5
dim shared as Sparse sparseValues( 0 to SPARSE_COUNT - 1 ) = _
    { Sparse.Neg, Sparse.Next1, Sparse.Cc, Sparse.Dup, Sparse.Big }

function ModeName( byval v as Mode ) as string
    select case v
    case Mode.Off : return "Off"
    case Mode.On_ : return "On_"
    end select
    return ""
end function

function InnerName( byval v as Ns.Inner ) as string
    select case v
    case Ns.First  : return "First"
    case Ns.Second : return "Second"
    end select
    return ""
end function

print "enumcount( Sparse ) = "; SPARSE_COUNT
for i as long = 0 to SPARSE_COUNT - 1
    print "enumvalue( Sparse, " & i & " ) = " & sparseValues( i ) & _
        "  enumname = [" & SparseName( sparseValues( i ) ) & "]"
next
print "enumname( cast( Sparse, 0 ) ) = [" & SparseName( cast( Sparse, 0 ) ) & "]"
dim as Sparse v = Sparse.Big
print "enumname( v ), v = Big: [" & SparseName( v ) & "]"
print "enumcount( Mode ) = 2; enumname( Mode.On_ ) = [" & ModeName( Mode.On_ ) & "]"
print "enumcount( Ns.Inner ) = 2; enumname( Ns.Second ) = [" & InnerName( Ns.Second ) & "]"
