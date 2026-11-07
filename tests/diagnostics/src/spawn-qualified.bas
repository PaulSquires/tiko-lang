'' 'spawn' OF A QUALIFIED CALLEE -- a method, a static method, a procedure in a namespace --
'' is fbc's error 357, naming the first segment that is not a namespace. Each was TKO0994.
#import "std/tasks"
type Wk
    as long v
    declare sub Run( byval k as long )
    declare static sub SRun( byval k as long )
end type
sub Wk.Run( byval k as long ) : end sub
sub Wk.SRun( byval k as long ) : end sub
namespace NS
    sub Proc( byval k as long ) : end sub
    namespace Inner
        sub Deep( ) : end sub
    end namespace
end namespace
sub Plain( byval k as long ) : end sub
dim shared w1 as Wk
dim shared pw as Wk ptr
spawn NS.Proc( 3 )                                  '' 357: 'proc'
spawn NS.Inner.Deep( )                              '' 357: 'deep'
spawn w1.Run( 5 )                                   '' 357: 'w1'
spawn pw->Run( 5 )                                  '' 357: 'pw'
spawn Wk.SRun( 5 )                                  '' 357: 'wk'
spawn Plain( 1 )                                    '' fine
