[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › **sys/win/com**

# sys/win/com

Wraps COM for tiko: variants, safe arrays, `BSTR` strings and late-bound Automation calls.

COM is how Windows components and Automation servers (the scripting runtime, Office, WMI, the
shell) expose objects to any language. Their methods take and return three data types tiko does
not have natively: the `VARIANT`, a value of any type; the `SAFEARRAY`, an array that knows its
own bounds and element type; and the `BSTR`, a length-prefixed Unicode string. This module gives
each one a class that owns its memory and converts to and from tiko values, plus a class that
calls an object's methods and properties **by name**, and the functions that create objects.

The rules that apply throughout:

- **Initialise COM** on each thread that uses it: `CoInitialize( NULL )` first, `CoUninitialize()`
  last. [CDispInvoke](CDispInvoke) also does this for itself.
- **The classes own what they hold.** A `DVARIANT`, `DSafeArray` or `BSTRING` frees its contents
  when it goes out of scope or is assigned again; a `CDispInvoke` releases its object. Release
  every raw interface pointer you are given yourself, with
  [SafeRelease](SysWin-Com-Procedures#saferelease).
- **Destroy the objects before `CoUninitialize`.** Put the COM work in its own `scope`, or a
  procedure, so that every wrapper is gone when COM is shut down, as the example does.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/com"
using win, com
```

## Example

A `Scripting.Dictionary`, driven by name through `CDispInvoke`, with its keys read back from the
array of variants it returns:

```freebasic
#import "sys/win"
#import "sys/win/com"
using win, com

function main() as long
    CoInitialize( NULL )
    scope
        ' a Scripting.Dictionary, driven by name through IDispatch
        dim pDic as CDispInvoke = "Scripting.Dictionary"
        if pDic.IsObject() = false then print "Scripting.Dictionary is not available" : return 1
        pDic.Invoke( "Add", "ATH", "Athens" )
        pDic.Invoke( "Add", "ROM", "Rome" )
        pDic.Invoke( "Add", "OSL", "Oslo" )
        print "count:"; pDic.Get( "Count" ).ToStr()
        print "ROM is "; pDic.Get( "Item", "ROM" ).ToStr()

        ' Keys returns a VARIANT holding a safe array of VARIANTs
        dim keys as DVARIANT = pDic.Invoke( "Keys" )
        print "keys: "; keys.ToStr()
        for i as long = keys.GetLBound() to keys.GetUBound()
            print i; " "; keys.GetVariantElement( i ).ToStr()
        next
    end scope
    CoUninitialize()
    return 0
end function

end main()
```

It prints:

```text
count:3
ROM is Rome
keys: ATH; ROM; OSL
 0 ATH
 1 ROM
 2 OSL
```

## Pages

| Page | Covers |
| --- | --- |
| [DVARIANT](DVARIANT) | The `VARIANT` class: assigning and reading numbers, strings, dates, decimals, objects and arrays; conversions, arithmetic and comparison operators. |
| [DSafeArray](DSafeArray) | The `SAFEARRAY` class: creating one- and two-dimensional arrays of any element type, bounds, reading and writing elements, resizing, appending, copying. |
| [BSTRING](BSTRING) | The `BSTR` class: a COM string that converts to and from `wstring`, `ustring` and UTF-8, for methods that take or return a `BSTR`. |
| [CInt96](CInt96) | A 96-bit integer built on `DECIMAL`, with arithmetic, bitwise and shift operators and conversion to text and variants. |
| [CDispInvoke](CDispInvoke) | Late binding: creates or wraps an Automation object and gets and sets its properties and calls its methods by name or `DISPID`, with `DVARIANT` arguments and results. |
| [COM procedures](SysWin-Com-Procedures) | `NewCom`, `GetCom`, `AnyCom`, reference counting, event connections, GUIDs, OLE fonts, `VarToStr` and the variant-type tests; the `ComUnknown` and `ComDispatch` base types. |

## See also

- [Category: sys/win](Category-Sys-Win)
- [WebView2](SysWin-WebView2) and [Direct2D](SysWin-Direct2D), which are COM interfaces too
