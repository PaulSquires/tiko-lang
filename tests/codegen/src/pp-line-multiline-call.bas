#define SHOW(a, b) print a; " "; b; " "; __LINE__
#define ID(x) x
SHOW( 1, _
      2 )
SHOW( _
  3, _
  4 )
print ID( _
  __LINE__ )
print __LINE__
#define OUTER(x) SHOW( x, _
   9 )
OUTER( 1 )
OUTER( _
  2 )
#macro M3( a )
    print a, __LINE__
#endmacro
M3( _
  5 )
