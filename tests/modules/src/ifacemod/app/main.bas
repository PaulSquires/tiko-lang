'' An importer extends the published interface and implements it again.
#import "zoo/animals"
interface IPet
    inherits animals.IAnimal
    function Owner( ) as string
end interface
class Dog
    inherits animals.Animal
    implements IPet
    declare function Owner( ) as string implements IPet.Owner
end class
function Dog.Owner( ) as string
    return "me"
end function
type Rock
    implements animals.IAnimal
    as long weight
    declare sub Speak( ) implements animals.IAnimal.Speak
    declare function Name( ) as string implements animals.IAnimal.Name
end type
sub Rock.Speak( )
end sub
function Rock.Name( ) as string
    return "rock"
end function
dim as Dog d
print d.Owner( ), d.Name( ), sizeof( animals.IAnimal )
