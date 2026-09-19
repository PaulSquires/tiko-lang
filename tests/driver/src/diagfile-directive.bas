'' diagfile-directive.bas -- a '#cmdline' may redirect the diagnostics file: the
'' source wins over the command line, as it does for every other option.
#cmdline "--diagnostics-file build/.diagfile-inner.tsv"
#print inner
