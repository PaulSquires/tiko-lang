'' Module B of comptr-mm. Instantiates ComPtr( of IFake ) independently of the
'' main module, and takes ownership of a reference detached over there.
#include once "comptr-mm-shared.bi"

function QueryInB( byval src as any ptr ) as long
	dim as ComPtr( of IFake ) got
	if( failed( ComQIAs( src, got ) ) ) then return -1
	dim as long n = RefsOf( got.Get( ) )
	return n
end function

function AdoptAndCount( byval raw as IFake ptr ) as long
	dim as ComPtr( of IFake ) p        '' B's own instantiation
	p.Attach( raw )
	dim as long n = RefsOf( p.Get( ) )
	p->Poke( )
	return n
end function
