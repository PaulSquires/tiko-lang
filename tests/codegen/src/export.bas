public function AddUp cdecl alias "AddUp" ( byval a as long, byval b as long ) as long export
    return a + b
end function

private function Hidden( byval a as long ) as long
    return a
end function

function Plain( byval a as long ) as long
    return Hidden( a )
end function
