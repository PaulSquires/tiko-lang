redim shared as string r(1 to 3)
dim shared as string d()
redim d(5)
sub f()
  static as string q(2)
  redim preserve d(7)
end sub
type U
  as string items(any)
  declare sub g()
end type
sub U.g()
  redim preserve this.items(0 to 3)
end sub
print "ok"
