#define FIELD( a, b ) a##b
#define KILL 5
dim shared as long counter
#define counter 1
namespace N
    sub helper( )
    end sub
end namespace
#define helper 2
declare sub gone( )
#undef gone
#define gone 3
#undef print
#define print 4
