'' A generic instance keeps its template's private: (fbc error 202 on both writes).
type Box( of T )
    private:
    as T v
    public:
    declare function Get_( ) as T
end type
function Box( of T ).Get_( ) as T
    return this.v
end function
type Plain
    private:
    as long v
    public:
    declare function Get_( ) as long
end type
function Plain.Get_( ) as long
    return this.v
end function
dim b as Box( of long )
b.v = 5
dim p as Plain
p.v = 6
print b.Get_( ), p.Get_( )
