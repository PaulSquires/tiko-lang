'' TKO0808: a QUALIFIED type name that does not resolve is not declared -- it does not fall
'' back to the same name UNqualified. fbc refuses both lines 9 and 10 (errors 3 and 14).
namespace NS
    type Baz
        k as long
    end type
end namespace
type Foo as FooFwd
type Q as NS.Foo
dim as NS.Foo b1
