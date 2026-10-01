'' A block string in a module's INTERFACE. A public const and a generic body are written
'' into the interface as text, so the literal must spell back as one line (pp.bas
'' BlockSpelling_) -- with its newline, its quote and its backslash intact.
#module "doc"
public const USAGE = """
    usage: tool "x"
      -p  C:\path
    """
public type Tag( of T )
    v as T
    declare function Render( ) as string
end type
function Tag( of T ).Render( ) as string
    return """
        <tag>
        """ & str( v )
end function
