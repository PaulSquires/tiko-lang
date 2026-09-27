'' A SINGLE meeting a 64-bit integer stays a SINGLE. See tests/mir/single-vs-longint.test.
''
'' fbc-modern 1.20 prints:
''
''     single:-1-1-1-1-1-1-1-1
''     sum: 296.5 296.5 21978
''     sphere: 70992

dim as single f = 148.5
dim as longint q = 148
dim as ulongint uq = 148
dim as integer i = 148
dim as uinteger ui = 148
dim as long l = 148
dim as ulong ul = 148
print "single:"; ( f > q ); ( f > uq ); ( f > i ); ( f > ui ); ( f > l ); ( f > ul ); ( f > l + 0 ); ( f > ul - 0 )
print "sum:"; f + q; f + uq; f * ui

'' starshine.bas's sphere test: a SINGLE distance against 'ulong - 2', a LONGINT.
type V3
    as single x, y, z
    as ulong col
end type
function onsphere( byref S as V3, byref P as V3 ) as long
    dim as single dx = S.x - P.x, dy = S.y - P.y, dz = S.z - P.z
    return sqr( dx * dx + dy * dy + dz * dz ) <= S.col andalso _
           sqr( dx * dx + dy * dy + dz * dz ) > (S.col) - 2
end function
dim as long n = 0
dim as V3 sp = type<V3>( 1296, 810, 0, 150 )
for x as single = 1296 - 151 to 1296 + 151 step 2
    for y as single = 810 - 151 to 810 + 151 step 2
        for z as single = -151 to 151 step 2
            dim as V3 pt = type<V3>( x, y, z )
            if onsphere( sp, pt ) then n += 1
        next
    next
next
print "sphere:"; n
