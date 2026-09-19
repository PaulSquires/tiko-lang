'' An EXPLICIT enum's initialisers naming their siblings -- folded in the enum's own scope.
enum Shade explicit
    base_ = 3
    twice = base_ * 2
    four = twice + twice
    after
end enum
print Shade.base_
print Shade.twice
print Shade.four
print Shade.after
