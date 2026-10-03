'' See ../extern-import.test and ../extern-import-linux.test.
extern import MyDll_Data alias "MyDll_Data" as long
extern Plain_Data alias "Plain_Data" as long
print MyDll_Data + Plain_Data
