# cJSON examples

cJSON's C interface from tiko, through `vendor/cJSON`, which comes with the toolchain. Each
example is one `.tiko` program, built on its own with `tiko <name>.tiko`.

| Folder | Shows |
| --- | --- |
| `01-parse` | parse a document, look members up, check types, walk an array, report a parse error -- after cJSON's README |
| `02-create` | build a document item by item and with the `Add...ToObject` helpers; every kind of value; arrays from tiko arrays |
| `03-walk` | a recursive walk of any document, each value printed with its type and its JSON Pointer; `walk FILE.json` walks a file |
| `04-modify` | set, replace, insert, detach, delete and move items; duplicate, compare, references, minify |
| `05-files` | save and load a file; a stream of documents with `cJSON_ParseWithOpts`; the four ways to print |
| `06-utils` | `vendor/cJSON/utils`: JSON Pointer, JSON Patch, JSON Merge Patch, sorting |
| `07-hooks` | cJSON's memory through a counting allocator written in tiko, with `cJSON_InitHooks` |

## Things to know

- **Text cJSON prints is cJSON's to free.** `cJSON_Print`, `cJSON_PrintUnformatted`,
  `cJSON_PrintBuffered` and `cJSONUtils_FindPointerFromObjectTo` return memory that goes back
  through `cJSON_free`. Copy it into a `ustring` first -- JSON is UTF-8, and so is a `ustring`.
- **A tree is freed once, from its root.** An item added to an array or object belongs to it;
  `cJSON_Delete` on the root frees everything under it. A detached item belongs to nobody until
  it is added somewhere else or deleted.
- **`cJSON_ArrayForEach` is a C `for` loop, and has no tiko form.** Walk the children instead:

  ```
  dim as cJSON ptr item = arr->child
  while item
      ...
      item = item->next
  wend
  ```

- **`cJSON_SetIntValue`, `cJSON_SetNumberValue` and `cJSON_SetBoolValue`** are macros in C and
  functions here, with the same names, arguments and results.

## Dynamic or static

Every example imports cJSON with

```
#import "vendor/cJSON" link dynamic
```

which links the shared library and copies it beside the program -- `cJSON.dll` on Windows,
`cJSON_linux_x86_64.so` on Linux, where the program finds it beside itself. Change `dynamic` to
`static` and cJSON is built into the program instead, with nothing to copy. `06-utils` also
imports `vendor/cJSON/utils`, which links nothing of its own: the mode is chosen on
`vendor/cJSON`.

These examples are MIT-licensed, as cJSON is.
