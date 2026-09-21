'' CIRCLE'S OMITTED END ANGLE IS fbc's SENTINEL, NOT 2*PI. fbc passes
'' 'astNewCONSTf( 3.141593*2, FB_DATATYPE_SINGLE )' -- the single
'' 6.2831859588623047, written 0x1.921FB8p+2 in its C -- and gfx_circle.c draws a
'' whole circle only for exactly that value with a start of 0. tiko passed the
'' true single 2*pi, 6.2831854820251465, so the library took the ARC path and
'' reduced 0..2*pi to its first point: 'circle (x, y), r' drew one pixel.
screenres 64, 48, 32
circle (20, 20), 8, 15
