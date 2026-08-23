'' A SHARED loop counter takes its width from the GLOBALS table, not the locals one.
''
'' LowerFor indexed c.f->locals by addr.id without looking at addr.kind, so a shared
'' counter read the type of an unrelated LOCAL -- in practice $tmp0, the result slot,
'' which meant the counter silently took the enclosing function's RETURN TYPE. Both
'' loops below compared as i64 only by accident of the return type; the boolean one
'' truncated an INTEGER counter to eight bits.
''
'' And a SUB has no result slot at all, so locals was EMPTY and tiko-lang segfaulted.

dim shared idx as integer
dim shared cnt as integer = 3

sub g( )
    for idx = 1 to cnt
    next
end sub

function f( ) as boolean
    for idx = 1 to cnt
    next
    return false
end function

'' A LOCAL counter still takes its own type, including a narrow one.
sub h( )
    for k as short = 1 to 3
    next
end sub

g( )
