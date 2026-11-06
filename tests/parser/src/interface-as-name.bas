'' 'interface' and 'inherits' are not reserved (fbc takes both as identifiers, and
'' winddk.bi/rpcdce.bi use 'interface' as a type, field and parameter name): every one of
'' these keeps its meaning. Only 'interface Name' ... 'end interface' is a declaration.
type INTERFACE as long
type Holder
    as INTERFACE interface
    inherits as long
end type
sub Take( byval interface as long )
    print interface
end sub
dim as long inherits = 2
dim as Holder h
h.interface = 3
Take( h.interface + inherits )
