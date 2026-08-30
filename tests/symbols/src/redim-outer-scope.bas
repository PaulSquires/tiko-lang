'' A REDIM RE-DIMENSIONS AN ARRAY THAT MAY LIVE IN AN ENCLOSING SCOPE, which is the
'' ordinary case: 'common array( )' at module level and 'redim array( 0 to 4 )' inside a
'' TEST body. The redeclaration check looked only in the LOCAL scope, found nothing, so
'' the first redim DECLARED A SHADOW and the second collided with it -- dim/redim.bas
'' reports two of those and neither is a duplicate to fbc.
''
'' Measured, all four:
''
''     inner scope, same type       ACCEPTED
''     inner scope, DIFFERENT type  ACCEPTED  -- it is a new local array, shadowing
''     module scope, same type      ACCEPTED
''     module scope, DIFFERENT type fbc error 4
''
'' -- so the type only has to agree when the two are in the SAME scope, which is what
'' falling through to the ordinary duplicate check gives.
common arr( ) as integer

scope
    redim arr( 0 to 4 ) as integer
    redim arr( 0 to 9 ) as integer
end scope

dim brr( ) as integer
scope
    '' A DIFFERENT element type in an inner scope shadows rather than clashing.
    redim brr( 0 to 4 ) as single
end scope
