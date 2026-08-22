'' The graphics statements with their own coordinate grammar. '(x,y)-(x,y)' is not an
'' expression -- it was parsed as a BINARY MINUS of two tuples and 'step(1,2)' as a CALL
'' to a procedure named 'step', which is faithful to nothing.
''
'' Every default below was MEASURED from fbc's own C output. See
'' docs/language/graphics-abi.md; the ones worth having in front of you:
''
''   AN OMITTED COLOUR IS NOT AN ARGUMENT. It is 0 in the colour slot plus BIT 31 of the
''   coordinate flags, so the runtime can tell "black" from "whatever is current".
''
''   THERE ARE TWO FLAG CONVENTIONS. LINE puts the SECOND point's STEP in bit 0; PSET,
''   CIRCLE and PAINT put their single STEP there and carry a base of 4 besides.
''
''   B and BF are a SEPARATE INTEGER -- 0, 1, 2 -- not a bitmask.
dim as any ptr buf
dim as long c
dim as string pat
screenres 320, 200, 8

line (10,10)-(20,20)
line (10,10)-(20,20), c
line (10,10)-(20,20), c, B
line (10,10)-(20,20), c, BF
line (10,10)-step(5,5), c
line step(1,1)-(2,2), c
'' 'line -(x,y)' means "from where we are", which fbc spells as the FIRST POINT being
'' relative by (0,0) rather than as a flag of its own.
line -(20,20)
line (10,10)-(20,20), c, , &hFF00
line buf, (10,10)-(20,20), c

pset (1,2)
pset step(1,2), c
'' PRESET is the SAME function with a trailing -1.
preset (1,2), c

'' CIRCLE's ASPECT COMES BEFORE START AND END in the call, the reverse of the syntax,
'' and an omitted end angle is 2*pi rather than 0.
circle (1,2), 3
circle (1,2), 3, c, 0.5, 1.5, 2.0, F

'' PAINT's third argument is EITHER a colour or a PATTERN STRING. A pattern forces the
'' colour argument to &hFFFF0000, and the descriptor is always passed -- with no pattern
'' fbc allocates an empty temporary for it.
paint (1,2)
paint (1,2), c, c
paint (1,2), pat, c

'' VIEW's coordinates are INTEGERS while WINDOW's are singles, which is the opposite of
'' what the shared syntax suggests.
view (0,0)-(1,1), c, c
view screen (0,0)-(1,1), c, c
window (0,0)-(1,1)
draw "U10"

'' GET and PUT share a keyword with the FILE statements, exactly as LINE does.
''
'' PUT'S DEFAULT MODE IS XOR, not TRANS -- the opposite of DRAW STRING's -- and ALPHA
'' WITH A VALUE is a DIFFERENT MODE from ALPHA without: 9 rather than 6, with a
'' different blender again. The four source-rectangle integers are -65536 each, a
'' sentinel for "the whole image".
dim as any ptr buf2
get (1,2)-(3,4), buf
get step(1,2)-(3,4), buf
get buf2, (1,2)-(3,4), buf
put (1,2), buf
put (1,2), buf, TRANS
put (1,2), buf, PSET
put (1,2), buf, ALPHA
put (1,2), buf, ALPHA, 128
put buf2, step(1,2), buf, XOR

'' PALETTE's three forms do not agree on their omitted arguments: the plain form pads
'' with -1 and PALETTE GET pads with a NULL POINTER, which is the opposite of what
'' SCREENINFO does.
dim as long r, g, b
dim as long arr( 0 to 3 )
palette
palette 1, 2, 3, 4
palette 1, 2
palette get 1, r, g, b
palette get 1, r
palette using arr
