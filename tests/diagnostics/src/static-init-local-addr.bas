'' A namespace variable initialized from the address of a module-level local -- fbc's 272
'' ('static') and 11 ('dim') on the refused lines.
static as integer si
dim as integer di
dim shared as integer sh
namespace ns
    dim as integer ptr p1 = @si                '' 272
    dim as integer ptr p2 = @di                '' 11
    dim as integer ptr p3 = @sh                '' fine
end namespace
