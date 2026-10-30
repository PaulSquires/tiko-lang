'' '#pragma push_macro( "X" )' / 'pop_macro( "X" )' save a macro as it stands and put it
'' back (src/pp/pppushmacro.tiko). Every '#error' below is a failed expectation.
#define SEEK_SET 0
#define F( a ) ( a + 1 )

'' The use that asked for it: declare a name the reader holds as a macro, keep the macro.
namespace px
#pragma push_macro( "SEEK_SET" )
#undef SEEK_SET
#ifdef SEEK_SET
#error "#undef after push_macro left SEEK_SET defined"
#endif
const SEEK_SET = 7
#pragma pop_macro( "SEEK_SET" )
end namespace
#ifndef SEEK_SET
#error "pop_macro did not bring SEEK_SET back"
#endif
#if SEEK_SET <> 0
#error "pop_macro brought SEEK_SET back with another value"
#endif

'' A name that was no macro comes back as none.
#pragma push_macro( "NOT_A_MACRO" )
#define NOT_A_MACRO 1
#pragma pop_macro( "NOT_A_MACRO" )
#ifdef NOT_A_MACRO
#error "pop_macro left NOT_A_MACRO defined"
#endif

'' A redefinition in between is undone, a function-like macro's too; the bare form works.
#pragma push_macro( F )
#undef F
#define F( a ) ( a * 100 )
#if F( 2 ) <> 200
#error "F was not redefined"
#endif
#pragma pop_macro( F )
#if F( 2 ) <> 3
#error "pop_macro did not restore F"
#endif

'' Pushes of one name nest, and two names interleave.
#define N 1
#pragma push_macro( "N" )
#undef N
#define N 2
#pragma push_macro( "SEEK_SET" )
#pragma push_macro( "N" )
#undef N
#define N 3
#pragma pop_macro( "N" )
#if N <> 2
#error "the inner pop_macro( N ) did not give 2"
#endif
#pragma pop_macro( "SEEK_SET" )
#pragma pop_macro( "N" )
#if N <> 1
#error "the outer pop_macro( N ) did not give 1"
#endif

'' Names are case-insensitive, as identifiers are.
#pragma push_macro( "seek_set" )
#undef SEEK_SET
#pragma pop_macro( "Seek_Set" )
#ifndef SEEK_SET
#error "pop_macro( ""Seek_Set"" ) did not restore SEEK_SET"
#endif

'' px.SEEK_SET is a const of its own: 'px.SEEK_SET' would expand the macro after the dot,
'' as any identifier does, so the macro goes first.
#undef SEEK_SET
dim as integer r = px.SEEK_SET + F( 1 )
print r
