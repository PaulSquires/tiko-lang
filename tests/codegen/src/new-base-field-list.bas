type t1
	i as integer
end type
type t2 extends t1
	j as integer
end type
type t3 extends t2
	k as integer
end type
dim px2 as T2 ptr = new T2(1, 2)
print px2->i, px2->j
dim px3 as T3 ptr = new T3(3, 4, 5)
print px3->i, px3->j, px3->k
dim px4 as T3 ptr = new T3(6)
print px4->i, px4->j, px4->k
