'' a module-level redim of an extern dynamic array defines it
extern externarray6() as integer
extern externarray7() as integer
redim externarray6(6 to 6) as integer
redim shared externarray7(7 to 7) as integer
print lbound(externarray6), lbound(externarray7)
