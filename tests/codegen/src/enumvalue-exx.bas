'' enumvalue-exx.bas -- see ../enumvalue-exx-run.test
enum Colour
    RED = 1
    GREEN = 2
end enum
dim as long i = 1
print enumvalue( Colour, i )
i = 2
print enumvalue( Colour, i )
