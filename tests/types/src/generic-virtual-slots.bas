'' A GENERIC'S OWN VIRTUALS REACH ITS INSTANTIATION'S VTABLE.
''
'' FreeBASIC spells 'virtual' and 'abstract' once, on the declaration INSIDE the type,
'' and the out-of-line definition repeats neither. An instantiation re-parses only the
'' definitions, so every instantiated member came out with neither flag: the table had
'' no slots of its own and a call through a base handle was emitted DIRECT.
''
'' The TEMPLATE itself gets no table -- its slots would mangle to procedures nobody
'' defines, which is what clang refused.
type Root( of T ) extends object
	as T v
	declare virtual function nm( ) as string
	declare abstract function tag( ) as string
end type

function Root( of T ).nm( ) as string
	return "Root"
end function

type Der( of T ) extends Root( of T )
	declare function nm( ) as string
	declare function tag( ) as string
end type

function Der( of T ).nm( ) as string
	return "Der"
end function

function Der( of T ).tag( ) as string
	return "tag"
end function

dim as Der( of integer ) d
dim as Root( of integer ) ptr r = @d
print r->nm( ); r->tag( )
