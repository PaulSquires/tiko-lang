'' Anonymous enums: at module level, and inside a TYPE. A #cinclude binding writes every
'' C enum this way.
enum Fruit
    APPLE = 1
end enum
enum
    ANON_A = 10
    ANON_B
end enum
type Box
    enum
        IN_BOX = 3
    end enum
    x as long
end type
