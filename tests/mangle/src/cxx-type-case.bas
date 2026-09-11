'' A UDT DECLARED INSIDE AN 'extern "C++"' BLOCK KEEPS ITS OWN SPELLING.
''
'' FreeBASIC folds a name and the mangler uppercases it, which is right for an FB type
'' and wrong for a C++ one. Measured against fbc's object symbols:
''
''     _ZN12DIGITALCLOCKC1EP9FBQWidget
''
'' -- the OWNER uppercased, because DigitalClock is an FB type declared outside the
'' block, and the PARAMETER's type in its own case because FBQWidget is not. tiko wrote
'' P9FBQWIDGET, so the call site and the C++ definition differed in case alone and the
'' link failed on a name that was almost right.
''
'' BOTH HALVES NEEDED IT. The parameter's type goes through TypeCode; the OWNER of a
'' member goes through QualifierChain, which uppercases for the same reason and had to
'' learn the same exception -- 'FBQLCDNUMBER::FBQLCDNUMBER' against fbc's
'' '_ZN12FBQLCDNumberC1E...'.
extern "C++"

type FBQObject
	declare constructor( byval as FBQObject ptr = 0 )
	as any ptr d_ptr
end type

type FBQWidget extends FBQObject
	as long RenderFlags
end type

type FBQLCDNumber extends FBQObject
	declare constructor( byval as FBQWidget ptr = 0 )
end type

end extern

'' An FB type outside the block: its OWN name is uppercased, its parameter's is not.
type DigitalClock extends FBQLCDNumber
	declare constructor( byval as FBQWidget ptr = 0 )
end type

constructor DigitalClock( byval parent as FBQWidget ptr )
end constructor

'' ...and a member of the C++ type DEFINED here, so the OWNER's spelling is asserted
'' too rather than only a parameter's.
constructor FBQLCDNumber( byval parent as FBQWidget ptr )
end constructor

constructor FBQObject( byval parent as FBQObject ptr )
end constructor
