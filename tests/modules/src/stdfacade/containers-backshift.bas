'' std/containers Map and Set: backward-shift deletion, fingerprints, and the
'' copy-only-when-growing insert.
''
'' PlacedKey picks its own home slot and fingerprint: HashOf returns the number
'' that, multiplied by CONTAINERS_FIB_MULT, has the home in its top 3 bits (a
'' capacity-8 table) and the fingerprint in the 7 under them.  So a run can be
'' laid across the end of the table and the slots read back exactly.
#import "std/containers"

const FIB as ulongint = 11400714819323198485ull

'' FIB's inverse mod 2^64 (Newton: each step doubles the correct low bits)
function FibInverse( ) as ulongint
	dim as ulongint x = FIB
	for i as long = 1 to 6
		x *= 2ull - FIB * x
	next
	return x
end function

dim shared as ulongint inv

type PlacedKey extends containers.Hashable
	as long id, home, fp
	declare function HashOf( ) as ulongint override
end type

operator = ( byref x as PlacedKey, byref y as PlacedKey ) as boolean
	return x.id = y.id
end operator

function PlacedKey.HashOf( ) as ulongint
	return ( ( culngint( home ) shl 61 ) or ( culngint( fp ) shl 54 ) or culngint( id ) ) * inv
end function

function PK( byval id as long, byval home as long, byval fp as long = 5 ) as PlacedKey
	dim k as PlacedKey
	k.id = id : k.home = home : k.fp = fp
	return k
end function

'' "slot:id" for each slot of a capacity-8 map, "-" for EMPTY
function Layout( byref m as containers.Map( of PlacedKey, long ) ) as string
	dim as string r
	for i as long = 0 to m.Capacity( ) - 1
		if( m.SlotUsed( i ) ) then
			r &= " " & m.SlotKey( i ).id
		else
			r &= " -"
		end if
	next
	return r
end function

inv = FibInverse( )
if( FIB * inv = 1 ) then
	print "inverse ok"
else
	print "inverse wrong"
end if

'' a run across the end: 1 2 3 home at 7 and sit at 7 0 1, 4 homes at 0 and sits at 2.
'' Removing 1 shifts 2 to 7 and 3 to 0, and 4 back to 1 -- the hole is between its
'' home and its slot.  Every key shares one fingerprint, so each probe compares keys.
scope
	dim m as containers.Map( of PlacedKey, long )
	m.Reserve( 6 )
	m.Put( PK( 1, 7 ), 10 )
	m.Put( PK( 2, 7 ), 20 )
	m.Put( PK( 3, 7 ), 30 )
	m.Put( PK( 4, 0 ), 40 )
	print "wrap cap " & m.Capacity( ) & ":" & Layout( m )
	m.Remove( PK( 1, 7 ) )
	print "wrap after:" & Layout( m )
	dim as long bad = 0, v
	for id as long = 2 to 4
		if( m.TryGet( PK( id, iif( id = 4, 0, 7 ) ), v ) = false orelse v <> id * 10 ) then bad += 1
	next
	if( m.Contains( PK( 1, 7 ) ) ) then bad += 1
	print "wrap found " & bad & " " & m.Count( )
end scope

'' an entry that must stay: 1 homes at 7, 2 and 3 at 0 and sit at 0 and 1.  The hole
'' left at 7 is in front of their home, so neither moves.
scope
	dim m as containers.Map( of PlacedKey, long )
	m.Reserve( 6 )
	m.Put( PK( 1, 7 ), 10 )
	m.Put( PK( 2, 0 ), 20 )
	m.Put( PK( 3, 0 ), 30 )
	m.Remove( PK( 1, 7 ) )
	print "stay:" & Layout( m )
end scope

'' different fingerprints at one home: a fingerprint mismatch is never a match
scope
	dim m as containers.Map( of PlacedKey, long )
	dim as long bad = 0, v
	for id as long = 1 to 5
		m.Put( PK( id, 3, id ), id )
	next
	for id as long = 1 to 5
		if( m.TryGet( PK( id, 3, id ), v ) = false orelse v <> id ) then bad += 1
	next
	if( m.Contains( PK( 9, 3, 1 ) ) ) then bad += 1
	m.Remove( PK( 3, 3, 3 ) )
	for id as long = 1 to 5
		if( m.Contains( PK( id, 3, id ) ) <> ( id <> 3 ) ) then bad += 1
	next
	print "fingerprints " & bad & " " & m.Count( )
end scope

'' Put( k, m[ k ] ) is a self-assignment; Put( new, m[ old ] ) and m[ new ] = m[ old ]
'' across every growth point read a value the rehash moves
scope
	dim m as containers.Map( of string, string )
	dim as long bad = 0
	m.Put( "k0", "v0" )
	m.Put( "k0", m[ "k0" ] )
	if( m[ "k0" ] <> "v0" ) then bad += 1
	for i as long = 1 to 300
		m.Put( "k" & i, m[ "k" & ( i - 1 ) ] )
		if( m[ "k" & i ] <> "v0" ) then bad += 1
	next
	dim n as containers.Map( of string, string )
	for i as long = 1 to 300
		n.Put( "a" & i, "b" & i )
		n[ "c" & i ] = n[ "a" & i ]
	next
	for i as long = 1 to 300
		if( n[ "c" & i ] <> "b" & i ) then bad += 1
	next
	'' Add never overwrites and inserts a copy
	dim as string s = "fresh"
	if( n.Add( "a1", s ) ) then bad += 1
	if( n.Add( "new", s ) = false ) then bad += 1
	s = "changed"
	if( n[ "new" ] <> "fresh" orelse n[ "a1" ] <> "b1" ) then bad += 1
	print "alias " & bad & " " & m.Count( ) & " " & n.Count( )
end scope

'' remove every key, in an order that shifts runs constantly, re-adding as it goes
scope
	dim m as containers.Map( of string, long )
	dim s as containers.Set( of long )
	dim as long bad = 0, v
	for i as long = 0 to 4999
		m.Put( "key" & i, i )
		s.Add( i * 7 )
	next
	for i as long = 0 to 4999 step 3
		if( m.Remove( "key" & i ) = false ) then bad += 1
		if( s.Remove( i * 7 ) = false ) then bad += 1
	next
	for i as long = 0 to 4999
		dim as boolean want = ( i mod 3 ) <> 0
		if( m.TryGet( "key" & i, v ) <> want ) then bad += 1
		if( want andalso v <> i ) then bad += 1
		if( s.Contains( i * 7 ) <> want ) then bad += 1
	next
	dim as long seen = 0
	for each kv in m
		if( kv.value mod 3 = 0 ) then bad += 1
		seen += 1
	next
	if( seen <> m.Count( ) ) then bad += 1
	print "bulk " & bad & " " & m.Count( ) & " " & s.Count( )
end scope

'' NOTHING IS COPIED: a rehash and a backward shift SWAP keys and values into their new
'' slots, so a stored string keeps its character buffer from insertion to removal.  The
'' buffer is read through a BYREF parameter -- strptr( m.SlotKey( s ) ) would measure a
'' temporary copy.  (A byref INTO the map, m[ k ] or SlotKey's result, is the slot itself,
'' and that does move: it is invalid after any growth or Remove, as documented.)
function DataOf( byref s as string ) as any ptr
	return strptr( s )
end function

scope
	const SN = 3000
	dim m as containers.Map( of string, string )
	dim s as containers.Set( of string )
	dim as any ptr kp( 0 to SN - 1 ), vp( 0 to SN - 1 ), ep( 0 to SN - 1 )
	dim as long bad = 0, growths = 0, lastcap = 0, sl

	'' the probe itself: one buffer is one buffer, a copy is another
	dim as string a = "probe-" & SN
	dim as string b = a
	if( DataOf( a ) <> DataOf( a ) orelse DataOf( a ) = DataOf( b ) ) then bad += 1

	for i as long = 0 to SN - 1
		dim as string k = "stable-" & i
		m.Put( k, "value-" & i )
		s.Add( k )
		sl = m.FindSlot( k )
		kp( i ) = DataOf( m.SlotKey( sl ) )
		vp( i ) = DataOf( m.SlotValue( sl ) )
		ep( i ) = DataOf( s.SlotValue( s.FindSlot( k ) ) )
		if( m.Capacity( ) <> lastcap ) then
			growths += 1
			lastcap = m.Capacity( )
		end if
	next

	'' remove every third key: the runs behind them shift back
	for i as long = 0 to SN - 1 step 3
		m.Remove( "stable-" & i )
		s.Remove( "stable-" & i )
	next

	for i as long = 0 to SN - 1
		dim as string k = "stable-" & i
		sl = m.FindSlot( k )
		if( ( i mod 3 ) = 0 ) then
			if( sl >= 0 orelse s.Contains( k ) ) then bad += 1
		elseif( sl < 0 ) then
			bad += 1
		else
			if( DataOf( m.SlotKey( sl ) ) <> kp( i ) ) then bad += 1
			if( DataOf( m.SlotValue( sl ) ) <> vp( i ) ) then bad += 1
			if( m.SlotValue( sl ) <> "value-" & i ) then bad += 1
			sl = s.FindSlot( k )
			if( sl < 0 ) then
				bad += 1
			elseif( DataOf( s.SlotValue( sl ) ) <> ep( i ) ) then
				bad += 1
			end if
		end if
	next
	print "stable " & bad & " " & ( growths >= 9 ) & " " & m.Count( ) & " " & s.Count( )
end scope

'' a set operated on with itself
scope
	dim s as containers.Set( of string )
	for i as long = 1 to 100
		s.Add( "e" & i )
	next
	s.UnionWith( s )
	dim as long a = s.Count( )
	s.IntersectWith( s )
	dim as long b = s.Count( )
	s.ExceptWith( s )
	print "self " & a & " " & b & " " & s.Count( )
end scope
