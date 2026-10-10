'' A CONCATENATION WITH A USTRING TERM CHOOSES THE USTRING OVERLOAD. Measured, fbc's
'' 'typeof( u & "x" )', '( s & u )' and '( u & n )' are all USTRING, and
'' 'strings.StartsWith( u & "x", "  " )' calls fb_UStrStartsWith. tiko's checker keeps '&' narrow
'' -- lowering decides the width per term -- so overload resolution chose fb_StrStartsWith
'' and lowering handed it two FBUSTRINGs: 'false' where fbc prints 'true'.
''
'' fbc prints: true / true / true / ustring / string / ustring / ustring
#import "std/strings"
#import "std/containers"
sub Pick overload ( byref s as string )
	print "string"
end sub
sub Pick overload ( byref s as ustring )
	print "ustring"
end sub
dim as ustring u = "  Ab  "
dim as string s = "q"
dim as long n = 7
print strings.StartsWith( u & "x", "  " )
print strings.Contains( "a" & u, "A" )
print strings.EndsWith( s & u & "z", "  z" )
Pick( u & "x" )
Pick( s & "x" )
Pick( s & u )
Pick( u & n )
