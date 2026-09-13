'' PACKED BITFIELD LAYOUT. Measured against fbc, sizeof: a1 1, a3 4, a4 2, a5 5, a6 8, a7 4,
'' a8 4, a9 5 with q at 4. The end of a type closes an open bitfield run at its unit's full
'' width, and a new run's unit starts at the region containing the cursor at the PACKED
'' alignment -- which is why a5's long unit starts at byte 1.
type a1 field=1 : as ubyte x :3 : as ulong y :3 : end type
type a3 field=1 : as long x :3 : end type
type a4 field=1 : as short x :3 : as short y :8 : end type
type a5 field=1 : as ubyte p : as long x :3 : end type
type a6 field=1 : as long x :20 : as long y :20 : end type
type a7 field=1 : as short x :3 : as short y :8 : as short z :8 : end type
type a8 field=2 : as long x :3 : end type
type a9 field=1 : as long x :3 : as ubyte q : end type
print sizeof(a1); sizeof(a3); sizeof(a4); sizeof(a5); sizeof(a6); sizeof(a7); sizeof(a8); sizeof(a9)
print offsetof(a9, q)
dim as a7 f
f.y = 123
f.z = 77
print f.y, f.z
