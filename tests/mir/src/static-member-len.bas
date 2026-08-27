'' 'len( T.field )' AND 'sizeof( T.field )' OVER A TYPE NAME are compile-time constants.
''
'' There is no object, so there is nothing to measure at run time -- and tiko-lang
'' INVENTED ONE. It allocated a local of the type, took a field address inside it and
'' called fb_StrLen on that: a length read out of a frame slot nothing had written. It
'' lowered, it verified, and it counted as a statement successfully compiled.
''
'' Measured against fbc, and every one of them is the member's own size:
''
''     len( T.zs )     5     the CONSTANT'S TEXT length
''     sizeof( T.zs )  6     ...and its byte size, the NUL included
''     len( T.z )     10     'zstring * 10' -- its DECLARED SIZE, not a strlen
''     len( T.w )     20     'wstring * 10' -- twenty BYTES, not ten characters
''     len( T.s )     24     the descriptor
''     len( T.sl )     4
''
'' LEN and SIZEOF differ only over a string CONSTANT, where len is the text and sizeof
'' the bytes it occupies.
''
'' A DOTTED PATH TO A CONSTANT IS STILL A CONSTANT, and that was the other half: only a
'' BARE name was folded, so a constant declared inside a type or a namespace had no text
'' at all and every use of one declined. It is the same fold either way -- Resolve has
'' already bound the member to its symbol.
namespace ns1
    const s = "hello"
end namespace

type T
    const zs = "hello"
    z as zstring * 10
    w as wstring * 10
    s as string
    sl as long
    type TIn
        z as zstring * 4
    end type
end type

sub s1( )
    dim as integer r
    r = len( ns1.s )    : print r
    r = sizeof( ns1.s ) : print r
    r = len( T.zs )     : print r
    r = sizeof( T.zs )  : print r
    r = len( T.z )      : print r
    r = len( T.w )      : print r
    r = len( T.s )      : print r
    r = len( T.sl )     : print r
    r = len( T.TIn.z )  : print r
end sub

s1( )
