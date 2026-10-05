dim shared as zstring * 8 zq = "ab"
dim shared as wstring * 8 wq = "ab"
type Z1
    as long q
    declare operator cast( ) byref as zstring
end type
operator Z1.cast( ) byref as zstring : return zq : end operator
type W1
    as long q
    declare operator cast( ) byref as wstring
end type
operator W1.cast( ) byref as wstring : return wq : end operator
dim shared as Z1 zv : dim shared as W1 wv
print zv + 1; 1 + zv; zv - 1; zv * 2; zv = 97; zv > 96; zv + 1.5
print wv + 1; wv = 97; wv * 2
print zv & 1; zv + "1"; zv = "ab"
