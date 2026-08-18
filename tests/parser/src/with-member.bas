'' '.field' with nothing before it is the WITH shorthand.
type T
    as long i
    as long j
end type

sub F( )
    dim as T x
    with x
        '' A BLOCK if with an EMPTY body. It is only distinguishable from a
        '' single-line IF by what follows 'then', so a parse error in the condition
        '' turns one into the other.
        if 0 = len( .i ) then
        end if
        print .i, .j
        .i = 1
        if .i = 1 then .j = 2
    end with
end sub
