'' A nested FOR EACH over a member of the outer loop's variable, where the outer
'' collection's iterator yields BYREF through a pointer. The inner loop variable is typed
'' only once the outer one is (tracks-2026 TB-009).

type Leg
    as long n
    as long m
end type

type LegIter
    p as Leg ptr
    ix as long
    cnt as long
    declare function IsValid( ) as boolean
    declare function Value( ) byref as Leg
    declare sub MoveNext( )
end type
function LegIter.IsValid( ) as boolean
    return this.ix < this.cnt
end function
function LegIter.Value( ) byref as Leg
    return this.p[this.ix]
end function
sub LegIter.MoveNext( )
    this.ix += 1
end sub

type Legs
    as Leg l(0 to 1)
    as long cnt
    declare function GetIterator( ) as LegIter
end type
function Legs.GetIterator( ) as LegIter
    dim as LegIter it
    it.p = @this.l(0)
    it.cnt = this.cnt
    return it
end function

type Item
    as long id
    as Leg arr(0 to 1)
    as Legs legs
end type

type ItemDb
    as Item items(0 to 1)
    as long cnt
end type

type ItemIter
    db as ItemDb ptr
    ix as long
    declare function IsValid( ) as boolean
    declare function Value( ) byref as Item
    declare sub MoveNext( )
end type
function ItemIter.IsValid( ) as boolean
    return this.ix < this.db->cnt
end function
function ItemIter.Value( ) byref as Item
    return this.db->items(this.ix)
end function
sub ItemIter.MoveNext( )
    this.ix += 1
end sub

type ItemView
    db as ItemDb ptr
    declare function GetIterator( ) as ItemIter
end type
function ItemView.GetIterator( ) as ItemIter
    dim as ItemIter it
    it.db = this.db
    return it
end function

dim shared gDb as ItemDb

type Store
    as long z
    declare function All( ) as ItemView
end type
function Store.All( ) as ItemView
    dim as ItemView v
    v.db = @gDb
    return v
end function
dim shared gStore as Store

sub AddLeg( byref lg as Leg, byref total as long )
    total += lg.m
end sub

function SumCollection( ) as long
    dim as long total = 0
    for each it in gStore.All( )
        total += it.id
        for each lg in it.legs
            dim as Leg copy = lg
            total += copy.n
            AddLeg( lg, total )
        next
    next
    return total
end function

function SumArray( ) as long
    dim as long total = 0
    for each it in gStore.All( )
        for each lg in it.arr
            dim as Leg copy = lg
            total += copy.n
        next
    next
    return total
end function

function SumThree( ) as long
    dim as long total = 0
    for each it in gStore.All( )
        for each lg in it.legs
            for each lg2 in it.arr
                dim as Leg a = lg
                dim as Leg b = lg2
                total += a.n * b.n
            next
        next
    next
    return total
end function

gDb.cnt = 2
gDb.items(0).id = 1
gDb.items(0).legs.cnt = 2
gDb.items(0).legs.l(0).n = 10 : gDb.items(0).legs.l(0).m = 1
gDb.items(0).legs.l(1).n = 20 : gDb.items(0).legs.l(1).m = 2
gDb.items(0).arr(0).n = 3 : gDb.items(0).arr(1).n = 4
gDb.items(1).id = 100
gDb.items(1).legs.cnt = 1
gDb.items(1).legs.l(0).n = 300 : gDb.items(1).legs.l(0).m = 5
gDb.items(1).arr(0).n = 7 : gDb.items(1).arr(1).n = 8
print SumCollection( )
print SumArray( )
print SumThree( )
