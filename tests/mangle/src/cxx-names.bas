#lang "fb"

'' The C++ spellings of tests/mangle/cxx-names-*.test, each against the name clang++ gives the
'' C++ declaration in its comment (docs/tiko-cpp FEASIBILITY 2.3; build/cpplane.sh links them).

type cxxlong as long alias "long"

extern "C++"
namespace nm
    sub c1( byval c as byte alias "char" )                      '' void c1( char )
    end sub
    sub c2( byval c as ubyte alias "char", byval d as ubyte )   '' void c2( char, unsigned char )
    end sub
    sub c3( byval a as const byte alias "char" ptr, byval b as const byte alias "char" ptr )
    end sub                                                     '' void c3( const char*, const char* )
    sub i1( byval a as integer, byval b as uinteger )           '' ptrdiff_t, size_t
    end sub
    sub i2( byval a as longint, byval b as ulongint )           '' long long, unsigned long long
    end sub
    sub l1( byval a as cxxlong )                                '' long (32-bit: Windows only)
    end sub
    sub v1( byval n as long, ... )                              '' void v1( int, ... )
    end sub
    type Outer
        as long a
        type Inner
            as long b
        end type
    end type
    sub n1( byval x as Outer.Inner )                            '' void n1( Outer::Inner )
    end sub
end namespace
end extern

type V
    as long x
end type
extern "c"
    declare operator +( byref l as const V, byref r as const V ) as V   '' extern "C" operator+
end extern
operator +( byref l as const V, byref r as const V ) as V
    return type( l.x + r.x )
end operator
