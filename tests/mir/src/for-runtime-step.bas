'' A FOR STEP THAT IS NOT A COMPILE-TIME CONSTANT.
''
'' The comparison direction depends on the step's SIGN, so with a runtime step there
'' is no single test to emit. fbc computes the sign ONCE, before the loop, and branches
'' on it at the top of every iteration -- two tests, one taken.
''
'' tiko-lang used to record this as unlowered and then emit the RISING test anyway, so a
'' negative runtime step ran the loop zero times where fbc runs it to completion.
''
'' The step itself is also evaluated ONCE, into a temporary. It used to be re-lowered
'' inside the step block, so a step expression with a side effect ran once per
'' iteration.

sub P( byval s as long )
    dim as long n

    for i as long = 1 to 10 step s
        n += 1
    next

    '' A CONSTANT step still gets a single test, and a negative one still flips it.
    for j as long = 1 to 10 step 2
        n += 1
    next
    for k as long = 10 to 1 step -1
        n += 1
    next

    '' No step at all is an implicit 1, with no temporary.
    for m as long = 1 to 10
        n += 1
    next
end sub
