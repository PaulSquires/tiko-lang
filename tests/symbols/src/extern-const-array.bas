'' An extern const array has no initialiser, and needs none: the storage is another
'' module's. fbc-modern 1.20 compiles both spellings clean.
extern a( 0 to 3 ) as const ubyte
extern as const ubyte b( 0 to 1 )
