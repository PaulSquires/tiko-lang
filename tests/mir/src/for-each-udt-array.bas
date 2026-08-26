'' FOR EACH over an array whose ELEMENT IS AN AGGREGATE -- a tuple, or a UDT with a
'' constructor and a destructor.
''
'' A load and a store is not a binding for one of these: it is a SHALLOW copy, so a
'' tuple half that is a string would share its buffer with the array and then be freed
'' twice. Measured against fbc -- the element is COPY-CONSTRUCTED into the loop variable
'' through the type's own copy constructor, and DESTROYED at the bottom of each
'' iteration, which is why the corpus asserts the constructor and destructor totals are
'' equal.
''
'' The destruction is registered with the BODY'S SCOPE rather than emitted at the end of
'' the body, so 'exit for' out of the middle destroys it too.
''
'' The destructuring form rides on this: 'for each (k, v) in arr' binds one hidden
'' element and declares each name from a field of it, so the element is exactly the
'' aggregate this arm copies.
dim shared as long ctors, dtors

type Counted
    as long v
    declare constructor( )
    declare constructor( byref rhs as Counted )
    declare destructor( )
end type

constructor Counted( )
    this.v = 0
    ctors += 1
end constructor

constructor Counted( byref rhs as Counted )
    this.v = rhs.v
    ctors += 1
end constructor

destructor Counted( )
    dtors += 1
end destructor

sub s1( )
    dim arr(0 to 2) as (long, string)
    for i as long = 0 to 2
        arr(i)._1 = i
        arr(i)._2 = "a" & i
    next

    dim keys as long = 0
    dim vals as string = ""
    for each (k, v) in arr
        keys += k
        vals &= v
    next

    dim cs(0 to 1) as Counted
    cs(0).v = 7
    dim total as long = 0
    for each e in cs
        total += e.v
    next

    print keys, vals, total, ctors, dtors
end sub

s1( )
