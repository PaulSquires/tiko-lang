#lang "fb"

'' An enum is INTEGER-sized, so its PRINT entry point is the integer-width one.
enum E
    A = 1
    B = 4000000000
end enum

dim as E ev = E.B
print ev
print E.A
print sizeof( E )
