'' Properties through interfaces (docs/tiko-interfaces §11.4, Phase 5a): a getter and a setter
'' implemented under another name, an indexed property, '+=' (get then set), and virtual
'' implementers whose overrides the thunks reach.
interface INamed
    declare property Name( ) as string
    declare property Name( byref v as const string )
end interface
interface IList
    declare property Item( byval i as long ) as long
end interface
class Pet
    implements INamed
    as string nm
    declare property Nick( ) as string implements INamed.Name
    declare property Nick( byref v as const string ) implements INamed.Name
end class
property Pet.Nick( ) as string
    return nm
end property
property Pet.Nick( byref v as const string )
    nm = v
end property
type Squares
    implements IList
    as long base0
    declare property At( byval i as long ) as long implements IList.Item
end type
property Squares.At( byval i as long ) as long
    return i * i + base0
end property
dim as Pet p
dim as INamed n = @p
n.Name = "Rex"
print n.Name, p.nm
dim as Squares sq : sq.base0 = 1
dim as IList l = @sq
print l.Item( 3 ), l.Item( 4 )
interface ICounter
    declare property Count( ) as long
    declare property Count( byval v as long )
end interface
class Counter
    implements ICounter
    as long n
    declare virtual property Count( ) as long implements ICounter.Count
    declare virtual property Count( byval v as long ) implements ICounter.Count
end class
property Counter.Count( ) as long
    return n
end property
property Counter.Count( byval v as long )
    n = v
end property
class Doubler
    inherits Counter
    declare property Count( ) as long override
    declare property Count( byval v as long ) override
end class
property Doubler.Count( ) as long
    return n * 2
end property
property Doubler.Count( byval v as long )
    n = v + 100
end property
dim as Counter b
dim as Doubler d
dim as ICounter c = @b
c.Count = 5
c.Count += 3
print c.Count, b.n
c = @d
c.Count = 5
print c.Count, d.n
