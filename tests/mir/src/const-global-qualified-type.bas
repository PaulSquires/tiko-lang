'' 'const' MAY COME BEFORE A GLOBALLY-QUALIFIED TYPE NAME. AfxNova's AfxDWrite.bi writes
'' 'BYREF textureBounds AS const ..RECT' to reach the global RECT past its own namespace, and
'' tiko read the '..' only BEFORE 'const': that one header line was 'expected an identifier'
'' and failed 74 of the AfxNova examples measured for phase 12.
''
'' Measured on fbc-modern, this program prints: A 7 / B 7 / C 7 / D 7
type R2
    as long x, y
end type
namespace NS
    type R2
        as long q
    end type
    sub TakeA( byref r as const ..R2 )
        print "A"; r.x
    end sub
    sub TakeB( byref r as ..R2 )
        print "B"; r.x
    end sub
    sub TakeC( byval p as const ..R2 ptr )
        print "C"; p->x
    end sub
end namespace
sub TakeD( byref r as const R2 )
    print "D"; r.x
end sub
dim as R2 v : v.x = 7
NS.TakeA( v )
NS.TakeB( v )
NS.TakeC( @v )
TakeD( v )
