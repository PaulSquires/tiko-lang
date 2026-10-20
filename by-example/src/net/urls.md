# URLs

`ParseUrl` takes a URL apart into a `Url`, whose fields can be read, changed
and printed again. It follows the URL standard, RFC 3986.

```tiko
{{#include ../../examples/net/urls.tiko}}
```

**Output**

```text
{{#include ../../examples/net/urls.out}}
```

The fields hold the parts **decoded**: `Path` has `é` where the URL had
`%C3%A9`. `RawQuery` is the exception, kept as written, because only a query
parser knows where its pairs end; `Query( )` is that parser. `Port` is -1 when
the URL names none.

`Resolve( link )` turns a link found on a page into an absolute URL, as a
browser does: `item?id=8` replaces the last segment of the path, `/` goes to
the top of the site, and `//cdn.example/app.js` keeps only the scheme. Dot
segments are removed as the link is resolved — which is why
`/catégorie/../item` became `/item`.

`QueryValues` is a list of name and value pairs in order; a name may appear
more than once, and `GetAll` returns every value. `Encode( )` writes it back,
escaping each name and value, so `&` inside a value cannot split it.

Setting a field and calling `ToString( )` escapes what needs escaping: the
space in `summer sale` becomes `%20`. A URL with a broken escape, such as a
lone `%`, does not parse at all.

### Activities

1. Print `u.Resolve( "../../../x" ).Value( ).ToString( )`. Where does it stop?
2. Parse `"http://[::1]:9000/"` and print `Host` and `HostPort( )`.
