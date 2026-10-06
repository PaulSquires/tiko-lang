dim zarray( 0 to 2, 0 to 2 ) as zstring * 10 => { { "abc", "def" }, { "ghi", "jkl" } }
print zarray(0,1), zarray(1,0), zarray(1, 1)
dim farray( 0 to 2, 0 to 2 ) as string * 5 => { { "xxx", "yyy" }, { "zzz", "aaa" } }
print "[" & farray(1, 0) & "]"
static sz( 0 to 2, 0 to 2 ) as zstring * 10 => { { "abc", "def" }, { "ghi", "jkl" } }
print sz(1,1)
dim ia( 0 to 2, 0 to 2 ) as integer => { { 1, 2 }, { 3, 4 } }
print ia(1,0), ia(1,1)
print "[" & farray(0, 2) & "]", len(farray(0,2)), "[" & farray(2, 2) & "]"
print ia(0,2), ia(2,2), "[" & zarray(0,2) & "]"
dim warray( 0 to 2, 0 to 2 ) as wstring * 6 => { { "123", "456" }, { "789", "012" } }
print warray(1, 1), warray(1,0)
