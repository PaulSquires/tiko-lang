'' 'offsetof( T, a.b )' -- A DOTTED PATH, which parses as an N_MEMBER over N_IDENTs.
''
'' LowerOffsetOf tested the field node for N_IDENT and DECLINED SILENTLY on anything
'' else: a compile-time constant that lowered to no value at all, with the statement
'' around it dropped and not one diagnostic. tiko-editor's theme key table is built
'' entirely out of 'offsetof( THEMEROOT_TYPE, editor.selection.forecolor )', so all 71
'' rows kept the -1 their macro had just defaulted them to -- every colour in a theme
'' file reached nothing and the editor painted its built-in defaults instead.
''
'' The spine is left-nested, N_MEMBER( N_MEMBER( a, b ), c ), so the walk collects the
'' names outermost-first and applies them in reverse, each step's offset added and its
'' type becoming the next step's container.
''
'' fbc folds all of these; measured against it.
type INNER
    as long fore
    as long back
end type
type BASE_
    as long tag
end type
type MID_ extends BASE_
    as INNER text
    as long  alpha
end type
union UPART
    as long   asLong
    as single asSingle
end union
type ROOTX
    as long  head
    as MID_  editor
    as UPART part
end type

'' A ONE-LEVEL path still has to work -- it always did, so a test carrying only that
'' one would pass on the broken compiler.
print "head            = "; offsetof( ROOTX, head )
print "editor          = "; offsetof( ROOTX, editor )
'' TWO levels, and the field reached through the base a MID_ 'extends'.
print "editor.tag      = "; offsetof( ROOTX, editor.tag )
print "editor.text     = "; offsetof( ROOTX, editor.text )
print "editor.alpha    = "; offsetof( ROOTX, editor.alpha )
'' THREE, which is what the editor's table writes.
print "editor.text.back= "; offsetof( ROOTX, editor.text.back )
'' ...and into a UNION, whose members all sit at the same offset.
print "part.asSingle   = "; offsetof( ROOTX, part.asSingle )
