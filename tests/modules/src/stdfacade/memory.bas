'' std/memory, a new module (2026-10-10) from fb/sharedptr.bi: SharedPtr, WeakPtr and
'' MakeShared, the generic '*' and '->' operators, qualified and through 'using'.
#import "std/memory"
type Box
    as long v
end type
dim as memory.SharedPtr( of Box ) a = memory.MakeShared( of Box )( )
a->v = 7
dim as memory.SharedPtr( of Box ) b = a
dim as memory.WeakPtr( of Box ) w = a
print (*b).v; a.UseCount( ); " "; w.Expired( )
a.Reset( ) : b.Reset( )
print w.Expired( )
scope
    using memory
    dim as SharedPtr( of long ) n = MakeSharedFrom( of long )( 5 )
    print *n
end scope
