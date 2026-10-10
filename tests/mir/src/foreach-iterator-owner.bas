'' THE ITERATOR GETITERATOR( ) RETURNS HAS ONE OWNER. fbc builds it once, runs the loop on it and
'' destroys it after the loop: with a Row-like element holding a SharedPtr and an array, the
'' use count reads 4 / 6 6 6 / 4. tiko stored the sret temporary's bytes into a slot of its
'' own, ran MoveNext on the COPY -- whose 'cur = MakeRow( )' released buffers the temporary
'' still pointed at -- and destroyed the TEMPORARY after the loop: a double free, 0xC0000374,
'' and the copy was never destroyed at all. fbsqlite's 'for each person in outer_' over a
'' Statement (StatementIterator holds a Row) died exactly there, in test_database and
'' test_realworld.
''
'' fbc prints: copies cell7 cell7 use= 4 / row cell1 use= 6 / row cell2 use= 6 /
'' row cell3 use= 6 / seen  3 use= 4
#import "std/containers"
#import "std/memory"
type UStrArr as containers.Array( of ustring )
type Cell
	as long kind
	as ustring txt
end type
type CellArr as containers.Array( of Cell )
type NPtr as memory.SharedPtr( of UStrArr )
type RowX
	as NPtr m_names
	as CellArr m_cells
end type
type Coll_ as Coll
type RIt
	as Coll_ ptr owner
	as long pos_
	as RowX cur
	declare function IsValid( ) as boolean
	declare function Value( ) byref as RowX
	declare sub MoveNext( )
end type
type Coll
	as long n
	as NPtr names
	declare function GetIterator( ) as RIt
	declare function MakeRow( byval i as long ) as RowX
end type
function RIt.IsValid( ) as boolean
	return pos_ <= owner->n
end function
function RIt.Value( ) byref as RowX
	return cur
end function
sub RIt.MoveNext( )
	pos_ += 1
	if pos_ <= owner->n then cur = owner->MakeRow( pos_ )
end sub
function Coll.MakeRow( byval i as long ) as RowX
	dim r as RowX
	r.m_names = this.names
	dim as Cell c1
	c1.kind = i : c1.txt = "cell" & i
	r.m_cells.Push( c1 )
	return r
end function
function Coll.GetIterator( ) as RIt
	dim it as RIt
	it.owner = @this : it.pos_ = 1
	it.cur = this.MakeRow( 1 )
	return it
end function
dim as Coll co
co.n = 3
dim as UStrArr nm
nm.Push( "name" )
co.names = memory.MakeSharedFrom( of UStrArr )( nm )
dim r1 as RowX = co.MakeRow( 7 )
dim r2 as RowX = r1
dim r3 as RowX
r3 = r1
print "copies "; r2.m_cells[0].txt; " "; r3.m_cells[0].txt; " use="; co.names.UseCount( )
dim as long seen = 0
for each rw in co
	seen += 1
	print "row "; rw.m_cells[0].txt; " use="; co.names.UseCount( )
next
print "seen "; seen; " use="; co.names.UseCount( )
