'' The definitions global-init-proc-addr/main.bas takes the addresses of.

extern "c"
function hookA alias "gipa_hookA" ( byval x as long ) as long
    return x + 1
end function
end extern

function hookB( byval x as long ) as long
    return x * 100
end function
