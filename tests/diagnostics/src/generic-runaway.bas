'' A MEMBER BODY THAT INSTANTIATES A DEEPER COPY OF ITS OWN TYPE never ends: each R( of
'' ... ) has a 'grow' that names R( of R( of ... ) ). fbc's depth rule cannot stop it --
'' a body always replays at depth 1 -- and fbc-modern 1.20 segfaults. tiko ran until it
'' was killed. It now stops at 256 levels of the real chain, with TKO0829.
type R( of T )
    as T v
    declare sub grow( )
end type
sub R( of T ).grow( )
    dim as R( of R( of T ) ) x
end sub
dim as R( of long ) a
a.grow( )
