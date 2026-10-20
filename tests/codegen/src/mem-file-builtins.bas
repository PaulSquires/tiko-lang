' fbc's memory and file built-ins, called by name with no declaration: each 'byref as any'.
type Person
    dim as zstring * 40 nm
    dim as integer age
end type
dim as zstring ptr src = @"Pierre de Fermat"
dim as Person p1, p2
fb_memcopy(p1.nm, *src, len(*src) + 1)
p1.age = 46
fb_memcopy(p2, p1, sizeof(Person))
print p2.nm; p2.age
dim as zstring * 32 z = "abcdefghijklmnopqrstuvwxyz"
fb_memmove(z[3], z[0], 5)
print z
dim as integer d(3), s(1) = {7, 8}
fb_MemCopyClear(d(0), 4 * sizeof(integer), s(0), 2 * sizeof(integer))
print d(0); d(1); d(2); d(3)
dim as integer ff = freefile, x = 1234, y = 0
open "tests/codegen/memfile.tmp" for binary as #ff
fb_fileput(ff, 0, x, sizeof(x))
fb_fileget(ff, 1, y, sizeof(y))
close #ff
kill "tests/codegen/memfile.tmp"
print y
