'' A USING THAT LEADS THROUGH A SECOND USING. Measured: fbc accepts this and prints
'' -123 -- 'using bar' brings in what BAR itself imported -- while the type lookup here
'' probed the used namespace ONCE and stopped, so t1 was invisible, the type literal was
'' untyped, and the argument declined.
namespace foo
	type t1
		as long v
	end type
end namespace

namespace bar
	using foo
	sub foobar( byval a as t1 )
		print a.v
	end sub
end namespace

using bar
foobar( type<t1>( -123 ) )
