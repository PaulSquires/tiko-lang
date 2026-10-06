    type LivingThing
        declare constructor( a as integer )
        as integer a
    end type
    
    constructor LivingThing( a as integer )
    	this.a = a
	end constructor
    
    type Animal
        declare operator let( byref as LivingThing )
        as integer b
    end type
    
    operator Animal.let( byref rhs as LivingThing )
    	b = -rhs.a
	end operator
    
    type Dog
        declare operator cast () as LivingThing
        as integer c
    end type
    
    operator Dog.cast () as LivingThing
    	return LivingThing( 1234 )
	end operator
	
dim as Animal an
dim as Dog dg
		
		
an = dg
		
print an.b
