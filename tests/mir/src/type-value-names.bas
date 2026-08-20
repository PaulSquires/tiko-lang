'' A TYPE NAME and a VALUE name may share a spelling. Measured against fbc:
''
''   type T ... end type   +  dim as integer T          accepted, T still a type
''   dim as ubyte ptr pb   +  type pb as ubyte          accepted, sizeof = 1
''   type UDT1 ... end type +  sub UDT1( )              accepted
''   type line ... end type +  const line = 1234        accepted
''   type T twice                                       fbc error 4
''   dim v twice                                        fbc error 4
''   enum E ... end enum   +  dim as integer E          fbc error 120 -- NOT split
''
'' The enum is the exception and it is why the split is UDT and TYPEDEF only: once
'' 'enum E' exists a bare E is an enum reference and fbc asks for a period.
''
'' The sizes below are the assertion. When the VARIABLE is declared first it holds the
'' slot, so a plain lookup typed 'dim as pb v' as a POINTER where fbc gives one byte --
'' a wrong type, silently, not a diagnostic.

'' THREE fields, deliberately: with a one-field UDT the variable and the type are
'' both eight bytes, and a lookup returning the wrong one of the two looks correct.
type T
	i as integer
	j as integer
	k as integer
end type

'' 'dim as integer T' and 'dim as T t' would collide as two VARIABLES of the
'' same folded name -- fbc rejects that too, error 4 -- so the value here is
'' spelled differently while still sharing the TYPE's name.
dim as integer T
dim as T tv1
dim as T tv2

dim as ubyte ptr pb
type pb as ubyte
dim as pb v

type UDT1
	j as integer
end type

sub UDT1( )
end sub

namespace n
	type line
		x as integer
	end type
	const line = 1234
end namespace

print 1
