' A float constant CAST to an integer type folds half to even -- in a shared UDT table
' (D3DCOLOR_COLORVALUE's shape), a const, and a shared scalar.
#define ARGB(a, r, g, b) cast(ulong, ((((a) and &hff) shl 24) or (((r) and &hff) shl 16)) or (((g) and &hff) shl 8) or ((b) and &hff))
#define COLORVALUE(r, g, b, a) ARGB(cast(ulong, (a) * 255.f), cast(ulong, (r) * 255.f), cast(ulong, (g) * 255.f), cast(ulong, (b) * 255.f))
type Vertex
    as single x, y
    as ulong c
end type
dim shared as Vertex pts(0 to 1) => { (0.5f, 1.5f, COLORVALUE(1.0, 0.5, 0.0, 1.0)), (2.0f, 3.0f, COLORVALUE(0.0, 0.0, 1.0, 0.5)) }
const K = cast(long, 2.5) + cast(long, 3.5)
dim shared as integer s = cast(integer, -2.5)
print hex(pts(0).c); " "; hex(pts(1).c); K; s; pts(1).x
