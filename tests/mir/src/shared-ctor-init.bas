'' 'dim shared f as foo = foo( 7 )' -- A MODULE GLOBAL CONSTRUCTED BY A NAMED
'' CONSTRUCTOR. fbc emits the chosen call in its module initialiser and nothing else:
''
''     __attribute__(( constructor )) static void fb_ctor__sh1( void ) {
''         _ZN3FOOC1Eu7INTEGER( &F$, 7ll );
''     }
''
'' tiko declined it. A constructor call cannot be folded to bytes and never will be, so
'' the aggregate initialiser path gave up -- and the global was left DEFAULT-constructed
'' with the argument thrown away. The program printed 0 where fbc prints 7.
''
'' TWO THINGS HAD TO CHANGE, and the first is the one that hid the second. The global was
'' never even entered into the module-initialiser list: that list is built from whether
'' the TYPE wants default construction or destruction, and a type with a single
'' one-argument constructor and an integer field wants neither. So 'wants' was false, the
'' declaration fell through to the folder, and declined. A named constructor is now
'' itself a reason to be in the list.
''
'' The emitter then calls the CHOSEN constructor rather than the zero-arity one --
'' CtorCallOnAddr_, the same helper a FIELD initialiser uses, because 'as A a = A( 1 )'
'' and 'dim shared a as A = A( 1 )' are the same construction on a different address.
type foo
	as integer pad
	declare constructor ( i as integer )
end type

constructor foo( i as integer )
	this.pad = i
end constructor

dim shared f as foo = foo( 7 )
print f.pad
