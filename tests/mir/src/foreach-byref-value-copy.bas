'' FOR EACH OVER A BYREF 'Value( )' COPIES THE ELEMENT INTO A NON-BYREF LOOP VARIABLE, with
'' its copy constructor, and destroys that copy every iteration. fbc prints, for two
'' elements:
''
''     T ctor / T ctor / T dtor item1 / T copy item1 / got item1 / T dtor item1 /
''     T copy item2 / got item2 / T dtor item2 / T dtor item3 / after loop
''
'' tiko loaded the element's bytes and stored them: no copy, no per-iteration destructor,
'' and a loop variable sharing its buffers with the iterator's own. fbsqlite's
'' 'for each person in outer_' over a Statement (Row holds a Map and arrays) corrupted the
'' heap that way -- 0xC0000374 in test_database and test_realworld.
type Tracker
	as long id
	as ustring tag
	declare constructor( )
	declare constructor( byref o as Tracker )
	declare destructor( )
end type
constructor Tracker( )
	print "T ctor"
end constructor
constructor Tracker( byref o as Tracker )
	id = o.id : tag = o.tag
	print "T copy "; tag
end constructor
destructor Tracker( )
	print "T dtor "; tag
end destructor
type Coll_ as Coll
type It
	as Coll_ ptr owner
	as long pos_
	as Tracker cur
	declare function IsValid( ) as boolean
	declare function Value( ) byref as Tracker
	declare sub MoveNext( )
end type
type Coll
	as long n
	declare function GetIterator( ) as It
end type
function It.IsValid( ) as boolean
	return pos_ <= owner->n
end function
function It.Value( ) byref as Tracker
	return cur
end function
sub It.MoveNext( )
	pos_ += 1
	cur.tag = "item" & pos_
end sub
function Coll.GetIterator( ) as It
	dim r as It
	r.owner = @this : r.pos_ = 1 : r.cur.tag = "item1"
	return r
end function
dim as Coll c3
c3.n = 2
for each s in c3
	print "got "; s.tag
next
print "after loop"
