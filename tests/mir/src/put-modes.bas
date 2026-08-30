'' EVERY PUT MODE AND ITS BLENDER. Two of the ten were silently wrong.
''
'' ADD had no row in the blender table and fell to the default, so 'put ..., add' blended
'' with XOR. And the mode was encoded as 'm or &h8' -- a three-bit value with the fourth
'' bit as the present flag -- which cannot hold CUSTOM's 8: 'm or &h8' was 8 and the
'' reader's 'm and 7' turned it back into 0, so every 'put ..., custom, @cb' blended as
'' TRANS. Both lowered and verified; only the picture was wrong.
''
'' The mode is m+1 in four bits now, with 0 meaning none was written.
function customCallback _
    ( _
        byval source_pixel as ulong, _
        byval destination_pixel as ulong, _
        byval parameter as any ptr _
    ) as ulong
    function = 0
end function

screen 13
dim as any ptr image

put (0, 0), image
put (0, 0), image, trans
put (0, 0), image, pset
put (0, 0), image, preset
put (0, 0), image, and
put (0, 0), image, or
put (0, 0), image, xor
put (0, 0), image, alpha
put (0, 0), image, alpha, 128
put (0, 0), image, add
put (0, 0), image, custom, @customCallback, 0
