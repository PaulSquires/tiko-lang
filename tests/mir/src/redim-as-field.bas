'' A DECLARING REDIM INSIDE A METHOD NAMES THE FIELD when the AS type agrees.
''
'' AfxNova's CWindow grows its accelerator table with
''
''     REDIM PRESERVE m_rgAccelEntries(UBOUND(m_rgAccelEntries) + 1) AS ACCEL
''
'' and Collect declared that as a fresh LOCAL -- the field lookup found a SYM_FIELD, and
'' only a SYM_VARIABLE counted as "already exists". Every call sized its own shadow and
'' dropped it, CreateAcceleratorTable saw an empty field and returned no table, and
'' tiko-built tracks had no keyboard accelerators. It lowered and it verified.
''
'' Measured against fbc: the field is redimmed when the AS type agrees ('Grow' twice
'' leaves ubound 1), and a local is declared when it does not ('Mismatch' leaves the
'' field at -1). 'this.' was never affected -- a dotted target declares nothing.
type Entry
    fVirt as ubyte
    key as ushort
    cmd as ushort
end type

type Table
    dim items( any ) as Entry
    dim counts( any ) as long
    declare sub Grow( )
    declare sub GrowLong( )
    declare sub Mismatch( )
end type

sub Table.Grow( )
    redim preserve items( ubound( items ) + 1 ) as Entry
    items( ubound( items ) ).cmd = 1001
end sub

sub Table.GrowLong( )
    redim counts( 0 to 3 ) as long
end sub

sub Table.Mismatch( )
    redim counts( 0 to 2 ) as string
end sub

dim as Table t
t.Grow( )
t.Grow( )
t.GrowLong( )
t.Mismatch( )
