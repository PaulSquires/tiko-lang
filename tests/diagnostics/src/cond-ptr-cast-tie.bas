'' Two pointer casts and nothing more precise tie in a condition: fbc's 98 (line 11).
type T
  z as zstring * 4 = "z"
  w as wstring * 4 = wstr( "w" )
  declare operator cast( ) as zstring ptr
  declare operator cast( ) as wstring ptr
end type
operator T.cast( ) as zstring ptr : return @this.z : end operator
operator T.cast( ) as wstring ptr : return @this.w : end operator
dim as T u
if u then print "t"
