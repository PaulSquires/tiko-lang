' READ into a 'string * N' -- a field of an array element, a variable -- beside a
' 'zstring * N' field. fbc passes the tagged length and -1.
type Employee
    nm as string * 8
    z as zstring * 8
end type
dim as Employee emp(1)
dim as string * 6 f
read emp(1).nm, emp(1).z, f
print "["; emp(1).nm; "]["; emp(1).z; "]["; f; "]"
data "Tyler", "Zed", "LongerThanSix"
