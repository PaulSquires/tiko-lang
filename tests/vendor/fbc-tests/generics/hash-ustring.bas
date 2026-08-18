' TEST_MODE : COMPILE_AND_RUN_OK

'' FB.HashOf( ustring ) -- the USTRING arm of the fb/hash.bi contract.
''
'' The invariant under test is the one in fb/hash.bi: EQUAL KEYS MUST PRODUCE
'' EQUAL HASH CODES.  For a ustring that means by CONTENT, across every form the
'' text can arrive in -- var-len, USTRING * N, literal, a copy -- and it must
'' hold for text no other overload can carry: non-ASCII BMP and surrogate pairs.
''
'' It also pins the two things adding an overload to a set can break: the empty
'' case (HashBytes walks off the end when n = 0 is not guarded) and the
'' resolution of every OTHER overload, which a new one can make ambiguous.

#include once "fb/hash.bi"
#include once "fb/map.bi"
#include once "fb/set.bi"
using FB

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

'' ------------------------------------------------------- content, not address
scope
	dim as ustring a = "hello"
	dim as ustring b = "hello"
	dim as ustring c = a
	dim as ustring d = "hellp"           '' one code unit apart
	dim as ustring e = "hell"            '' a prefix

	assert_( HashOf( a ) = HashOf( b ) )
	assert_( HashOf( a ) = HashOf( c ) )
	assert_( HashOf( a ) <> HashOf( d ) )
	assert_( HashOf( a ) <> HashOf( e ) )

	a = a + " there"                     '' still by content after a realloc
	b = "hello there"
	assert_( HashOf( a ) = HashOf( b ) )
end scope

'' ---------------------------------------------------------------- the empty
''
'' Guarded in HashBytes because n is UNSIGNED; unguarded it counts to 2^32-1.
'' The value is fixed to the FNV offset basis so an empty key is stable, not
'' merely non-crashing.
scope
	dim as ustring e
	dim as ustring e2 = ""

	assert_( len( e ) = 0 )
	assert_( HashOf( e ) = FNV_OFFSET_BASIS )
	assert_( HashOf( e ) = HashOf( e2 ) )
end scope

'' ------------------------------------------------------------- USTRING * N
''
'' A fixed ustring IS the buffer, so STRPTR takes a different compiler path than
'' the var-len descriptor does.  Same text must still hash the same, or a key
'' stored from one form is lost when looked up with the other.
scope
	dim as ustring * 8 f = "hello"
	dim as ustring v = "hello"

	assert_( len( f ) = 5 )              '' text length, not capacity
	assert_( HashOf( f ) = HashOf( v ) )
end scope

'' ---------------------------------------------------- non-ASCII and astral
''
'' Built from raw code units rather than source text, so the test file stays
'' ASCII and the assertion does not depend on how the lexer decoded it.
scope
	dim as ustring * 4 emoji           '' U+1F600, one surrogate pair
	emoji[0] = &hD83D
	emoji[1] = &hDE00
	emoji[2] = 0

	dim as ustring * 4 emoji2          '' U+1F601, differs in the LOW surrogate
	emoji2[0] = &hD83D
	emoji2[1] = &hDE01
	emoji2[2] = 0

	dim as ustring copied = emoji

	assert_( len( emoji ) = 2 )                    '' code units, not characters
	assert_( HashOf( emoji ) = HashOf( copied ) )
	assert_( HashOf( emoji ) <> HashOf( emoji2 ) ) '' the tail unit is hashed

	'' A high code unit must not be truncated to a byte: U+0041 and U+4100 share
	'' a low byte and differ only in the high one.
	dim as ustring * 2 hi
	hi[0] = &h4100
	hi[1] = 0
	dim as ustring * 2 lo
	lo[0] = &h0041
	lo[1] = 0
	assert_( HashOf( hi ) <> HashOf( lo ) )
end scope

'' -------------------------------------------- the other overloads still bind
''
'' A literal must still prefer the ZSTRING PTR overload, and a STRING must still
'' reach the STRING one -- adding a USTRING overload is exactly the change that
'' can turn either into an ambiguity or a silent re-binding.
scope
	dim as string s = "hello"
	dim as string s2 = "hello"
	dim as wstring * 8 w = wstr( "hello" )
	dim as wstring * 8 w2 = wstr( "hello" )
	dim as zstring * 8 z = "hello"

	assert_( HashOf( "hello" ) = HashOf( s ) )   '' literal -> the ZSTRING PTR arm
	assert_( HashOf( s ) = HashOf( s2 ) )
	assert_( HashOf( @z ) = HashOf( s ) )
	assert_( HashOf( @w ) = HashOf( @w2 ) )
	assert_( HashOf( cptr( const wstring ptr, 0 ) ) = FNV_OFFSET_BASIS )
	assert_( HashOf( 5 ) = HashOf( 5ull ) )
end scope

'' ------------------------------------------- and therefore usable as a key
scope
	dim as Map( of ustring, long ) m

	assert_( m.Add( "alpha", 1 ) )
	assert_( m.Add( "beta", 2 ) )
	assert_( m.Add( "", 3 ) )            '' the empty key is a real key
	assert_( m.Add( "alpha", 9 ) = false )
	assert_( m.Count( ) = 3 )

	dim as ustring k = "alpha"
	assert_( m.Contains( k ) )
	assert_( m[ k ] = 1 )
	assert_( m[ "" ] = 3 )
	assert_( m.Contains( "nope" ) = false )

	dim as long got
	assert_( m.TryGet( "beta", got ) )
	assert_( got = 2 )

	assert_( m.Remove( "" ) )
	assert_( m.Count( ) = 2 )
	assert_( m.Contains( "" ) = false )

	'' enough distinct keys to force rehashes, then all of them found again --
	'' the invariant failing shows up here and nowhere else
	dim as Map( of ustring, long ) big
	for i as long = 0 to 199
		dim as ustring ki = "k" + str( i )
		big.Put( ki, i )
	next
	assert_( big.Count( ) = 200 )
	for i as long = 0 to 199
		dim as ustring ki = "k" + str( i )
		assert_( big.Contains( ki ) )
		assert_( big[ ki ] = i )
	next
end scope

scope
	dim as Set( of ustring ) st

	assert_( st.Add( "x" ) )
	assert_( st.Add( "x" ) = false )
	assert_( st.Add( "y" ) )
	assert_( st.Add( "" ) )
	assert_( st.Count( ) = 3 )
	assert_( st.Contains( "x" ) )
	assert_( st.Contains( "" ) )
	assert_( st.Contains( "z" ) = false )
	assert_( st.Remove( "x" ) )
	assert_( st.Count( ) = 2 )
end scope
