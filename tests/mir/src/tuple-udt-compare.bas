'' A TUPLE ELEMENT THAT IS A UDT COMPARES THROUGH ITS OWN OPERATOR. Every aggregate
'' element was refused outright, so the whole comparison was MV_NONE and the IF around
'' it had no condition -- tuple/equality.bas's own subject, all three of its declines.
''
'' Measured, fbc calls the element operator on the two FIELD ADDRESSES and
'' short-circuits between elements:
''
''     int64 vr$8  = _ZeqR7WATCHEDS0_( TMP$2$0, TMP$3$0 );
''     if( vr$8 == 0ll) goto label$4;
''     int64 vr$13 = _ZeqR7WATCHEDS0_( TMP$2$0 + 4ll, TMP$3$0 + 4ll );
''
'' and run, with a mismatching first element it calls the operator ONCE.
dim shared as long cmps

type Watched
	as long v
end type

operator = ( byref a as Watched, byref b as Watched ) as integer
	cmps += 1
	return a.v = b.v
end operator

operator <> ( byref a as Watched, byref b as Watched ) as integer
	cmps += 1
	return a.v <> b.v
end operator

dim a as (Watched, Watched)
dim b as (Watched, Watched)
a._1.v = 1 : a._2.v = 2
b._1.v = 9 : b._2.v = 2

dim as long r
cmps = 0
if (a = b) then r = 1 else r = 0
print r; cmps

cmps = 0
if (a <> b) then r = 1 else r = 0
print r; cmps

'' When the first elements match, BOTH are compared.
b._1.v = 1
cmps = 0
if (a = b) then r = 1 else r = 0
print r; cmps
