'' A DERIVED POINTER DOES NOT TAKE A BASE ONE -- fbc error 181. The conversion goes ONE
'' WAY: a base pointer takes a derived one (the upcast), the reverse is a downcast the
'' compiler cannot check, and 'any ptr' takes and gives anything.
''
'' THE ERROR IS ONLY FOR A POINTEE THAT ITSELF EXTENDS SOMETHING. Two plain types, a plain
'' type and an integer pointer, a plain type and a base that is merely extended -- every
'' one of those is a WARNING in fbc, not an error, and its warnings/ptr-*.bas files write
'' them all. The accepted half below is exactly that boundary.
type Plain
    i as integer
end type
type Other
    i as integer
end type
type Root
    i as integer
end type
type Leaf extends Root
    j as integer
end type

dim pPlain as Plain ptr, pOther as Other ptr
dim pRoot as Root ptr, pLeaf as Leaf ptr
dim pInt as integer ptr, pAny as any ptr

pPlain = pOther
pPlain = pInt
pPlain = pRoot
pRoot = pLeaf
pAny = pLeaf
pLeaf = pAny

pLeaf = pRoot
pLeaf = pInt
pLeaf = pPlain
pPlain = pLeaf
dim badInit as Leaf ptr = pRoot
