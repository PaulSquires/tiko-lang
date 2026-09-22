'' THE MODULE THAT DEFINES IT. 'extern e' then 'dim e' is one object in two
'' declarations: this half is the storage, externdef-use.bas is the reference.
extern e as long
dim e as long = 5

sub ShowDef( )
	print "def"; e
end sub
