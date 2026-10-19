[Home](Home) › [All Categories](Categories) › **BitSet**

# BitSet

A **BitSet** is a set of small non-negative whole numbers, stored as one bit each. It answers "is 70 in the set?" in O(1) and holds a million flags in 125 KB.

```freebasic
#import "std/containers"
using containers

dim b as BitSet
b.Set( 3 )
b.Set( 70 )

print b.Test( 70 ), b.Test( 4 )        ' true  false
print b.CountOnes( )                   ' 2

for each i as long in b
    print i                            ' 3, then 70
next
```

Use it for "seen" flags in a graph search, free-slot maps, sieves, or any set of indices.

## Growth And Length

Indices start at 0. `Set( i )` grows the set as needed. `Length( )` is the number of addressable bits — one more than the highest bit ever touched — not the number of bits set; `CountOnes( )` is that. `Test` beyond `Length( )` is `false`.

`BitSet( n )` starts with `n` clear bits; `Resize( n )` grows or shrinks, and shrinking clears the bits that fall off.

## Set Algebra

The set operations change the left-hand set in place. A shorter right-hand set counts as zeros beyond its length.

```freebasic
#import "std/containers"
using containers

dim x as BitSet
dim y as BitSet
x.Set( 1 ) : x.Set( 2 )
y.Set( 2 ) : y.Set( 3 )

dim u as BitSet = x
u.UnionWith( y )
print u.CountOnes( )                   ' 3  -- {1, 2, 3}

dim n as BitSet = x
n.IntersectWith( y )
print n.FirstSet( )                    ' 2

print n.IsSubsetOf( x ), x.Equals( y ) ' true  false
```

`Equals` compares the bits that are set, so two sets of different `Length( )` can be equal.

## Members

```freebasic
Set( byval i as long, byval v as boolean = true )
Reset( byval i as long )
Flip( byval i as long )
Test( byval i as long ) as boolean
Length( ) as long
Resize( byval nbits as long )
CountOnes( ) as long
FirstSet( byval from as long = 0 ) as long        -1 when none
NextClear( byval from as long = 0 ) as long
SetAll( )                                         every bit below Length( )
ClearAll( )
IsEmpty( ) as boolean                             no bit set
UnionWith( byref o as BitSet )
IntersectWith( byref o as BitSet )
DifferenceWith( byref o as BitSet )
SymmetricDifferenceWith( byref o as BitSet )
IsSubsetOf( byref o as BitSet ) as boolean
Equals( byref o as BitSet ) as boolean
GetIterator( ) as BitSetIterator                  set bits, ascending
```

## See Also

[Set](Category-Set) · [Bit Manipulation](Category-Bit-Manipulation) · [Array](Category-Array)
