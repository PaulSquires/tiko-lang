'' THE MODULE THAT ONLY REFERENCES IT. Nothing here defines 'e'; the link is the
'' whole point, and it is what used to fail.
extern e as long

sub ShowUse( )
	print "use"; e
end sub
