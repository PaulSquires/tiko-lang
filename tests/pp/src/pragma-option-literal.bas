'' '#pragma [push(] private, N' reads N's VALUE. The literal arrived as a pool index, which is 0
'' only for a file's first literal, so 'private = 0' after any other literal read as true.
dim as integer x = 5, y = 7
#pragma push( private, 0 )
#if __FB_OPTION_PRIVATE__ <> 0
#error "push( private, 0 ) did not read 0"
#endif
#pragma pop( private )
#pragma private = 1
#if __FB_OPTION_PRIVATE__ = 0
#error "private = 1 read 0"
#endif
#pragma private = 0
#if __FB_OPTION_PRIVATE__ <> 0
#error "private = 0 did not read 0"
#endif
