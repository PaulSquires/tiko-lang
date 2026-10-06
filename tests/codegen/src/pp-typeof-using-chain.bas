namespace N1
	type T
		__ as long = 1
	end type
end namespace
namespace N2
	using N1
end namespace
#if typeof(N1.T) = typeof(N2.T)
print "q-same"
#else
print "q-differ"
#endif
using N2
#if typeof(T) = typeof(N1.T)
print "u-same"
#else
print "u-differ"
#endif
