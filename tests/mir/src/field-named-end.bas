'' 'end' CLOSES A TYPE BODY ONLY WHEN 'type', 'union' OR 'enum' FOLLOWS IT. A FIELD may
'' be called 'end' -- fbc builds 'struct $1P { int64 END; int64 V; };' and prints ' 5  1'
'' -- and the unconditional test closed the TYPE at that field, so everything after it
'' was read as module-level code and the whole file desynced. The 'as integer end'
'' spelling worked, which is what made it look like something other than a member name.
type P
	end as integer
	v as integer
end type

dim as P p
p.end = 5 : p.v = 1
print p.end, p.v

'' The other spelling, which always worked.
type Q
	as integer end
	as integer v
end type

dim as Q q
q.end = 7 : q.v = 8
print q.end, q.v
