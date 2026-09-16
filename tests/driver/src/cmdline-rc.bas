'' A '#cmdline' WHOSE ARGUMENT IS NOT AN OPTION. fbc treats the word as an INPUT
'' FILE on the restarted command line, so a '.rc' named here is compiled and linked
'' exactly as one named on the command line is -- measured: the string lands in the
'' exe's .rsrc. 21 of AfxNova's examples ask for their resources this way.
''
'' THE PATH IS RESOLVED AGAINST THE CURRENT DIRECTORY, not against this file. Also
'' measured, with two different '.rc' files of the same name: the one beside the
'' compiler's cwd is the one that got linked.
#cmdline "tests/driver/src/cmdline-res.rc"

print "x"
