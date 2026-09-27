'' A procedure's local used above its 'dim': still fbc's error 42 in a module.
#module "inproc"
public sub S( )
    print v
    dim as long v = 1
end sub
