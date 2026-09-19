'' A TYPE NAMED ABOVE ITS DECLARATION -- fbc has not reached it yet, and refuses every
'' such reference: error 14 in a DIM, a field, a result and over a typedef or an enum,
'' 59 in a parameter, 17 in a CAST, behind PTR as well. Each is refused on exactly the
'' line fbc-modern 1.20 and 1.10.1 refuse it (2026-09-19); tiko-lang accepted them all.

dim as TLater t1
type TA
    b as TLater ptr
end type
type TA2
    c as TLater
end type
declare sub takesLater( byval p as TLater ptr )
declare function givesLater( ) as TLater ptr
dim as any ptr q = cast( TLater ptr, 0 )
sub usesLater( )
    dim as TLater t2
end sub
dim as TDLater td1
dim as ELater el1

type TLater
    a as integer
end type
type TDLater as integer
enum ELater
    e1
end enum

'' ACCEPTED: a type naming itself, and the FORWARD DECLARATION 'type X as X_', whose
'' target may come later -- including a pair of types that point at each other.
type TN
    nxt as TN ptr
end type
type TF as TF_
dim as TF ptr pf
type TB as TB_
type TUse
    b as TB ptr
end type
type TF_
    a as integer
end type
type TB_
    a as TUse ptr
end type
