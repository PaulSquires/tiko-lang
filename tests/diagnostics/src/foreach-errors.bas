'' FOR EACH THAT CANNOT WORK, and what each one says.
''
'' Until this was checked, every one of these SAID NOTHING: the lowering declined the
'' statement and the count went up by one, which is exactly what it reports for a shape
'' nobody has implemented yet. A structural protocol's failure mode is getting it NEARLY
'' right, so a bare "not iterable" is useless -- RFC-0002 section 7 wants the missing
'' member NAMED, and the near-miss case below is the one that matters.
''
'' Every refusal is fbc's, not an invention: a MULTI-DIMENSIONAL array has no defensible
'' traversal order, and a FIXED-LENGTH string carries no length, so walking its declared
'' size reads past its own contents and produces plausible garbage for the tail.
type Nearly
    as long i
    declare function IsValid( ) as boolean
    declare function Value( ) as long
end type

function Nearly.IsValid( ) as boolean
    return this.i < 1
end function

function Nearly.Value( ) as long
    return 1
end function

type AlmostColl
    as long unused
    declare function GetIterator( ) as Nearly
end type

function AlmostColl.GetIterator( ) as Nearly
    dim r as Nearly
    return r
end function

type Plain
    as long unused
end type

dim as zstring * 8 z = "hi"
for each ch in z
next

dim grid(0 to 1, 0 to 1) as long
for each g in grid
next

dim as AlmostColl ac
for each v in ac
next

dim as Plain pl
for each w in pl
next

dim scalars(0 to 1) as long
for each (a1, b1) in scalars
next

dim pairs(0 to 1) as (long, string)
for each (a2, b2, c2) in pairs
next
