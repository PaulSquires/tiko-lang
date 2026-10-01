'' Block strings, run: the bytes of each value, LF shown as '|' and TAB as '<TAB>'.
function Show( byref s as string ) as string
    dim as string r = ""
    for i as long = 1 to len( s )
        dim as long c = asc( s, i )
        select case c
        case 10 : r &= "|"
        case 9  : r &= "<TAB>"
        case else : r &= chr( c )
        end select
    next
    return "[" & r & "] " & str( len( s ) )
end function
dim as string a = """
    select id, name
      from users

    where q = "x" and """ mid
    """
print "a "; Show( a )
dim as string b = """
  two
"""
print "b "; Show( b )
dim as string c = """
    line

    """
print "c "; Show( c )
dim as string d = !"""
    a\tb \
    c\"q\" \\ end
    """
print "d "; Show( d )
dim as string e = $"""
    C:\new\table
    """
print "e "; Show( e )
dim as string f = """
    """
print "f "; Show( f )
print "g "; Show( """
    arg
    """ & "+tail" )
#define GREETING """
    hello
      world
    """
print "h "; Show( GREETING )
#define STRINGIZE( x ) #x
print "i "; STRINGIZE( """
    p
    q\r
    """ )
const K = """
    k1
    k2
    """
print "j "; Show( K )
dim as ustring u = """
    wide
    text
    """
print "k "; len( u )
