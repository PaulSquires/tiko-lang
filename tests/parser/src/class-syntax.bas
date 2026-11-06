'' 'class ... end class' (docs/tiko-interfaces §4.5): a type that always extends object.
class Animal
    declare constructor( )
    declare abstract sub Speak( )
    declare virtual function Name( ) as string
protected:
    as string nm_
end class

class Dog
    inherits Animal
    declare sub Speak( ) override
end class

type Plain extends object
    as long n
end type

class Sub2
    inherits Plain
    as long m
end class

class Box( of T ) field = 4
    as T value
end class
