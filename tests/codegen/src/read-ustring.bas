' READ into a var-len ustring, a ustring array element and a ustring field, beside a
' string. tiko handed the ustring to fb_DataReadStr, which wrote narrow bytes into the
' UTF-16 buffer.
type Rec
    as ustring nm
end type
dim as ustring a
dim as string b
dim as ustring arr(1)
dim as Rec r
read a, b, arr(1), r.nm
print a; "|"; b; "|"; arr(1); "|"; r.nm; "|"; len(a); len(arr(1))
data "hello", "world", "elem", "field"
