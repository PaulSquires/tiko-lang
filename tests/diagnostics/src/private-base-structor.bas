'' A DERIVED type cannot reach a PRIVATE base structor -- fbc errors 207 and 208, on the
'' line of the 'type', with no instance of the type needed anywhere. MEASURED: PROTECTED
'' is accepted (that is what protected is for) and a private structor with NOTHING derived
'' from it is accepted too, so it is the derivation that is refused.
type ProtP
    as integer i
    protected:
    declare constructor( )
end type
constructor ProtP( )
end constructor

type ProtC extends ProtP
end type

type PrivC
    as integer i
    private:
    declare constructor( )
end type
constructor PrivC( )
end constructor

type BadC extends PrivC
end type

type PrivD
    as integer i
    private:
    declare destructor( )
end type
destructor PrivD( )
end destructor

type BadD extends PrivD
end type
