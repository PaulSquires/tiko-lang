'' TWO CHAINED USER CONVERSIONS on an operator's operand: a cast to STRING on the
'' source, then a constructor FROM string on the destination. fbc's priority 4, and
'' the shape structs/udt-comp-ops-2.bas is written to exercise -- only
'' 'operator <>( TU, TU )' is declared, so 'u <> v' over a TV reaches it through both.
''
'' Measured:
''
''     vr$5  = _ZN2TVcv8FBSTRINGEv( &V$0 );
''     _ZN2TUC1ER8FBSTRING( &TMP$3$0, ... );
''     vr$11 = _ZneR2TUS0_( &U$0, &TMP$3$0 );
''     _ZN2TUD1Ev( &TMP$3$0 );
''
'' -- the converted operand's temporary is destructed AFTER the operator. One step
'' was modelled and two were not, so both statements declined.
type TV_ as TV
type TU
    i as integer
    declare constructor()
    declare constructor(byref s as string)
    declare destructor()
end type
type TV
    i as integer
    declare operator cast() as string
end type
constructor TU() : end constructor
constructor TU(byref s as string) : end constructor
destructor TU() : end destructor
operator TV.cast() as string
    return ""
end operator
operator <>(byref ul as TU, byref ur as TU) as integer
    return ul.i <> ur.i
end operator
dim as TU u
dim as TV v
dim as boolean result
if u <> v then
    result = true
end if
result = (u <> v)
