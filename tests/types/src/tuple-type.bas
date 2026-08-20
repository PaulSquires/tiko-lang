'' The TUPLE type: 'as (T, U)' in every position a type goes.
''
'' Measured against fbc, and the corpus's own tuple/basic.bas asserts the same thing: a
'' tuple IS the equivalent hand-written TYPE. Same size, same field offsets, field for
'' field. Its fields are '_1'.._N, and element NAMES are documentation --
'' '(count as long, name as string)' still has fields _1 and _2.
''
'' It is DESUGARED into a synthetic UDT rather than given a type kind of its own, which
'' is what makes the layout free: the desugaring happens in Resolve, before
'' ComputeUdtLayouts walks the symbols, so a tuple goes through the same offset and
'' alignment code as everything else -- including the nesting model.
''
'' Identity is STRUCTURAL, through a name built from the element type ids, so two
'' '(long, string)' written apart are ONE type.

type Tup2 as (long, string)
type Tup3B as (byte, byte, byte)
type TupNamed as (count as long, name as string)
type TupNested as (long, (long, long))

'' The hand-written equivalent, for the comparison the gate makes against fbc.
type RefTup2
	as long a
	as string b
end type

dim p as (long, string)
p._1 = 3
p._2 = "hi"

'' Two tuples written apart are the same type.
dim q as (long, string)
q = p

print p._1, p._2
