'' 'override' IN A GENERIC IS CHECKED PER INSTANTIATION, as fbc checks it.
''
'' fb/tuiwidget.bi's TuiButtonOf( of F ) is the shape: a generic extending a plain
'' abstract base and overriding its methods, which most programs never instantiate. A
'' template gets no vtable of its own, so none of its declarations could be found to have
'' overridden anything, and every one was TKO0621.

type Widget extends object
	declare abstract sub Paint( )
	declare virtual function Size( ) as long
end type
private function Widget.Size( ) as long
	return 0
end function

'' Never instantiated. Two overrides that are right and one that overrides nothing:
'' fbc reports none of them.
type Unused( of T ) extends Widget
	as T v
	declare sub Paint( ) override
	declare function Size( ) as long override
	declare sub Ghost( ) override
end type
private sub Unused( of T ).Paint( )
end sub
private function Unused( of T ).Size( ) as long
	return sizeof( T )
end function
private sub Unused( of T ).Ghost( )
end sub

'' Instantiated, so its broken promise IS reported.
type Broken( of T ) extends Widget
	as T v
	declare sub Paint( ) override
	declare sub Nope( ) override
end type
private sub Broken( of T ).Paint( )
end sub
private sub Broken( of T ).Nope( )
end sub

dim as Broken( of long ) b
