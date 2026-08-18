'' The defining module. Spells the tuples WITHOUT element names.

extern "c++"

public function MakePair( byval a as long, byval b as long ) as (long, long)
	dim r as (long, long)
	r._1 = a
	r._2 = b
	return r
end function

public function SumPair( byval p as (long, long) ) as long
	function = p._1 + p._2
end function

public function MakeText( byval n as long ) as (long, string)
	dim r as (long, string)
	r._1 = n
	r._2 = "n=" & n
	return r
end function

end extern
