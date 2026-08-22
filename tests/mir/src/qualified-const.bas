'' 'NS.K' AND 'NS.SOME_ENUM_MEMBER' -- a CONSTANT reached through a namespace.
''
'' Check's qualified-name branch typed only a VARIABLE, so a namespaced constant or enum
'' member got a REFERENCE and no TYPE. Every use of one was untyped:
'' 'error( FB.FB_RTERROR_ILLEGALFUNCTIONCALL )' is how the runtime headers raise every
'' error they raise, and 'FB.SOME_LIMIT' is how they name every constant they export.
''
'' An enum member with no type of its own is an INTEGER, which is what fbc gives one: the
'' members carry values and only the enum TYPE carries a name.
''
'' AND THE FOLD HAD TO SURVIVE A REFACTOR. Splitting the N_IDENT/N_MEMBER case to add the
'' property-getter branch dropped LowerPredeclared from the member half -- so a qualified
'' constant lost its fold and, worse, 'x.f' over a BITFIELD went back to loading the
'' whole packed unit. The two kinds share every step but one; only the property call is
'' member-specific, and the case is shared again.

namespace NS
    enum E
        A0 = 0
        A1
    end enum
    const K = 7
end namespace

type BF
    a as ulong : 3
    b as ulong : 5
end type

sub P( )
    dim as long n = NS.A1
    dim as long m = NS.K
    error( NS.A1 )

    '' The bitfield read the refactor had quietly broken.
    dim as BF f
    dim as ulong g = f.b
end sub
