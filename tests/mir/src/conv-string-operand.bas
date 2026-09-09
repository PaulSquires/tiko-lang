'' TWO ICEs IN THE CONVERSION FAMILY, AND THE SWEEP COULD NOT SEE EITHER.
''
'' Both reached the LLVM emitter as an aggregate with no storage --
''
''     emit: ICE: an aggregate value with no size
''
'' -- which only a real BUILD reaches. '--dump-ir' stops before codegen, so both files
'' reported "0 statements not lowered" and mirsweep, which dumps IR and stops, called
'' them clean. The decline census is structurally blind to this whole class.
''
'' 1. A 'zstring * N' OPERAND. Two lines, no UDT, nothing exotic:
''
''        dim as zstring * 50 t = "42"
''        print clng( t )        fbc prints 42; tiko ICEd
''
''    IsStringType says NO to a fixed narrow string -- it is an ARRAY of TY_ZSTRING --
''    and this file asked that one predicate. StrSwapKind_ is what the rest of the
''    compiler uses for exactly this reason.
''
'' 2. A UDT THAT CASTS TO A STRING. 'clng( u )' over a type declaring
''    'operator cast( ) byref as const zstring' fell past the VAL dispatch entirely.
''    Measured, fbc converts through the cast and then uses the ordinary entry point:
''
''        char*     vr  = _ZN14UZSTRING_FIXEDcvcEv( &U );
''        FBSTRING* vr2 = fb_StrAllocTempDescZ( vr );
''        int32     vr3 = fb_VALINT( vr2 );
''
''    THE TEMPORARY DESCRIPTOR IS NOT OPTIONAL. A byref zstring result is a bare char*
''    and fb_VALINT takes an FBSTRING*; handing the pointer straight over made
''    'clng( u )' answer 0 for a UDT holding "42" -- the runtime read a descriptor out
''    of string data. That was a wrong ANSWER rather than a crash, so it would have
''    outlived the ICE fix in silence.
''
'' udt-zstring/conversion.bas emits 390 fb_VAL* calls now and emitted none before.
type UZB extends zstring
	_data as zstring * 64
end type

type UZ extends UZB
	declare constructor( byref rhs as const zstring )
	declare operator cast( ) byref as const zstring
end type

constructor UZ( byref rhs as const zstring )
	this._data = rhs
end constructor

operator UZ.cast( ) byref as const zstring
	return this._data
end operator

dim as zstring * 50 t = "42"
dim as UZ u = UZ( "42" )

print clng( t ), clng( u )
print cbyte( t ), cbyte( u )
print cdbl( t ), cdbl( u )
print cbool( t ), cbool( u )
