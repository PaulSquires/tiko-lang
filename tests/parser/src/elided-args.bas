'' An ARGUMENT may be left out, and the empty slot still COUNTS: 'f( 1, , 3 )' passes
'' three arguments, the middle one taking the parameter's default. Measured -- fbc
'' accepts every form below.
''
'' It is a NODE rather than a gap in the list, because the arity has to survive. A list
'' that quietly held two entries would make the call bind to the wrong overload.
''
'' Three separate argument lists needed it, which is why this took three attempts:
''
''   a parenthesised call        PostfixChain
''   an intrinsic's arguments    IntrArgList
''   a PAREN-LESS call           ParseAmbiguous  <- 'locate ,,0' goes here, because
''                                                  LOCATE is not in fbx's intrinsic
''                                                  registry at all
''
'' IntrArgList also has a no-progress guard to stop a loop that cannot consume anything,
'' and an elided argument consumes nothing BY DEFINITION -- so it is exempt, or the list
'' bails out on its first element.
''
'' NOT DONE: the call still DECLINES in lowering, because the elided argument has no type
'' and one untyped argument makes the whole call undecidable. Substituting the default is
'' its own change. Declining is the honest outcome -- a call lowered with the wrong
'' arity would not be.

declare sub f( byval a as long = 1, byval b as long = 2, byval c as long = 3 )

sub f( byval a as long = 1, byval b as long = 2, byval c as long = 3 )
end sub

f( 1, , 3 )
f( 1, )
f( , , 3 )

locate ,,0
