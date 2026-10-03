'' A library that imports a module: its archive holds the module's object too, and as a DLL
'' it exports only what it marks 'export' -- never a module's names (RFC-0005 §6).
#import "std/strings"
public function Shout( byref s as string ) as string export
    return "<" & strings.Reverse( s ) & ">"
end function
