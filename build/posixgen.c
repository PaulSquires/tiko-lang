/* posixgen.c -- measure this host's POSIX ABI and print it as tiko: the binding tiko-rt's
   and pkg/std's POSIX code is written against.

       build/posixgen.sh            builds this with the host's clang, runs it, and writes
                                    lib/rt/src/inc/sysbind/<target>-posix.ti and the
                                    identical pkg/sys/posix/<target>-posix.ti

   THE PROBE IS THE GROUND TRUTH. Every value in the output is what this host's C compiler
   and C library say -- a macro's value, a type's sizeof and _Alignof, a member's offsetof --
   never a number read from a header or a manual and typed in. It runs unchanged on every
   POSIX host (linux-x86_64 under WSL, macos-arm64 on the Mac), each producing its own
   target's file, and the files are committed so a build needs no C compiler.

   WHAT IS MEASURED is build/posix.spec, a list of X-macro lines this file includes twice:
   once with POSIX_SPEC_INCLUDES defined, for its #include lines, and once to emit. The spec
   is C, so a line that exists on one OS only sits under #ifdef there.

       SECTION( "title" )                    a comment line in the output
       CONST( NAME )                         const NAME = <value of the C macro NAME>
       CONST_AS( fbname, expr )              const fbname = <value of expr>
       SIZEOF( fbname, ctype )               const fbname = sizeof( ctype )
       OFFSETOF( fbname, ctype, member )     const fbname = offsetof( ctype, member )
       TYPEDEF( fbname, ctype )              type fbname as <integer or pointer of its size>
       OPAQUE( fbname, ctype )               a type of ctype's size and alignment, no fields
       STRUCT( fbname, ctype ) ... END_STRUCT
           F_INT( fb, member )               an integer field: its size and signedness
           F_PTR( fb, member )               any ptr (also a function pointer)
           F_ZPTR( fb, member )              zstring ptr
           F_CHARS( fb, member )             zstring * <the char array's size>
           F_ARRAY( fb, member )             an array of integers: element size and count
           F_STRUCT( fb, member, fbtype )    a field of a type emitted earlier

   A STRUCT IS EMITTED WITH EXPLICIT PADDING. Its fields are sorted by offset, every gap
   becomes a __padN byte array and the tail is padded to sizeof, so the tiko type has C's
   layout by construction; fields the spec does not list are padding. A struct whose C
   layout puts a field off its natural alignment (packed) is emitted 'field = 1'. Every
   size and every listed offset is then #assert-ed in the output, so a tiko that lays a
   TYPE out differently fails to compile the binding instead of reading the wrong bytes.

   THE OUTPUT IS ONE NAMESPACE, posix, and its includer says 'using posix'. tiko-rt includes
   it through inc/sysbind.ti and every std module that needs it as a private header through
   pkg/sys/posix/posix.ti. The namespace is what lets it travel: a std module's interface
   carries the header to every importer (its libc declares name these types), and there a
   bare 'const O_RDONLY' would forbid crt.bi's '#define O_RDONLY' (TKO0371) -- a qualified
   posix.O_RDONLY does not (pkg/sys/posix/posix.ti says more). Constants are untyped, as the
   hand-written ones they replace were, so an expression using one keeps the type it had. */

#if defined( __linux__ )
#define _GNU_SOURCE 1
#elif defined( __APPLE__ )
#define _DARWIN_C_SOURCE 1
#endif

#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define POSIX_SPEC_INCLUDES 1
#include "posix.spec"
#undef POSIX_SPEC_INCLUDES

/* ------------------------------------------------------------------ constants */

#define IS_UNSIGNED( x ) _Generic( ( x ), \
    unsigned char: 1, unsigned short: 1, unsigned int: 1, unsigned long: 1, \
    unsigned long long: 1, default: 0 )

static void put_value( const char *name, int is_unsigned, long long sv, unsigned long long uv )
{
    printf( "const %s = ", name );
    if( is_unsigned ) {
        if( uv <= 0x7FFFFFFFull ) printf( "%llu\n", uv );
        else                      printf( "&h%llX\n", uv );
    } else {
        printf( "%lld\n", sv );
    }
}

#define CONST_AS( FB, X ) \
    put_value( #FB, IS_UNSIGNED( X ), (long long)( X ), (unsigned long long)( X ) );
/* Stringified here, not through CONST_AS: a macro argument is expanded before it is
   passed on, and the name would print as its own value. */
#define CONST( N ) put_value( #N, IS_UNSIGNED( N ), (long long)( N ), (unsigned long long)( N ) );
#define SIZEOF( FB, CT ) \
    printf( "const %s = %zu\n", #FB, sizeof( CT ) );
#define OFFSETOF( FB, CT, M ) \
    printf( "const %s = %zu\n", #FB, offsetof( CT, M ) );
#define SECTION( T ) printf( "\n'' ---- %s\n\n", T );

/* -------------------------------------------------------------------- types */

static const char *int_type( size_t size, int is_signed )
{
    switch( size ) {
    case 1: return is_signed ? "int8" : "uint8";
    case 2: return is_signed ? "int16" : "uint16";
    case 4: return is_signed ? "int32" : "uint32";
    case 8: return is_signed ? "int64" : "uint64";
    }
    fprintf( stderr, "posixgen: no integer type of %zu bytes\n", size );
    exit( 1 );
}

/* An integer typedef is signed when -1 converted to it is below zero; a pointer one
   (pthread_t on Darwin) is classified by the compiler. */
#define TYPEDEF( FB, CT ) \
    if( __builtin_classify_type( (CT)0 ) == 5 ) \
        printf( "type %s as any ptr\n", #FB ); \
    else \
        printf( "type %s as %s\n", #FB, int_type( sizeof( CT ), (CT)-1 < (CT)0 ) );

/* The natural alignment of every type emitted so far, by name, for nested fields. */
#define MAX_TYPES 256
static struct { char name[64]; size_t align; } known[MAX_TYPES];
static int nknown;

static void remember( const char *name, size_t align )
{
    if( nknown == MAX_TYPES ) { fprintf( stderr, "posixgen: too many types\n" ); exit( 1 ); }
    snprintf( known[nknown].name, sizeof known[nknown].name, "%s", name );
    known[nknown++].align = align;
}

static size_t align_of( const char *name )
{
    for( int i = 0; i < nknown; i++ )
        if( strcmp( known[i].name, name ) == 0 ) return known[i].align;
    fprintf( stderr, "posixgen: field type %s is not emitted before its use\n", name );
    exit( 1 );
}

static void put_opaque( const char *name, size_t size, size_t align )
{
    const char *elem = align >= 8 ? "uint64" : align == 4 ? "uint32" : align == 2 ? "uint16" : "uint8";
    size_t esize = align >= 8 ? 8 : align == 4 ? 4 : align == 2 ? 2 : 1;
    if( size % esize ) { fprintf( stderr, "posixgen: %s: size %zu not a multiple of %zu\n", name, size, esize ); exit( 1 ); }
    printf( "type %s\n    __opaque( 0 to %zu ) as %s\nend type\n", name, size / esize - 1, elem );
    printf( "#assert sizeof( %s ) = %zu\n", name, size );
    remember( name, esize );
}

#define OPAQUE( FB, CT ) put_opaque( #FB, sizeof( CT ), _Alignof( CT ) );

/* One STRUCT's fields, collected, then sorted and padded at END_STRUCT. */
#define MAX_FIELDS 64
typedef struct {
    char name[64];
    char type[64];       /* the tiko element type */
    size_t off, size, align;
    size_t count;        /* > 0: an array of that many elements; 0: a scalar */
} field_t;

static field_t fields[MAX_FIELDS];
static int nfields;
static char sname[64];
static size_t ssize, salign;

static void struct_begin( const char *name, size_t size, size_t align )
{
    snprintf( sname, sizeof sname, "%s", name );
    ssize = size; salign = align; nfields = 0;
}

static void add_field( const char *name, size_t off, size_t size, size_t align,
                       const char *type, size_t count )
{
    if( nfields == MAX_FIELDS ) { fprintf( stderr, "posixgen: %s: too many fields\n", sname ); exit( 1 ); }
    field_t *f = &fields[nfields++];
    snprintf( f->name, sizeof f->name, "%s", name );
    snprintf( f->type, sizeof f->type, "%s", type );
    f->off = off; f->size = size; f->align = align; f->count = count;
}

static int by_offset( const void *a, const void *b )
{
    const field_t *x = a, *y = b;
    return x->off < y->off ? -1 : x->off > y->off;
}

static void struct_end( void )
{
    int packed = 0, npad = 0;
    size_t at = 0;

    qsort( fields, nfields, sizeof fields[0], by_offset );
    for( int i = 0; i < nfields; i++ ) {
        if( fields[i].off < at ) {
            fprintf( stderr, "posixgen: %s.%s overlaps the field before it\n", sname, fields[i].name );
            exit( 1 );
        }
        if( fields[i].off % fields[i].align ) packed = 1;
        at = fields[i].off + fields[i].size;
    }
    if( at > ssize ) { fprintf( stderr, "posixgen: %s: fields run past sizeof\n", sname ); exit( 1 ); }

    printf( "type %s%s\n", sname, packed ? " field = 1" : "" );
    at = 0;
    for( int i = 0; i < nfields; i++ ) {
        field_t *f = &fields[i];
        if( f->off > at ) printf( "    __pad%d( 0 to %zu ) as uint8\n", npad++, f->off - at - 1 );
        if( f->count ) printf( "    %s( 0 to %zu ) as %s\n", f->name, f->count - 1, f->type );
        else           printf( "    %s as %s\n", f->name, f->type );
        at = f->off + f->size;
    }
    if( ssize > at ) printf( "    __pad%d( 0 to %zu ) as uint8\n", npad++, ssize - at - 1 );
    printf( "end type\n#assert sizeof( %s ) = %zu\n", sname, ssize );
    for( int i = 0; i < nfields; i++ )
        printf( "#assert offsetof( %s, %s ) = %zu\n", sname, fields[i].name, fields[i].off );
    remember( sname, packed ? 1 : salign );
}

#define STRUCT( FB, CT ) { typedef CT T_; struct_begin( #FB, sizeof( T_ ), _Alignof( T_ ) );
#define END_STRUCT struct_end( ); }

#define M_SIZE( M ) sizeof( ( (T_ *)0 )->M )
#define F_INT( FB, M ) \
    add_field( #FB, offsetof( T_, M ), M_SIZE( M ), M_SIZE( M ), \
               int_type( M_SIZE( M ), (__typeof__( ( (T_ *)0 )->M ))-1 < 0 ), 0 );
#define F_PTR( FB, M ) add_field( #FB, offsetof( T_, M ), M_SIZE( M ), M_SIZE( M ), "any ptr", 0 );
#define F_ZPTR( FB, M ) add_field( #FB, offsetof( T_, M ), M_SIZE( M ), M_SIZE( M ), "zstring ptr", 0 );
#define F_CHARS( FB, M ) { \
    char t_[32]; snprintf( t_, sizeof t_, "zstring * %zu", M_SIZE( M ) ); \
    add_field( #FB, offsetof( T_, M ), M_SIZE( M ), 1, t_, 0 ); }
#define F_ARRAY( FB, M ) \
    add_field( #FB, offsetof( T_, M ), M_SIZE( M ), M_SIZE( M[0] ), \
               int_type( M_SIZE( M[0] ), (__typeof__( ( (T_ *)0 )->M[0] ))-1 < 0 ), \
               M_SIZE( M ) / M_SIZE( M[0] ) );
#define F_STRUCT( FB, M, TY ) \
    add_field( #FB, offsetof( T_, M ), M_SIZE( M ), align_of( #TY ), #TY, 0 );

/* --------------------------------------------------------------------- main */

int main( int argc, char **argv )
{
    const char *target = argc > 1 ? argv[1] : "?";
    const char *host = argc > 2 ? argv[2] : "?";
    const char *cc = argc > 3 ? argv[3] : "?";
    const char *libc = argc > 4 ? argv[4] : "?";

    printf( "'' %s-posix.ti -- the POSIX constants and struct layouts of %s, as tiko.\n", target, target );
    printf( "'' GENERATED by build/posixgen.sh from build/posix.spec: do not edit; regenerate.\n" );
    printf( "''\n" );
    printf( "'' Measured by build/posixgen.c, compiled and run on this host:\n" );
    printf( "''     host  %s\n''     cc    %s\n''     libc  %s\n", host, cc, libc );
    printf( "''\n" );
    printf( "'' tiko-rt includes this through inc/sysbind.ti, the std modules through sys/posix/posix.ti;\n" );
    printf( "'' each then says 'using posix'. Every struct size and listed offset is asserted below, so\n" );
    printf( "'' a layout tiko disagrees with fails to compile.\n\n" );
    printf( "#pragma once\n\nnamespace posix\n" );

#include "posix.spec"

    printf( "\nend namespace\n" );

    return 0;
}
