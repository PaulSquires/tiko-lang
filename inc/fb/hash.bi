'' fb/hash.bi -- the hash contract for FB.Map and FB.Set
''
'' RFC-0004 §4.  A key type K is hashable if 'FB.HashOf( k )' resolves and 'k =
'' k' compares.  Overloads are supplied here for every built-in type; a user
'' type is made hashable by re-opening the namespace and adding one:
''
''     namespace FB
''         function HashOf( byref k as MyKey ) as ulongint
''             return HashOf( k.name ) xor culngint( k.id )
''         end function
''     end namespace
''
'' THE INVARIANT, and getting it wrong produces a container that loses data:
''
''     EQUAL KEYS MUST PRODUCE EQUAL HASH CODES.
''
'' The converse is not required -- two different keys may collide, and the
'' containers handle that.
''
'' Why an overloaded function rather than a 'HashCode( )' member, which is what
'' RFC-0004 §4 describes: a member cannot be added to 'long' or 'string', and a
'' generic body cannot branch on its type parameter.  'typeof( T )' inside a
'' generic sees the type parameter, not what it is bound to --
''
''     type Alias1 as long
''     #if typeof( Alias1 ) = typeof( long )   '' matches
''     #if typeof( T ) = typeof( long )        '' does NOT match, T bound to long
''
'' -- measured, not assumed.  So the dispatch has to be ordinary overload
'' resolution, which happens at the instantiation site where every overload is
'' in scope.
''
'' A key type with no matching overload fails at the instantiation site naming
'' HashOf, which is the unconstrained-generics diagnostic RFC-0001 describes.
''
'' EVERY OVERLOAD BELOW IS 'PRIVATE', as HashBytes and HashInt already were.
'' This is header-only code with no .bas behind it, so a public definition is
'' emitted into every module that includes the header -- and two modules in one
'' program then fail to link with ~18 'multiple definition of FB::HASHOF(...)'
'' errors, naming a standard-library function and neither of the two files
'' responsible.  fb/map.bi and fb/set.bi include this header, so without
'' 'private' a Map or a Set could be used from only ONE module per program.
'' Same rule as fb/decimal.bi and fb/chrono.bi.
''
'' A user overload added by re-opening the namespace needs 'private' too, but
'' only if it lives in a header that more than one module includes.

#pragma once

namespace FB

'' FNV-1a, 64-bit.  Small, adequate, no dependencies and unremarkable -- nothing
'' in the containers depends on the choice.
const FNV_OFFSET_BASIS as ulongint = 14695981039346656037ull
const FNV_PRIME        as ulongint = 1099511628211ull

private function HashBytes _
	( _
		byval p as const ubyte ptr, _
		byval n as uinteger _
	) as ulongint

	dim as ulongint h = FNV_OFFSET_BASIS

	'' n is UNSIGNED, so 'to n-1' with n = 0 counts to 4294967295 and walks off
	'' the end.  An empty literal reaches here through the ZSTRING PTR overload,
	'' which a "" argument prefers over the STRING one, so the empty case is not
	'' hypothetical -- it segfaulted on the first run.
	if( (p = 0) orelse (n = 0) ) then
		return h
	end if

	for i as uinteger = 0 to n-1
		h xor= p[i]
		h *= FNV_PRIME
	next

	function = h
end function

'' Integer mixing (splitmix64's finaliser).  An identity hash is fine for a
'' chaining table and bad for an open-addressed one: consecutive keys land in
'' consecutive slots and probe sequences pile up.
private function HashInt( byval v as ulongint ) as ulongint
	dim as ulongint h = v
	h xor= h shr 30
	h *= 13787848793156543929ull
	h xor= h shr 27
	h *= 10723151780598845931ull
	h xor= h shr 31
	function = h
end function

'' ---------------------------------------------------------------- integers

private function HashOf overload ( byval v as byte ) as ulongint
	function = HashInt( culngint( cast( ubyte, v ) ) )
end function

private function HashOf overload ( byval v as ubyte ) as ulongint
	function = HashInt( culngint( v ) )
end function

private function HashOf overload ( byval v as short ) as ulongint
	function = HashInt( culngint( cast( ushort, v ) ) )
end function

private function HashOf overload ( byval v as ushort ) as ulongint
	function = HashInt( culngint( v ) )
end function

private function HashOf overload ( byval v as long ) as ulongint
	function = HashInt( culngint( cast( ulong, v ) ) )
end function

private function HashOf overload ( byval v as ulong ) as ulongint
	function = HashInt( culngint( v ) )
end function

private function HashOf overload ( byval v as integer ) as ulongint
	function = HashInt( culngint( cast( uinteger, v ) ) )
end function

private function HashOf overload ( byval v as uinteger ) as ulongint
	function = HashInt( culngint( v ) )
end function

private function HashOf overload ( byval v as longint ) as ulongint
	function = HashInt( cast( ulongint, v ) )
end function

private function HashOf overload ( byval v as ulongint ) as ulongint
	function = HashInt( v )
end function

private function HashOf overload ( byval v as boolean ) as ulongint
	function = HashInt( iif( v, 1ull, 0ull ) )
end function

'' ------------------------------------------------------------------ floats
''
'' Hashed by their bit pattern, with one correction: +0.0 and -0.0 compare EQUAL
'' and have different bit patterns, so -0.0 is normalised.  Without this a
'' dictionary would lose an entry stored under -0.0 and looked up under 0.0.
''
'' NaN is left alone.  NaN <> NaN, so a NaN key can never be found again by
'' comparison whatever it hashes to; that is a property of the value, not of
'' this function.

private function HashOf overload ( byval v as single ) as ulongint
	dim as single f = v
	if( f = 0.0f ) then
		f = 0.0f
	end if
	function = HashInt( culngint( *cptr( ulong ptr, @f ) ) )
end function

private function HashOf overload ( byval v as double ) as ulongint
	dim as double d = v
	if( d = 0.0 ) then
		d = 0.0
	end if
	function = HashInt( *cptr( ulongint ptr, @d ) )
end function

'' ---------------------------------------------------------------- pointers

private function HashOf overload ( byval v as any ptr ) as ulongint
	function = HashInt( cast( ulongint, cast( uinteger, v ) ) )
end function

'' ----------------------------------------------------------------- strings
''
'' By CONTENT, not by address, because two strings with the same characters
'' compare equal and therefore must hash equal.

private function HashOf overload ( byref v as const string ) as ulongint
	if( len( v ) = 0 ) then
		return FNV_OFFSET_BASIS
	end if
	function = HashBytes( cptr( const ubyte ptr, strptr( v ) ), len( v ) )
end function

private function HashOf overload ( byval v as const zstring ptr ) as ulongint
	if( v = 0 ) then
		return FNV_OFFSET_BASIS
	end if
	function = HashBytes( cptr( const ubyte ptr, v ), len( *v ) )
end function

private function HashOf overload ( byval v as const wstring ptr ) as ulongint
	if( v = 0 ) then
		return FNV_OFFSET_BASIS
	end if
	function = HashBytes( cptr( const ubyte ptr, v ), len( *v ) * sizeof( wstring ) )
end function

'' USTRING.  Two code units per character on every host and target, so unlike the
'' WSTRING overload above this one's byte count is not host-dependent -- LEN( u )
'' counts CODE UNITS and each is exactly 2 bytes.  STRPTR on a var-len ustring
'' yields the DESCRIPTOR'S DATA pointer, not the descriptor's address.
''
'' Deliberately NOT expected to agree with HashOf( wstring ptr ) for the same
'' text: it does on Windows (wstring is 2 bytes) and cannot on Linux (4 bytes).
'' Nothing needs it to -- a container's key type is one type, and any conversion
'' to it happens before HashOf is reached.
private function HashOf overload ( byref v as const ustring ) as ulongint
	if( len( v ) = 0 ) then
		return FNV_OFFSET_BASIS
	end if
	function = HashBytes( cptr( const ubyte ptr, strptr( v ) ), len( v ) * 2 )
end function

end namespace
