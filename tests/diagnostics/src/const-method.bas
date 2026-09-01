'' INSIDE A CONST METHOD 'this' IS CONST. MEASURED with fbc: writing a field is error 119
'' in all three spellings, writing 'this' itself is error 119, and calling a NON-const
'' method is error 276. Reading a field and calling a CONST method are the ordinary uses
'' and are accepted -- which is what makes the rule worth stating.
''
'' THE 'const' IS ON THE DECLARATION. The definitions below do not repeat the word, and
'' that is the only place fbc looks for it either.
type T
    value as integer
    declare const sub ro( )
    declare const sub alsoRo( )
    declare sub rw( )
end type

sub T.rw( )
end sub

sub T.alsoRo( )
end sub

sub T.ro( )
    print value
    alsoRo( )

    value = 4
    this.value = 5
    with this
        .value = 6
    end with
    dim other as T
    this = other
    rw( )
end sub
