'' A UDT MAY OVERLOAD '@', and then '@f' is a CALL. Typed as 'foo ptr' and lowered as
'' the object's own address, it read the field BEFORE the one the operator points at --
'' 111 instead of 999 -- with 0 statements not lowered to say so. fbc:
''
''     int64* _ZN3FOOadEv( struct $3FOO* THIS$1 )
''     int64* vr$2 = _ZN3FOOadEv( &F$0 );
''
'' and the mangled name is 'ad', one form only: FreeBASIC has no binary '@'. The vendor
'' extension spelled it '_ZN3FOOv11@Ev', a name nothing defines.
type foo
	as integer pad
	as integer data_
	declare operator @ ( ) as integer ptr
end type

operator foo.@ ( ) as integer ptr
	return @this.data_
end operator

dim as foo f
f.pad = 111 : f.data_ = 999
dim as integer ptr p = @f
print *p
print *@f

'' '&=' IS NOT IN THE COMPOUND-ASSIGN OPERATOR MAP -- it is a concatenation and never
'' an arithmetic operator -- so it reached 'case else' and declined before the member
'' call that has known '&=' since it was written ever ran. Nothing to do with strings:
'' the '+=' beside it lowered. fbc: '_ZN3BARv27selfcatERS_( &L$0, &R$0 );'.
type bar
	as string s
	declare operator &= ( byref r as bar )
	declare operator += ( byref r as bar )
end type

operator bar.&= ( byref r as bar )
	this.s = this.s & "|" & r.s
end operator

operator bar.+= ( byref r as bar )
	this.s = this.s & "+" & r.s
end operator

dim as bar l, r
l.s = "abc" : r.s = "def"
l &= r
print l.s
l += r
print l.s
