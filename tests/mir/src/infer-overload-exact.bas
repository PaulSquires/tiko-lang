'' INFERRING A GENERIC'S TYPE ARGUMENT THROUGH AN OVERLOAD SET.
''
'' 'return Some( IPow( base_, expo ) )' inside 'IPowChecked( of T )' is the shape:
'' fb/mathint.bi expands one ordinary 'IPow( byval as T, byval as T ) as T' per integer
'' type from a MACRO, so the callee is FOUR CONCRETE OVERLOADS rather than a generic --
'' which is what an earlier record of this got wrong.
''
'' This pass runs before Check, so it cannot do overload resolution. But where one
'' candidate's first parameter is EXACTLY the first argument's type, that is the
'' candidate resolution picks -- an exact match beats every conversion -- and if that
'' candidate RETURNS that same type, the call's type is the argument's type whatever
'' else is in the set. Where NO candidate matches exactly it still declines, because
'' picking the cheapest conversion IS overload resolution.
type Opt( of T )
    dim as T v
    dim as boolean has
end type

function Some( of T )( byval x as T ) as Opt( of T )
    dim as Opt( of T ) r
    r.v = x
    r.has = true
    return r
end function

declare function Pick overload ( byval a as byte, byval b as byte ) as byte
declare function Pick overload ( byval a as long, byval b as long ) as long
declare function Pick overload ( byval a as double, byval b as double ) as double

function Pick overload ( byval a as byte, byval b as byte ) as byte
    return a
end function
function Pick overload ( byval a as long, byval b as long ) as long
    return a + b
end function
function Pick overload ( byval a as double, byval b as double ) as double
    return a * b
end function

'' the exact-match cases, one per overload
dim as byte   bb = 3
dim as long   ll = 4
dim as double dd = 2.5
dim as Opt( of byte )   ob = Some( Pick( bb, bb ) )
dim as Opt( of long )   ol = Some( Pick( ll, ll ) )
dim as Opt( of double ) od = Some( Pick( dd, dd ) )
print ob.has, ol.v, od.v
