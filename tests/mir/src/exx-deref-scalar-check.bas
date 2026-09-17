'' -exx: A LOAD OR A STORE THROUGH A POINTER IS STILL CHECKED.
''
'' The other half of exx-deref-string-nocheck: fbc emits fb_NullPtrChk for a deref the
'' generated code really does read or write through. Measured, same probe:
''
''     n = *pl          fb_NullPtrChk, then the load     CHECKED
''     *pl = 1          fb_NullPtrChk, then the store    CHECKED
dim as long storage = 7
dim as long ptr pl = @storage
dim as long n

n = *pl
*pl = 1
print n; *pl
