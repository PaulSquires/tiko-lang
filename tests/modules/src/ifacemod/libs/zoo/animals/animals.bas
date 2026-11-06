'' A public interface and a class implementing it, published in a module's interface
'' (docs/tiko-interfaces): both are written into it as text and re-read by the importer.
#module "animals"
public interface IAnimal
    sub Speak( )
    function Name( ) as string
end interface
public class Animal
    implements IAnimal
    as long legs
    declare virtual sub Speak( ) implements IAnimal.Speak
    declare function Name( ) as string implements IAnimal.Name
end class
sub Animal.Speak( )
end sub
function Animal.Name( ) as string
    return "animal"
end function
