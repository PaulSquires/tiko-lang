'' FOR EACH over an iterator whose Value( ) returns a STRING -- see foreach-str-value.test.
type SIter
	as string cur
	as long k
	declare function IsValid( ) as boolean
	declare function Value( ) as string
	declare sub MoveNext( )
end type
function SIter.IsValid( ) as boolean : return k < 3 : end function
function SIter.Value( ) as string : return cur : end function
sub SIter.MoveNext( ) : k += 1 : cur = "item" & k : end sub
type SColl
	as long dummy
	declare function GetIterator( ) as SIter
end type
function SColl.GetIterator( ) as SIter
	dim as SIter it
	it.cur = "item0"
	return it
end function

type RIter
	as string ptr p
	as long k
	declare function IsValid( ) as boolean
	declare function Value( ) byref as string
	declare sub MoveNext( )
end type
function RIter.IsValid( ) as boolean : return k < 2 : end function
function RIter.Value( ) byref as string : return p[k] : end function
sub RIter.MoveNext( ) : k += 1 : end sub
type RColl
	as string items(0 to 1)
	declare function GetIterator( ) as RIter
end type
function RColl.GetIterator( ) as RIter
	dim as RIter it
	it.p = @items(0)
	return it
end function

type UIter
	as ustring cur
	as long k
	declare function IsValid( ) as boolean
	declare function Value( ) as ustring
	declare sub MoveNext( )
end type
function UIter.IsValid( ) as boolean : return k < 2 : end function
function UIter.Value( ) as ustring : return cur : end function
sub UIter.MoveNext( ) : k += 1 : cur = "u" & k : end sub
type UColl
	as long dummy
	declare function GetIterator( ) as UIter
end type
function UColl.GetIterator( ) as UIter
	dim as UIter it
	it.cur = "u0"
	return it
end function

sub Main( )
	dim c as SColl
	for each s in c
		print "[" & s & "]";
		s &= "!"
	next
	print
	for each s as string in c
		if s = "item1" then exit for
		print "<" & s & ">";
	next
	print
	dim r as RColl
	r.items(0) = "ra" : r.items(1) = "rb"
	for each s in r
		s &= "?"
		print "{" & s & "}";
	next
	print r.items(0); r.items(1)
	dim u as UColl
	for each x in u
		print "(" & x & ")";
	next
	print
end sub
Main( )
print "end"
