'' A CONSTANT FOLDS AT ITS OWN DECLARED WIDTH AND SIGNEDNESS, not at its
'' initialiser's. Measured against fbc, whose C for the five reads below is
'' -1, 255, -1, 65535 and 4294967295.
const a as byte     = 0
const b as byte     = not a
const u as ubyte    = 0
const v as ubyte    = not u
const s as short    = 0
const t as short    = not s
const w as ushort   = 0
const y as ushort   = not w
const l as ulong    = 0
const m as ulong    = not l
dim as longint x1 = b, x2 = v, x3 = t, x4 = y, x5 = m

'' ...and the string fold reads a NAMED constant argument, which needs the
'' constant's own scope: 'str( b )' folded to nothing while 'str( 5 )' worked.
const cs as string = str( v )
dim as string q
q = cs
