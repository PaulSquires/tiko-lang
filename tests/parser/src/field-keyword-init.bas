'' tests/parser/field-keyword-init.test
type T
    Open as boolean = true
    Line as long => 7
    Name as string = "nm"
    Print as long = 2
    Color( 0 to 1 ) as long
    n as long = 3
end type
dim v as T
print v.Open, v.Line, v.Name, v.Print, v.n
