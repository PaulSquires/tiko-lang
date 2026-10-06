type t1
	i as integer
end type
type t2 extends t1
	j as integer
end type
type t3 extends t2
	k as integer
end type
dim x1 as t1 = (1)
dim x2 as t2 = (2, 20)
dim x3 as t3 = (3, 30, 300)
dim py1 as T1 ptr = new T3(x1)
print py1->i, cast( T3 ptr, py1 )->j, cast( T3 ptr, py1 )->k
dim py2 as T2 ptr = new T3(x2)
print py2->i, py2->j
dim py3 as T3 ptr = new T3(cast(T1,x3))
print py3->i, py3->j, py3->k
dim y as t3 = type<t3>(x2)
print y.i, y.j, y.k
