'' VAL OF A USTRING reads its text, not its first code unit. tracks' TdbLeg keeps
'' 'strike_price as ustring' and matches IBKR positions on 'val( pLeg->strike_price )';
'' tiko handed the UTF-16 descriptor to the narrow fb_VAL, which stopped after the first
'' digit -- 57.5 read as 5 -- so no option position ever matched and every conId went
'' out as 0. Measured, fbc converts first: fb_UStrToStr( &u, -1 ), then the narrow entry.
type TdbLeg
    as long    expiry_date
    as ustring strike_price
end type

dim as TdbLeg lg
lg.strike_price = "57.5"
dim as TdbLeg ptr pLeg = @lg
dim as ustring q = "42"

print "val field  "; val( lg.strike_price )
print "val ptr    "; val( pLeg->strike_price )
print "val local  "; val( q )
print "valint     "; valint( q )
print "vallng     "; vallng( q )
print "valuint    "; valuint( q )
print "valulng    "; valulng( q )
