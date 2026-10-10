' TEST_MODE : COMPILE_ONLY_FAIL

'' 'sp->' requires T to be a UDT.
''
'' The result of an 'operator ->' must be a structure, because fbc chains member
'' access through it -- so instantiating the global 'operator ->( of T )' with a
'' scalar T is an error at the point of use.  SharedPtr( of integer ) itself is
'' perfectly usable; only the arrow is not, and '*sp' and sp.Ref( ) are the way
'' to reach a scalar.
''
'' Pinned because the failure is at instantiation, not at declaration: nothing
'' in sharedptr.bi is wrong until somebody writes this line.
#import "std/memory"
#include once "fberror.bi"
#include once "fbatomic.bi"
using memory
using FB
dim as SharedPtr( of integer ) sp = MakeShared( of integer )( )

'' '*sp' and sp.Ref( ) would both be fine here.  This is not.
print sp->v
