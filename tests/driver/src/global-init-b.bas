'' Module two of the pair; see global-init-a.bas.
type T
    s as string
end type

dim shared gb as T

sub fromb( )
    gb.s = "b"
    print gb.s
end sub
