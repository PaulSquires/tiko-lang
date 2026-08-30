'' IMAGEINFO IS OVERLOADED ON ITS OUTPUT WIDTH, and the prelude's note used to say it
'' was not -- that an 'integer' output was fbc's error 58. Re-measured: both spellings
'' compile clean, and
''
''     long outputs     fb_GfxImageInfo32( void*, int32*, ... )
''     integer outputs  fb_GfxImageInfo64( void*, int64*, ... )
''
'' With only the 32-bit half declared the integer form DECLINED -- which is at least
'' honest, and is what SCREENINFO and GETMOUSE beside it already avoided by declaring
'' both halves.
screen 13
dim as any ptr img
dim as any ptr pix

sub Narrow( byval img as any ptr, byval pix as any ptr )
    dim as long w, h, bpp, pitch
    dim as any ptr p
    dim as long r = imageinfo( img, w, h, bpp, pitch, p )
    print r
end sub

sub Wide( byval img as any ptr, byval pix as any ptr )
    dim as integer w, h, bpp, pitch
    dim as any ptr p
    dim as long r = imageinfo( img, w, h, bpp, pitch, p )
    print r
end sub

Narrow( img, pix )
Wide( img, pix )
