'' While skipping, a line continuation does not join lines.
#if 0
	print _
#endif
#if 1
#if 0
	x _
#else
dim as integer ok = 1
#endif
#endif
#if 0
	y _
#endif
nosuch = 1                                      '' refused: proves the #endif above closed
