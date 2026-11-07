'' A TYPE ARGUMENT THAT BREAKS A CONSTRAINT is refused with ONE message, TKO1022, at the use.
'' The instantiated body's own complaint -- 'a' has no member 'area' -- followed it.
interface IShape
  declare function Area() as double
end interface
type Sq
  implements IShape
  as double s
  declare function Area() as double implements IShape.Area
end type
function Sq.Area() as double
  return s * s
end function
function Total(of T as IShape)(a() as T) as double
  dim t as double
  for i as integer = lbound(a) to ubound(a)
    t += a(i).Area()
  next
  return t
end function
dim q(0 to 1) as Sq
q(0).s = 2 : q(1).s = 3
print Total(q())
print 1
dim n(0 to 1) as integer
print Total(n())
