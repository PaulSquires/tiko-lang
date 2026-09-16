'' Module one of the pair. It has no '#cmdline' of its own, which is the point:
'' only the FIRST source file of a compile can restart it, so the directive in the
'' second module is read, warned about and dropped.
declare sub cmdlineOther( )

cmdlineOther( )
print "first"
