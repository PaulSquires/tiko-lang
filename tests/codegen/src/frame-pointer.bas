'' Frame records: "frame-pointer"="non-leaf" on every definition for macos-arm64 (Apple's ABI;
'' clang's own default there), none for windows-x86_64 or linux-x86_64 (clang writes none at
'' -O2). A module unit's own init and fini carry it too; --emit-ir takes no module unit, so
'' those are not pinned here.

declare function Inner( byval x as long ) as long

function Outer( byval x as long ) as long
    return Inner( x ) + Inner( x + 1 )
end function

function Inner( byval x as long ) as long
    return x - 1
end function

print Outer( 2 )
