'' 'var byref' over a fixed-length zstring or wstring is an unsized alias.
dim z as zstring * 10 = "12"
dim w as wstring * 10
var byref rz = z                                '' fine: zstring
var byref rw = w                                '' fine: wstring
dim byref bz as zstring * 10 = z                '' refused: written fixed-length
