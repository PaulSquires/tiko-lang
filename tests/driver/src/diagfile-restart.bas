'' diagfile-restart.bas -- pass one's diagnostics are discarded by a '#cmdline'
'' restart, in the file exactly as on the console.
#ifndef DFX
#print first-pass
#endif
#cmdline "-d DFX"
#ifdef DFX
#print restarted
#endif
