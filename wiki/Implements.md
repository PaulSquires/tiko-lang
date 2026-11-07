[Home](Home) › [Interfaces](Category-Interfaces) › **Implements**

# Implements

Lists the interfaces a type or class takes on, and says which interface member each method provides.

## Syntax

```freebasic
type name                        '' or: class name
    implements interface [ , interface ... ]
    declare method_signature implements interface.member [ , interface.member ... ]
    ...
end type
```

## Parameters

- `interface`: an interface, or an instance of a generic one: `IComparer( of ustring )`.
- `member`: a method or property of that interface, or of an interface it inherits.

## Description

`implements` is written in two places, and each one says something different.

**An `implements` line in the body** lists interfaces. It goes at the top of the body, after a class's `inherits` line and before any member (TKO0435). A type may list any number of interfaces, on one line or several, but each only once (TKO1006). Listing an interface also takes on every interface it inherits. Writing `implements` on the header, `type T implements I`, is an error that says where it belongs (TKO0436).

**An `implements` clause on a method's declaration** maps that method to an interface member. Mappings are explicit: a public method named `Close` does not implement `IFile.Close` until its declaration says `implements IFile.Close`. Then:

- **The method's name does not have to match the member's.** `FileName` can implement `IFile.Name`.
- **Same-named members of different interfaces are different members**, and each gets its own method.
- **One method can provide several members**: `implements IFile.Close, IItem.Close`.
- **A private method can implement a member.** It is then reachable through the interface and nowhere else.

```freebasic
interface IFile
    function Name( ) as ustring           '' the file's name
    sub Close( )
end interface

interface IItem
    function Name( ) as ustring           '' the item's display name
    sub Close( )
end interface

type Document
    implements IFile, IItem               '' one line, or one 'implements' line each
    declare function FileName( ) as ustring implements IFile.Name
    declare function Title( ) as ustring implements IItem.Name
    declare sub Close( ) implements IFile.Close, IItem.Close   '' one method, two members
    as int32 opened = 1
private:
    declare sub Flush( )
end type
function Document.FileName( ) as ustring
    return "report.txt"
end function
function Document.Title( ) as ustring
    return "Quarterly report"
end function
sub Document.Close( )
    Flush( )
    opened = 0
end sub
sub Document.Flush( )
    print "  (flushed)"
end sub

dim as Document doc
dim as IFile f = doc
dim as IItem it = doc
print f.Name( ); " / "; it.Name( )
it.Close( )
print "open:"; doc.opened
```

```
report.txt / Quarterly report
  (flushed)
open: 0
```

**The signatures must match exactly**: the parameters, their passing modes, the result type and const-ness (TKO1001 names what differs). A plain `type` maps its members with ordinary methods; a class may map one to a `virtual` or `abstract` method, and a derived class's `override` is then what calls through the interface reach.

**Every member must be provided** (TKO1000 names each one missing). A member the base class already provides counts, and mapping it again in the derived class is refused (TKO1011): override the base's method instead.

## Remarks

- The clause belongs on the declaration inside the type, not on the out-of-line body (TKO0438).
- A `static` method cannot implement a member (TKO1014).
- When the method and the interface member give a parameter different default values, a call through the interface uses the interface's, and the compiler warns (TKO1018).
- A generic class maps members of instances that use its own parameters: `implements IComparer( of T ).Compare`.

### See also

- [`Interface`](Interface)
- [`Class`](Class)
- [`Inherits`](Inherits)
- [`Type`](Type-Udt)
- [Interfaces Tutorial](Interfaces-Tutorial)

---

**Category:** [Interfaces](Category-Interfaces)
**Kind:** keyword
