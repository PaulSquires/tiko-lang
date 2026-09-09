'' NAME, LOCK and UNLOCK. All three measured from fbc's own C output:
''
''     name a as b       rename( (char*)*(char**)&A, (char*)*(char**)&B )
''     name a, b         the SAME call -- both spellings, identical output
''     name "a" as "b"   rename( (char*)"a", (char*)"b" )
''     lock #1, 5        fb_FileLockLarge  ( 1, 5ll, 0ll )
''     lock #1, 3 to 9   fb_FileLockLarge  ( 1, 3ll, 9ll )
''     unlock #1, 3 to 9 fb_FileUnlockLarge( 1, 3ll, 9ll )
''     lock h, 2         fb_FileLockLarge  ( (int32)H, 2ll, 0ll )
''
'' TWO THINGS A GUESS WOULD HAVE GOT WRONG. The missing second bound is 0 and NOT a
'' repeat of the first. And NAME is LIBC -- a plain 'rename' over the strings' DATA
'' POINTERS -- where KILL, MKDIR and RMDIR in the same family go through fb_* entry
'' points, so the statement group is split across two conventions.
''
'' The 'to' half was being dropped by the PARSER before this: 'lock #1, 3 to 9' came
'' through as two operands and the 9 never reached lowering at all. Nothing said so.
dim as string a = "zzname1.tmp", b = "zzname2.tmp"
dim as integer h = 1

name a as b
name a, b
name "lit1.tmp" as "lit2.tmp"

lock #1, 5
lock #1, 3 to 9
unlock #1, 5
unlock #1, 3 to 9
lock h, 2
