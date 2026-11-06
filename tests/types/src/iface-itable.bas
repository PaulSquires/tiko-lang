'' docs/tiko-interfaces §7.3-§7.6: flattened slots (a diamond adds IBase.M once, the
'' primary base is a prefix) and which method implements which member -- a different
'' name, one method for two interfaces' members, a private implementer, an abstract
'' implementer filled by an override, and a pair the base provides.
interface IBase
    sub M( )
end interface
interface IA
    inherits IBase
    sub A1( )
end interface
interface IB
    inherits IBase
    sub B1( )
end interface
interface IC
    inherits IA, IB
    sub C1( )
end interface
interface IPrintable
    sub Flush( )
end interface
interface ISavable
    sub Flush( )
end interface

class Animal
    implements IA
    as long legs
    declare abstract sub Speak( ) implements IBase.M
    declare virtual sub Walk( ) implements IA.A1
end class
class Dog
    inherits Animal
    implements IC
    declare sub Speak( ) override
    declare sub Bark( ) implements IB.B1
    declare sub Wag( ) implements IC.C1
end class
type Doc
    implements IPrintable, ISavable
    as long pages
private:
    declare sub Flush( ) implements IPrintable.Flush, ISavable.Flush
end type
