'' A generic interface and a generic class implementing it, published in a module's interface
'' (docs/tiko-interfaces §11.5): both are written into it as text and re-read by the importer.
#module "getters"
public interface IGet( of T )
    function Get( ) as T
end interface
public class Cell( of T )
    implements IGet( of T )
    as T v
    declare function Get( ) as T implements IGet( of T ).Get
end class
function Cell( of T ).Get( ) as T
    return v
end function
