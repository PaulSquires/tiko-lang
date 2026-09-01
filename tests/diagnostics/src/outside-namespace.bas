'' A NAMESPACE CANNOT BE ADDED TO FROM OUTSIDE IT -- fbc error 158. DEFINING something the
'' namespace already declared is the ordinary and accepted use, which is what the first
'' half is for; introducing a NEW name is not.
namespace known
    declare sub declared( )
    extern ev as integer
end namespace

sub known.declared( )
end sub

dim known.ev as integer

namespace empty_
    dim placeholder as integer
end namespace

sub empty_.notThere( )
end sub

dim empty_.alsoNotThere as integer
