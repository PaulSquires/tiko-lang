'' A STRING LITERAL HAS NO ADDRESS OF ITS OWN, and an alias to one is legal. Measured,
'' fbc stores the LITERAL'S address in the alias slot and reads through it like any other
'' reference:
''
''   char* I$0;  I$0 = (char*)"abc";
''   FBSTRING* vr$0 = fb_StrAllocTempDescZ( (char*)I$0 );
''
'' Asking LowerAddr alone left both declarations declining -- the alias had nothing to
'' bind to.
var byref i = "abc"
print i
dim byref rz as zstring = "foo"
print rz
