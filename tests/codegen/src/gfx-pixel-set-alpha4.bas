'' fb_hPixelSetAlpha4 is a public gfxlib2 symbol (gfx/blender-alpha4.bas declares it): fill
'' 32-bit pixels with a colour blended by its own alpha, C's unsigned wraparound included.
#include once "fbgfx.bi"

extern "c"
    declare function fb_hPixelSetAlpha4 cdecl alias "fb_hPixelSetAlpha4" _
        ( byval dest as any ptr, byval clr as long, byval size as ulong ) as any ptr
end extern

dim as ubyte vals(0 to 3) = { 0, 1, 128, 255 }
dim as ulong buf(0 to 7)
dim as ulong hv = 2166136261
dim as integer n = 0
for a as integer = 0 to 3
for sr as integer = 0 to 3
for sg as integer = 0 to 3
for sb as integer = 0 to 3
for dr as integer = 0 to 3
for dg as integer = 0 to 3
for db as integer = 0 to 3
    dim as ulong sc = rgba( vals(sr), vals(sg), vals(sb), vals(a) )
    dim as ulong dc = rgba( vals(dr), vals(dg), vals(db), 0 )
    for i as integer = 0 to 7 : buf(i) = dc : next
    dim as any ptr r = fb_hPixelSetAlpha4( @buf(0), sc, 5 )
    if r <> @buf(0) then print "bad return"
    for i as integer = 0 to 7
        hv = (hv xor buf(i)) * 16777619
    next
    n += 1
next : next : next : next : next : next : next
print n; " "; hex( hv )
print hex( buf(0) ), hex( buf(4) ), hex( buf(5) )
