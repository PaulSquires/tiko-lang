'' Two instantiations of generics are unrelated types -- fbc's error 181 by assignment on
'' lines 17, 18 and 19, and 24 by initialiser on line 20 (fbc-modern 1.20). Line 22 is one
'' type and is accepted.
type Box( of T )
    as T v
end type
type Wrap( of T )
    as T w
end type
type Plain
    v as long
end type
dim as Box( of long ) bl, bl2
dim as Box( of double ) bd
dim as Wrap( of long ) wl
dim as Plain pl
bl = bd
bl = wl
bl = pl
dim as Box( of long ) bx = bd

bl = bl2
