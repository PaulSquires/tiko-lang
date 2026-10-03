namespace NS
	enum Lvl
		ONE = 1
	end enum
	const K = 5
	sub Helper( )
	end sub
	dim shared as long V = 7
	namespace Inner
		const DEEP = 9
	end namespace
end namespace
namespace Other
	const FREE = 3
end namespace
sub UsesLocally( )
	using Other
end sub
using NS
using NS.Inner
#define ONE( m ) m
#define K( m ) m
#define Helper( m ) m
#define V( m ) m
#define DEEP( m ) m
#define FREE( m ) m
#define Unrelated( m ) m
print "done"
