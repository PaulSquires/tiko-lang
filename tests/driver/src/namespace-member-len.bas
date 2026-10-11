'' namespace-member-len's program: 'len' of a name reached THROUGH A NAMESPACE.
''
'' A dotted path through a TYPE has no object and folds to the member's size; a path through
'' a NAMESPACE only does until it reaches an object. tiko folded every one of these to the
'' size -- 24, 20, 40 -- where fbc measures the text; through 'using' it was already right.
namespace stamp
    dim shared as string sg
    dim shared as zstring * 20 zs
    dim shared as wstring * 20 ws
    const k = "konst"
    type T
        as string s
        as long n
    end type
    dim shared as T rec
    namespace inner
        dim shared as string q
    end namespace
end namespace

stamp.sg = "hello" : stamp.zs = "abc" : stamp.ws = "wide" : stamp.rec.s = "seven77"
stamp.inner.q = "nested!!"
'' objects: the text
print len( stamp.sg ); len( stamp.zs ); len( stamp.ws ); len( stamp.rec.s ); len( stamp.inner.q )
'' static: a constant's text, a type's member sizes
print len( stamp.k ); len( stamp.T.s ); len( stamp.T.n )
'' sizeof is always the size
print sizeof( stamp.sg ); sizeof( stamp.zs ); sizeof( stamp.ws ); sizeof( stamp.rec.s ); sizeof( stamp.T.n )
using stamp
print len( sg ); len( rec.s )
