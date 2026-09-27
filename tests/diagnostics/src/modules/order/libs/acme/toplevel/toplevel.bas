'' A module-level variable that is not shared belongs to the top-level code, which runs in
'' order: used above its 'dim', still error 42.
#module "toplevel"
print w
dim as long w = 2
