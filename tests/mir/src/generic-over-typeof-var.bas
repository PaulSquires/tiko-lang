'' A GENERIC INSTANTIATED OVER 'typeof( <a var> )'. Its type argument could not be
'' resolved -- a 'var' is typed in Check and generic instantiation runs in Resolve -- so
'' InstantiateGeneric_ built NOTHING, every use of the alias was a zero-sized local, and
'' the field stores through it declined. tui/tuiwidget_.bas is sixteen statements of it
'' and fbc compiles the file clean.
''
'' The one case Resolve can answer is the one the corpus writes: an initialiser this
'' pass has ALREADY TYPED. BuildClosureType_ types the N_CLOSURE node as it builds the
'' closure UDT, so the answer is sitting on the initialiser by the time the 'typeof' is
'' read.
type BoxOf( of F )
	as F h
	as long id
end type
dim shared as long total
var onA = sub[ byref total ]( byval v as long )
	total += v
end sub
type BA as BoxOf( of typeof( onA ) )
dim as BA b
b.id = 7
b.h = onA
print b.id
