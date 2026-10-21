'' std/containers Map and Set under put/remove churn over DISTINCT keys.
''
'' Reserve returned early whenever the live count fit, so the tombstones a churn
'' leaves were never dropped: after 8 cycles at capacity 8 there was no EMPTY slot
'' to end a probe, and every later Put / Add dropped its key and returned FALSE.
#import "std/containers"

dim m as containers.Map( of string, long )
dim s as containers.Set( of string )
dim as long v, bad, maxcap

'' one live entry at a time
for c as long = 1 to 1000
	dim as string k = "doc" & c
	if( m.Put( k, c ) = false ) then bad += 1
	if( m.Count( ) <> 1 ) then bad += 1
	if( m.TryGet( k, v ) = false ) then bad += 1
	if( v <> c ) then bad += 1
	if( s.Add( k ) = false ) then bad += 1
	if( s.Contains( k ) = false ) then bad += 1
	m.Remove( k )
	s.Remove( k )
	if( m.Capacity( ) > maxcap ) then maxcap = m.Capacity( )
next
print "single " & bad & " " & m.Count( ) & " " & s.Count( ) & " " & maxcap

'' five live entries -- just under the load factor at capacity 8 -- and churn
bad = 0 : maxcap = 0
for c as long = 1 to 5
	m.Put( "keep" & c, c )
	s.Add( "keep" & c )
next
for c as long = 1 to 1000
	dim as string k = "tmp" & c
	if( m.Put( k, c ) = false ) then bad += 1
	if( s.Add( k ) = false ) then bad += 1
	m.Remove( k )
	s.Remove( k )
	if( m.Capacity( ) > maxcap ) then maxcap = m.Capacity( )
next
for c as long = 1 to 5
	if( m.TryGet( "keep" & c, v ) = false ) then bad += 1
	if( v <> c ) then bad += 1
	if( s.Contains( "keep" & c ) = false ) then bad += 1
next
print "steady " & bad & " " & m.Count( ) & " " & s.Count( ) & " " & maxcap

'' the indexer inserts through Put, then reads the slot Put chose
dim n as containers.Map( of long, long )
bad = 0
for c as long = 1 to 1000
	n[ c ] += c
	if( n[ c ] <> c ) then bad += 1
	n.Remove( c )
next
print "indexer " & bad & " " & n.Count( ) & " " & n.Capacity( )
