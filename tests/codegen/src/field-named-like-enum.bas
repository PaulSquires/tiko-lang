' A field named like its own ENUM type -- 'kind as kind' -- in a type used directly, in WITH,
' and nested in another.
enum kind
    K0
    K1
end enum
type inner
    kind as kind
    x as integer
end type
type outer
    key as inner
end type
dim as outer t
with t
    .key.x = 2
    .key.kind = K1
end with
print t.key.x; t.key.kind; sizeof(inner)
