namespace N1
    const ONLY = 11
end namespace
namespace N2
    const ONLY = 22
end namespace
using N2
sub Both( )
    using N1
    print ONLY
end sub
