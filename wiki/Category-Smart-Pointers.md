[Home](Home) › [All Categories](Categories) › **Smart Pointers**

# Smart Pointers

```freebasic
#import "std/memory"
using memory

type Session
    as ustring user
    as int32   id
end type

dim s as SharedPtr( of Session ) = MakeShared( of Session )( )
s->user = "ada"
s->id   = 1815

scope
    dim t as SharedPtr( of Session ) = s      ' both name one Session
    print t.UseCount( )                       ' 2
    t->id = 1816
end scope                                     ' t goes, the Session stays

print s->id                                   ' 1816
print s.UseCount( )                           ' 1

                                              ' the Session is destroyed
                                              ' here, exactly once
```

## Why It Exists

A raw pointer has no way to say "this object is owned jointly". Every heap object reached through one has exactly one owner by convention, and the convention lives in a comment:

```freebasic
dim p as Node ptr = new Node        ' who deletes this?
Register( p )                       ' ...does Register take ownership?
delete p                            ' ...or was that a double free?
```

The two places in this tree that genuinely needed shared ownership -- Channel( of T ) and Context -- each solved it privately, and each hand-rolled the identical copy-constructor / destructor / LET triad over a reference-counted state block. SharedPtr is that, written once and generically, so the ownership question is answered by the type instead of by a comment.

WeakPtr( of T ) observes the same object WITHOUT keeping it alive. It is the only way to break a cycle, and a cycle is the one thing reference counting cannot survive on its own.

## Members

SharedPtr( of T )

```freebasic
constructor( )                      ' null
constructor( byval p as T ptr )     ' adopt a raw pointer
constructor( byref rhs as SharedPtr( of T ) )
destructor( )
operator let( byref rhs as SharedPtr( of T ) )

Get( ) as T ptr                     ' the raw pointer, 0 when null
Ref( ) byref as T                   ' checked dereference; raises when null
IsNull( ) as boolean
UseCount( ) as int32                ' number of SharedPtr handles
Reset( )                            ' drop this handle
```

WeakPtr( of T )

```freebasic
constructor( )
constructor( byref rhs as SharedPtr( of T ) )
constructor( byref rhs as WeakPtr( of T ) )
destructor( )
operator let( byref rhs as WeakPtr( of T ) )
operator let( byref rhs as SharedPtr( of T ) )

Lock( ) as SharedPtr( of T )        ' null if the object is already gone
Expired( ) as boolean
UseCount( ) as int32
Reset( )
```

free procedures

```freebasic
MakeShared( of T )( ) as SharedPtr( of T )
MakeSharedFrom( of T )( byref v as T ) as SharedPtr( of T )
SpCast( of D, B )( byref s as SharedPtr( of D ) ) as SharedPtr( of B )
```

global operators

```freebasic
operator *  ( of T )( byref p as SharedPtr( of T ) ) byref as T
operator -> ( of T )( byref p as SharedPtr( of T ) ) byref as T
```

They are separately named rather than overloaded because a generic procedure cannot be overloaded: one name, one generic procedure.

## The Counts

'strong' is the number of SharedPtr handles. 'weak' is the number of WeakPtr handles PLUS ONE while strong > 0 -- all the strong handles share a single weak reference between them. So:

```freebasic
strong reaches 0   ->  the object is destroyed, and that shared weak
                       reference is dropped
weak   reaches 0   ->  the control block itself is freed
```

which is what lets a WeakPtr read the strong count of an object that has already been destroyed: the block outlives the object it describes.

## Two Allocations, NOT One

C++'s make_shared fuses the control block and the object into one allocation. That is not available here, and the reason is worth stating because it looks like an oversight.

Fusing them means embedding 'as T obj' in the control block, which makes the control block generic. Every member of a generic is instantiated whether it is called or not, so a control block containing a T would require T to be default-constructible for EVERY use of SharedPtr -- including the ones that adopt an already-built pointer, where no default constructor is wanted or possible. A non-generic control block holding an 'any ptr' costs one extra allocation and leaves T completely unconstrained. That is the trade.

It is also why the control block has no members at all. A control block with a virtual Dispose( ) would need a non-generic base class whose method bodies lived in the header this library was written as, and a method body in a header is a duplicate symbol in every module that includes it. So the block stores no type information, and DESTRUCTION IS DONE BY THE HANDLE, which knows T.

## Thread Safety

Under -mt every count is touched through the runtime atomics in fbatomic.bi; without -mt they are plain reads and writes. The gate is \_\_FB_MT\_\_, and it is safe because -mt is a whole-program link option: a program cannot mix the two, and without it there are no threads to race with.

THE GUARANTEE COVERS THE CONTROL BLOCK, NEVER THE POINTEE. Two threads may copy and destroy handles to the same object freely. Two threads calling a mutating member of the object itself still need their own lock. This is exactly C++'s contract, and the distinction is the one people get wrong.

The atomics are ordinary calls into the runtime, not inlined instructions -- see IMPLEMENTATION NOTE.

## Cycles, AND What Weakptr Is For

Two objects holding SharedPtrs to each other keep each other alive for ever. Reference counting cannot detect that; nothing here will warn you.

The fix is to make exactly one direction weak -- conventionally the one that points "back":

```freebasic
type Node_
    as Array( of SharedPtr( of Node_ ) ) kids     ' owns
    as WeakPtr( of Node_ )               parent   ' observes
end type

dim up as SharedPtr( of Node_ ) = kid->parent.Lock( )
if( up.IsNull( ) = FALSE ) then
    print up->id
end if
```

Lock( ) is the only way to read through a WeakPtr, and it is not a formality: it either hands back a fully valid handle or a null one, and between the two there is no window. Internally it is an increment-only-if-not-zero, done as a single compare-and-swap, because between reading a non-zero count and incrementing it the last SharedPtr may drop the count to zero and destroy the object.

## Derived To Base Is Explicit

```freebasic
dim c as SharedPtr( of Circle ) = MakeShared( of Circle )( )
dim s as SharedPtr( of Shape )  = SpCast( of Circle, Shape )( c )
```

There is no implicit conversion. A converting constructor would have to be a member with its OWN type parameter --

```freebasic
declare constructor( of U )( byref rhs as SharedPtr( of U ) )
```

-- and members cannot have their own type parameters. Both type arguments have to be written out because inference reads parameter positions only, and B appears nowhere in the parameter list.

THE BASE MUST HAVE A VIRTUAL DESTRUCTOR. C++'s shared_ptr does not require one, because its control block type-erases the deleter at construction time; that needs the address of an instantiated generic procedure, which is not expressible here. The surviving handle destroys through ITS OWN T, so destroying a Circle through a SharedPtr( of Shape ) is correct only if Shape's destructor is virtual. There are no constraints on type parameters, so this cannot be checked -- it is a contract, and breaking it is silent.

The reinterpretation itself is safe: the control block is not generic, so there is one layout for every T, and tiko is single-inheritance, so a Circle pointer and its Shape subobject share an address with no adjustment to apply.

## The Arrow Needs A UDT

'sp->field' requires T to be a structure, because the result of an operator -> is what member access chains through. On a scalar T the arrow is a compile error naming the instantiation:

```freebasic
dim si as SharedPtr( of integer ) = MakeShared( of integer )( )
print si->v          ' error 141: invalid result type for this operator
print *si            ' fine
print si.Ref( )      ' fine
```

Neither '\*sp' nor 'sp->' checks for null: they compile to the same dereference the equivalent raw pointer would, and putting a branch on every field access to catch a bug the call site already has is the wrong trade. Ref( ) is the checked spelling.

## NULL Access Raises

Ref( ) on a null SharedPtr raises FB_RTERROR_ILLEGALFUNCTIONCALL through the ordinary runtime-error path, so it is catchable by 'on error' and reports a line under -exx. With no handler the program aborts with 'runtime error 1' naming the line in sharedptr.tiko.

Unlike Optional.Value( ), there is nothing sane to return afterwards -- a null handle owns no object, so no T exists anywhere to reference. A function-static blank would be worse than the fault: it would force T to be default- constructible for every use of SharedPtr, and a function-static UDT in tiko lives until the program ends, so it would retain one T and its resources for the life of the program.

## Every Copy Is A Real Refcount Operation

There is no move constructor in the language and no return-value optimisation, so returning a SharedPtr by value costs an increment and a decrement, and so does passing one by value. Pass BYREF where it matters, as the containers do:

```freebasic
sub Handle( byref s as SharedPtr( of Session ) )     ' no refcount traffic
sub Handle( byval s as SharedPtr( of Session ) )     ' two atomic ops
```

BYREF is correct for any parameter that only reads the handle. Take it BYVAL only when the callee genuinely stores the handle somewhere that outlives the call, which is the same rule C++ arrived at.

## What Is NOT Provided

- NO UniquePtr. The language has no move constructor, so a non-copyable

```freebasic
owning pointer could not be returned from a function -- Thread hits this
exact wall, being "non-copyable and therefore non-returnable". DEFER
covers the scope-local case.
```

- NO enable_shared_from_this. It needs CRTP -- 'type W extends

```freebasic
SharedFromThis( of W )' -- which instantiates a generic with a type that is
still being defined.
```

- NO aliasing constructor, NO custom deleters, NO array form. All three need

```freebasic
either a type-erased deleter or a second stored pointer.
```

- NO comparison operators. Compare Get( ) if you need identity.

- SharedPtr( of const T ) is untested and unsupported. Const propagation

```freebasic
through generic instantiations has no coverage anywhere in this tree.
```

## Library Only

The types are entirely tiko -- the std/memory module, pkg/std/memory/sharedptr.tiko.

Generic global UNARY operators -- '\*', '->', unary '-' and NOT -- are instantiated at their use sites. generics/global-unary-operators.bas -- each of those four beside a binary operator of the same spelling over a plain Box( of T ) -- builds and runs under tiko with exit 0, and tiko's own `tests/mir/generic-global-operator.test` covers '+', unary '\*' and '->'.

## Implementation Note

The reference counts go through three runtime functions -- fb_AtomicFetchAddLong, fb_AtomicCasLong and fb_AtomicLoadLong, declared in inc/fbatomic.bi. In tiko they are tiko-rt's, in lib/rt/src/c/atomic.c: one of the few C files in a runtime otherwise written in tiko, because the language cannot spell an atomic operation. They use clang's \_\_atomic builtins and are sequentially consistent throughout.

These three deliberately do not offer the full C11 memory-order vocabulary. They are the smallest primitive set a reference count needs.

The cost is a real call per operation, since they cannot inline into tiko code. That is the trade: correct and portable now, faster later.

They are declared with C 'int', not C 'long'. C 'long' is 64-bit on LP64 and 32-bit on Windows, while tiko's LONG is 32-bit everywhere -- getting this wrong is invisible on win64 and silently corrupts the adjacent field on linux-x86_64.

## Tests

The SharedPtr tests are vendored in tiko-lang under `tests/vendor/fbc-tests/`.

generics/container-sharedptr.bas

```freebasic
Exhaustive: every member of both types, both free constructors, SpCast,
both operators, every null/non-null transition, destructor balance under
scope exit / reassignment / early return / container growth, and the
parent-child cycle that WeakPtr breaks.
```

threads/sharedptr-mt.bas

```freebasic
The atomic path. Eight threads copying and destroying handles to one
control block, and eight racing WeakPtr.Lock( ). An fbcunit suite, built
with -mt. With a plain 'count += 1' substituted this segfaults.
```

generics/sharedptr-null-ref.bas

```freebasic
Ref( ) on a null handle raises. Separate module: the raise aborts.
```

generics/fail-sharedptr-scalar-arrow.bas

```freebasic
'sp->' on a scalar T is a compile error.
```

generics/global-unary-operators.bas

```freebasic
Generic global unary operators, proven on a plain Box( of T ) with no
SharedPtr in sight: unary '-', NOT, unary '*' and '->', each alongside a
binary operator of the same spelling over the same type.
```

Under tiko: container-sharedptr.bas and global-unary-operators.bas build and run with exit 0; sharedptr-mt.bas, built with -mt against fbcunit, passes 14 of 14 assertions; sharedptr-null-ref.bas aborts with 'runtime error 1 (illegal function call)', naming the line of the ERROR( ) inside Ref( ) in pkg/std/memory/sharedptr.tiko; and fail-sharedptr-scalar-arrow.bas is refused with `TKO0739: 'sharedptr' has no member named 'v'`.

## API reference

One page per entry, 11 in all:

[Expired](Modern-SharedPtr-Expired) · [Get](Modern-SharedPtr-Get) · [IsNull](Modern-SharedPtr-IsNull) · [Lock](Modern-SharedPtr-Lock) · [MakeShared](Modern-SharedPtr-MakeShared) · [MakeSharedFrom](Modern-SharedPtr-MakeSharedFrom) · [Ref](Modern-SharedPtr-Ref) · [Reset](Modern-SharedPtr-Reset) · [SharedPtr](Modern-SharedPtr-SharedPtr) · [SpCast](Modern-SharedPtr-SpCast) · [UseCount](Modern-SharedPtr-UseCount) · [WeakPtr](Modern-SharedPtr-WeakPtr)

---



---

[Home](Home) · [Keyword Index](Keyword-Index)
