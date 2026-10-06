'' LINE INPUT reads a line into a STRING. fbc's error 24 for a number (lines 5 and 7);
'' every string kind -- field, element, string*N, wstring, ustring, typedef -- is fine.
type TS as string
dim as integer i : dim as double d : dim as TS ts
line input i
dim as string * 8 fx : dim as wstring * 8 w : dim as ustring u
line input #1, d
line input #1, fx : line input #1, w : line input #1, u : line input #1, ts
