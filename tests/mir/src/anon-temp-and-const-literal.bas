'' 'UDT( ).copyToGlobal( )' CONSTRUCTS AN ANONYMOUS TEMPORARY and calls a member on it.
'' The statement is a CALL and the type name is the receiver's constructor, not the
'' callee -- but the member does not bind, because its base is a temporary, so the
'' head's symbol reached the ambiguity report and "'udt' is a type, not a procedure"
'' fired on a legal statement. fbc emits '_ZN3UDTC1Ev( &TMP$2$0 );
'' _ZN3UDT12COPYTOGLOBALEv( &TMP$2$0 );' and prints 123.
type UDT
	as integer i
	declare constructor( )
	declare sub copyToGlobal( )
end type

dim shared as integer g

constructor UDT( )
	this.i = 123
end constructor

sub UDT.copyToGlobal( )
	g = this.i
end sub

UDT( ).copyToGlobal( )
print g

'' 'x = type<const UDT>( )' IS A CONSTRUCTOR CALL, and the CONST is what broke it: the
'' bare-type-literal assignment required the literal to be UNTYPED, and the qualifier
'' gives Check something to record. So this declined while 'x = type<UDT>( )' and
'' 'dim y as UDT = type<const UDT>( )' both lowered. fbc builds the same temporary for
'' all three.
dim as UDT x
x = type<const UDT>( )
print x.i
dim as UDT y = type<const UDT>( )
print y.i
x = type<UDT>( )
print x.i
