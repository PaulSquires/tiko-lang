'' A BYVAL UDT ARGUMENT TAKES THE ARGUMENT'S OWN 'operator cast', when the parameter's
'' type has no constructor for it. Measured on fbc-modern: 'Take_( w )' below prints
'' 111 222 333, the values the operator makes. tiko-lang printed 7 8 9 -- the first
'' twenty-four bytes of the argument, blitted into the parameter's slot.
''
'' WHERE THE SOURCE IS THE LARGER TYPE IT IS NOT A WRONG VALUE, IT IS A STACK OVERRUN,
'' and that is fault twelve. AfxNova's IWinHttpRequest.Send takes 'byval Body as
'' VARIANT' (24 bytes) and CWinHttpRequest.Send hands it a DVARIANT (56), which casts.
'' The extra 32 bytes landed past the end of the frame, on the saved registers of
'' whatever called it -- so a worker thread returned into the FreeBASIC runtime's
'' thread proxy with the FBTHREAD pointer it had kept in %rsi reading 1, and
'' tiko-editor died on the thread-exit path with its update check half done.
''
'' THE GOLDEN IS THE ASSERTION: the call to the operator has to be there at all, and
'' the copy made from its result has to be sized by the PARAMETER. tests/mir does not
'' run what it builds, and the difference at run time is 111 against 7.
''
'' The conversion is taken only into a destination that neither copies nor destroys --
'' see UdtCastToUdt_. Wide_ has neither, and nor has VARIANT.

type Narrow_
    a as longint
    b as longint
    c as longint
end type

type Wide_
    p as longint
    q as longint
    r as longint
    s as longint
    t as longint
    u as longint
    v as longint
    declare operator cast( ) as Narrow_
end type

operator Wide_.cast( ) as Narrow_
    dim as Narrow_ n
    n.a = 111
    n.b = 222
    n.c = 333
    return n
end operator

sub Take_( byval n as Narrow_ )
    print n.a; n.b; n.c
end sub

dim as Wide_ w
w.p = 7
w.q = 8
w.r = 9
Take_( w )
