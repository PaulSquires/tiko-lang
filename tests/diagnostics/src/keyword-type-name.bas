'' TKO0807: a keyword cannot name a type, a typedef, an enum or a namespace -- fbc's
'' error 14 (17 for an enum). The controls at the bottom are accepted by fbc.
type Base
    dim as long k
end type
type Long2 as long
type Integer as long
enum Scope
    e1
end enum
namespace Operator
end namespace
namespace Print
end namespace

'' Accepted by fbc: an intrinsic names a type or an enum, a keyword is a prefix of a
'' name, a FIELD may be called base, and 'enum Rem' is an anonymous enum.
type Draw
    dim as long base
end type
enum Open
    e2
end enum
type BaseX
    dim as long k
end type
namespace Baseline
end namespace
enum Rem
    e3
end enum
dim as Draw d
d.base = 1
print d.base
