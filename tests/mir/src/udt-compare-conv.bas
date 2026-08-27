'' A UDT COMPARISON THAT NEEDS A USER CONVERSION. The cost model priced UDT->UDT by
'' BASE DISTANCE only, so an unrelated type reachable through a conversion scored
'' CONV_NONE, the operator bound to nothing, and the statement declined with the
'' operator declared right there.
''
'' Measured, and the two shapes are not the same code:
''
''   conversion CONSTRUCTOR   _ZN2TUC1ER2TV( &TMP$2$0, &VV$0 )
''                            _ZneR2TUS0_( &UU$0, &TMP$2$0 )
''                            _ZN2TUD1Ev( &TMP$2$0 )      -- the temporary is destructed
''   operator CAST            _ZN2TVcv2TUEv( &VV$0 ) and its RESULT is the operand:
''                            no temporary, no destructor
''
'' TWO CHAINED user conversions -- a cast to string then a constructor from string --
'' are still not modelled and still decline.

type TV
    dim as long v
end type
type TU
    dim as long u
    declare constructor()
    declare constructor( byref rhs as TV )
    declare destructor()
end type
constructor TU()
end constructor
constructor TU( byref rhs as TV )
    u = rhs.v
end constructor
destructor TU()
end destructor
declare operator <>( byref a as TU, byref b as TU ) as integer
operator <>( byref a as TU, byref b as TU ) as integer
    return a.u <> b.u
end operator
dim as TU uu
dim as TV vv
dim as integer res = (uu <> vv)
print res

'' ...and the CAST-OPERATOR shape, which fbc prefers over a conversion constructor and
'' which needs no temporary and no destructor at all.
type CV
    dim as long v
    declare operator cast() byref as TU
end type
operator CV.cast() byref as TU
    static as TU t
    t.u = v
    return t
end operator
dim as CV cvv
dim as integer res2 = (uu <> cvv)
print res2
