'' profile-parity.bas -- the profiler's string arena, hash tables, global
'' context and options: twenty-nine symbols.
''
'' NEEDS-GEN-LLVM
''
'' MOST OF THESE ARE NOT fb_-PREFIXED. STRING_TABLE_*, STRING_HASH_* and
'' PROFILER_GLOBAL_* are plain C names that fbc's profile_calls.o calls
'' directly, so they are ABI in exactly the same way an fb_ entry point is.
''
'' The structures are exercised through the entry points rather than by
'' inspecting memory: what has to match is the hash values, the block layout
'' the metrics report, and the find/insert behaviour.
''
'' WHAT HAS A PLAUSIBLE WRONG ANSWER:
''   - the hash function's exact shifts, which decide which block a string
''     lands in and therefore every metric below
''   - allocation sizes rounded up to a multiple of 4
''   - a collision moving to the next BLOCK, not the next slot
''   - an empty slot ENDING a search
''   - add_info comparing by pointer, not by content
''   - string_max_len NOT being cleared by METRICS_Clear

extern "c"
	declare function pHash alias "fb_ProfileHashName" ( byval p as zstring ptr ) as ulong
	declare function pTblAlloc alias "STRING_TABLE_alloc" ( byval s as any ptr, byval l as long ) as any ptr
	declare sub pTblCtor alias "STRING_TABLE_constructor" ( byval s as any ptr )
	declare sub pTblDtor alias "STRING_TABLE_destructor" ( byval s as any ptr )
	declare function pTblAdd alias "STRING_TABLE_add" ( byval s as any ptr, byval src as zstring ptr, byval h as ulong ) as any ptr
	declare function pTblMaxLen alias "STRING_TABLE_max_len" ( byval s as any ptr ) as long
	declare function pTbFind alias "STRING_HASH_TB_find" ( byval tb as any ptr, byval src as zstring ptr, byval h as ulong ) as any ptr
	declare function pHtFind alias "STRING_HASH_TABLE_find" ( byval ht as any ptr, byval src as zstring ptr, byval h as ulong ) as any ptr
	declare sub pHtCtor alias "STRING_HASH_TABLE_constructor" ( byval ht as any ptr, byval s as any ptr )
	declare sub pHtDtor alias "STRING_HASH_TABLE_destructor" ( byval ht as any ptr )
	declare function pHtAdd alias "STRING_HASH_TABLE_add" ( byval ht as any ptr, byval src as zstring ptr, byval h as ulong ) as any ptr
	declare function pHtAddInfo alias "STRING_HASH_TABLE_add_info" ( byval ht as any ptr, byval info as any ptr ) as any ptr
	declare sub pHCtor alias "STRING_HASH_constructor" ( byval h as any ptr, byval sh as any ptr )
	declare sub pHDtor alias "STRING_HASH_destructor" ( byval h as any ptr )
	declare sub pHAdd alias "STRING_HASH_add" ( byval h as any ptr, byval src as zstring ptr, byval hk as ulong )
	declare function pHFind alias "STRING_HASH_find" ( byval h as any ptr, byval src as zstring ptr, byval hk as ulong ) as any ptr
	declare function pAddIgnore alias "PROFILER_add_ignore" ( byval prof as any ptr, byval src as zstring ptr, byval h as ulong ) as zstring ptr
	declare sub pMClear alias "fb_hPROFILER_METRICS_Clear" ( byval m as any ptr )
	declare sub pMStrings alias "fb_hPROFILER_METRICS_Strings" ( byval m as any ptr, byval s as any ptr )
	declare sub pMHash alias "fb_hPROFILER_METRICS_HashTable" ( byval m as any ptr, byval ht as any ptr )
	declare sub pMGlobal alias "fb_hPROFILER_METRICS_Global" ( byval m as any ptr, byval g as any ptr )
	declare function pGCreate alias "PROFILER_GLOBAL_create" ( ) as any ptr
	declare sub pGDestroy alias "PROFILER_GLOBAL_destroy" ( )
end extern

extern "rtlib"
	declare function pGetGlobal alias "fb_ProfileGetGlobalProfiler" ( ) as any ptr
	declare function pSetName alias "fb_ProfileSetFileName" ( byval f as zstring ptr ) as long
	declare function pGetName alias "fb_ProfileGetFileName" ( byval f as zstring ptr, byval l as long ) as long
	declare function pGetOpts alias "fb_ProfileGetOptions" ( ) as long
	declare function pSetOpts alias "fb_ProfileSetOptions" ( byval o as long ) as long
	declare sub pIgnore alias "fb_ProfileIgnore" ( byval p as zstring ptr )
end extern

dim as long i = any, k = any

print "-- the hash function, over inputs that must not collapse"
dim shared as string hs(0 to 15)
hs( 0) = ""        : hs( 1) = "a"       : hs( 2) = "b"      : hs( 3) = "ab"
hs( 4) = "ba"      : hs( 5) = "(main)"  : hs( 6) = "(thread)"
hs( 7) = "(unnamed)" : hs( 8) = "MyProc" : hs( 9) = "myproc"
hs(10) = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
hs(11) = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB"
hs(12) = !"\255\254\253" : hs(13) = "0" : hs(14) = "00" : hs(15) = "000"
'' strptr( "" ) IS NULL in FreeBASIC, and fb_ProfileHashName does not check --
'' passing it segfaults BOTH runtimes identically, which the differential would
'' happily report as a pass. Every string goes through a real buffer instead.
dim shared as zstring * 64 zbuf
for i = 0 to 15
	zbuf = hs(i)
	print "  '"; hs(i); "' -> "; pHash( @zbuf )
next

'' The structures are opaque here; their sizes come from the C layout and are
'' allocated generously rather than mirrored, because this test is about
'' BEHAVIOUR and the layout is already pinned by fbc calling into these.
dim shared as ubyte tbl(0 to 63)
dim shared as ubyte ht(0 to 63)
dim shared as ubyte hsh(0 to 127)
dim shared as ubyte met(0 to 255)

print "-- the string arena: sizes, blocks and max length"
for i = 0 to 63
	tbl(i) = 0
next
pTblCtor( @tbl(0) )
dim shared as string adds(0 to 9)
adds(0) = "a" : adds(1) = "ab" : adds(2) = "abc" : adds(3) = "abcd"
adds(4) = "abcde" : adds(5) = "abcdef" : adds(6) = "abcdefg"
adds(7) = "" : adds(8) = "a" : adds(9) = string(200, "x")
for i = 0 to 9
	zbuf = left(adds(i), 63)
	dim as any ptr r = pTblAdd( @tbl(0), @zbuf, pHash( @zbuf ) )
	print "  add '"; left(adds(i), 12); "' nonnull="; iif(r <> 0, 1, 0)
next
print "  max_len="; pTblMaxLen( @tbl(0) )

for i = 0 to 255
	met(i) = 0
next
pMClear( @met(0) )
pMStrings( @met(0), @tbl(0) )
'' Field order is fixed by the C struct; read them positionally.
dim as long ptr mp = cptr( long ptr, @met(0) )
print "  metrics: threads="; mp[0]; " alloc="; mp[1]; " used="; mp[2]; " free="; mp[3]
print "           blocks="; mp[4]; " strings="; mp[5]; " maxlen="; mp[6]

print "-- an allocation too big for a block returns NULL"
print "  huge="; iif( pTblAlloc( @tbl(0), 100000 ) <> 0, 1, 0 )
print "  exact="; iif( pTblAlloc( @tbl(0), 10000 ) <> 0, 1, 0 )

'' Named buffers, for the same reason as zbuf above.
dim shared as zstring * 64 zb2, zb3, zb4, zb6
zb2 = adds(2) : zb3 = adds(3) : zb4 = adds(4) : zb6 = adds(6)

print "-- the hash table: find/insert, and identity on re-add"
for i = 0 to 63
	ht(i) = 0
next
pHtCtor( @ht(0), @tbl(0) )
print "  find-before-add="; iif( pHtFind( @ht(0), @zb2, pHash(@zb2) ) <> 0, 1, 0 )
dim as any ptr a1 = pHtAdd( @ht(0), @zb2, pHash(@zb2) )
dim as any ptr a2 = pHtAdd( @ht(0), @zb2, pHash(@zb2) )
print "  add nonnull="; iif( a1 <> 0, 1, 0 ); " re-add same="; iif( a1 = a2, 1, 0 )
print "  find-after-add="; iif( pHtFind( @ht(0), @zb2, pHash(@zb2) ) = a1, 1, 0 )
'' Many distinct keys, to force block chaining.
for i = 0 to 1200
	zbuf = "proc_" & i
	pHtAdd( @ht(0), @zbuf, pHash(@zbuf) )
next
for i = 0 to 255
	met(i) = 0
next
pMClear( @met(0) )
pMHash( @met(0), @ht(0) )
print "  hash metrics: alloc="; mp[7]; " blocks="; mp[8]; " items="; mp[9]; " slots="; mp[10]

print "-- add_info shares an entry between two tables, compared by pointer"
dim shared as ubyte ht2(0 to 63)
for i = 0 to 63
	ht2(i) = 0
next
pHtCtor( @ht2(0), @tbl(0) )
dim as any ptr shared_ = pHtAdd( @ht(0), @zb3, pHash(@zb3) )
dim as any ptr i1 = pHtAddInfo( @ht2(0), shared_ )
dim as any ptr i2 = pHtAddInfo( @ht2(0), shared_ )
print "  first="; iif( i1 = shared_, 1, 0 ); " second="; iif( i2 = shared_, 1, 0 )

print "-- STRING_HASH: the outer table borrows the inner one's arena"
for i = 0 to 127
	hsh(i) = 0
next
pHCtor( @hsh(0), @ht(0) )
pHAdd( @hsh(0), @zb4, pHash(@zb4) )
print "  find="; iif( pHFind( @hsh(0), @zb4, pHash(@zb4) ) <> 0, 1, 0 )
print "  miss="; iif( pHFind( @hsh(0), @zb6, pHash(@zb6) ) <> 0, 1, 0 )
pHDtor( @hsh(0) )

print "-- METRICS_Clear leaves string_max_len alone"
pMClear( @met(0) )
mp[6] = 4242
pMClear( @met(0) )
print "  max_len after clear="; mp[6]

pHtDtor( @ht2(0) )
pHtDtor( @ht(0) )
pTblDtor( @tbl(0) )

print "-- the global profiler: create is idempotent, options round-trip"
dim as any ptr g1 = pGCreate( )
dim as any ptr g2 = pGCreate( )
print "  created="; iif( g1 <> 0, 1, 0 ); " idempotent="; iif( g1 = g2, 1, 0 );
print " getter-agrees="; iif( pGetGlobal( ) = g1, 1, 0 )

print "  opts default="; pGetOpts( )
print "  set 0x1203 prev="; pSetOpts( &h1203 )
print "  get="; pGetOpts( )
print "  set 0 prev="; pSetOpts( 0 )

dim as zstring * 1024 namebuf = any
print "  setname ok="; pSetName( @"myprofile.txt" )
namebuf = string(1023, " ")
print "  getname rc="; pGetName( @namebuf, 1024 ); " -> '"; namebuf; "'"
print "  setname empty="; pSetName( @"" )
print "  setname null="; pSetName( 0 )
print "  getname len0="; pGetName( @namebuf, 0 )
print "  getname null="; pGetName( 0, 100 )

pIgnore( @"SomeProc" )
pIgnore( @"SomeProc" )
pIgnore( 0 )
for i = 0 to 255
	met(i) = 0
next
pMClear( @met(0) )
pMGlobal( @met(0), g1 )
print "  global metrics: strings="; mp[5]; " hash items="; mp[9]

pGDestroy( )
print "  after destroy="; iif( pGetGlobal( ) = 0, 1, 0 )
print "  opts after destroy="; pGetOpts( )
print "done"
