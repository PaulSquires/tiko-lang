'' THE WIDE SUBSTRING AND TRIM FAMILY RETURNS AN ALLOCATION THE CALLER OWNS, and it was
'' being dropped. Measured against fbc for 'w1 = left( d, 3 )':
''
''     uint16* vr = fb_WstrLeft( (uint16*)D, 3ll );
''     fb_WstrAssign( (uint16*)W1, 50ll, (uint16*)vr );
''     fb_WstrDelete( (uint16*)vr );
''
'' tiko-lang emitted the first two and never the third, so every call in this family
'' leaked one temporary -- 12 of the 20 wstring corpus files that lower fully call
'' fb_WstrDelete in fbc and none of them did here. The result now leaves through
'' WideConcatStep_, which parks it in a temporary and registers that for release at the
'' end of the statement, exactly as 'wspace' already did.
dim as wstring * 50 d = wstr( "abcdefgh" )
dim as wstring * 50 w1

w1 = left( d, 3 )
print w1

w1 = right( d, 2 )
print w1

w1 = mid( d, 2, 3 )
print w1

w1 = ucase( d )
print w1

w1 = trim( d )
print w1
