namespace na
    type T
        as long a
    end type
end namespace
namespace nb
    type T
        as long b
    end type
end namespace
using na
using nb
dim x as T
dim y as na.T
y.a = 1
print y.a
