[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkDataGrid**

# tkDataGrid

Draws a data grid: typed columns over rows, edited in place, from the grid's own store, from a host
that answers each cell, or from a data source -- 10 rows or 100 million.

`tkDataGrid` is the [tkControls](Category-tkControls) data grid. Columns have a kind (text, number,
check, combo, date, button, link, progress) and a value kind (text, integer, float, boolean, date).
Rows are scrolled pixel by pixel in both directions; only the visible cells are read and painted.
There are frozen columns, row headers, column resize, autosize and reorder, cell and row selection,
Ctrl+C / Ctrl+V as tab-separated text, in-place editors with parsing and a row transaction, sort and
filter, and a block cache for slow data. `tkDataGridSqlite` (below) puts an SQLite query in it.

Every setter is silent; only user interaction notifies. **Every row and column number in the API is
a model row and a model column**: sorting, filtering and dragging columns change what the screen
shows, never what a number means. The Form Designer's **DataGrid** fills its rows from an
`Array( of T )` and writes them back. See [Form Designer](Form-Designer), Data binding.

## Importing

```freebasic
#import "vendor/tkControls/tkDataGrid"

using tkDataGrid
using tkHost
```

The module brings in [tkHost](tkHost) (and through it [tkPaint](tkPaint), SDL3, SDL_ttf and
SDL_image), [tkTheme](tkTheme), [tkColumnHeader](tkColumnHeader), the scrollbars,
[tkCalendar](tkCalendar) (for `TKDATE`) and [tkTooltip](tkTooltip). Its editors are
[tkTextBox](tkTextBox), [tkComboBox](tkComboBox) and [tkDatePicker](tkDatePicker). Add
`using tkPaint` for a paint callback, `using tkCalendar` to fill a `TKDATE`.

## Example

`host` is a `TK_HOST ptr` from `tkHost_Create`, set up as in the [tkButton](tkButton) example.

```freebasic
sub Grid_CurrentCellChanged( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer )
    print "now on row " & row & ", column " & col         ' model numbers, whatever the sort
end sub

sub Grid_RowCommitted( byval hGrid as TK_WIDGET ptr, byval row as integer )
    print "row " & row & " saved: " & tkDataGrid_GetCellText( hGrid, row, 0 )
end sub

dim as TK_WIDGET ptr g = tkDataGrid_Create( tkHost_Root( host ), 100 )
tkWidget_SetPos( g, tkHost_Scale( host, 10 ), tkHost_Scale( host, 10 ), tkHost_Scale( host, 520 ), tkHost_Scale( host, 300 ) )
tkDataGrid_AddColumnEx( g, "Item", TKDG_COL_TEXT, 160 )
tkDataGrid_AddColumnEx( g, "Qty", TKDG_COL_NUMBER, 60, TKDG_INT )      ' a number column holding integers
tkDataGrid_AddColumnEx( g, "Price", TKDG_COL_NUMBER, 80 )              ' float by default
tkDataGrid_AddColumnEx( g, "Paid", TKDG_COL_CHECK, 50 )
tkDataGrid_AddColumnEx( g, "Due", TKDG_COL_DATE, 100 )

tkDataGrid_BeginUpdate( g )
tkDataGrid_SetRowCount( g, 2 )
tkDataGrid_SetCellText( g, 0, 0, "Tea" ) : tkDataGrid_SetCellInt( g, 0, 1, 2 ) : tkDataGrid_SetCellFloat( g, 0, 2, 4.5 )
tkDataGrid_SetCellText( g, 1, 0, "Cups" ) : tkDataGrid_SetCellInt( g, 1, 1, 6 ) : tkDataGrid_SetCellBool( g, 1, 3, true )
tkDataGrid_SetCellText( g, 1, 4, "2026-11-09" )                        ' converted to the column's date
tkDataGrid_EndUpdate( g )

tkDataGrid_SetAllowAddRows( g, true )                                  ' a placeholder row after the last
tkDataGrid_SetFrozenColumns( g, 1 )
tkDataGrid_SetCurrentCellChangedCallback( g, @Grid_CurrentCellChanged )
tkDataGrid_SetRowCommittedCallback( g, @Grid_RowCommitted )
```

## Columns and values

- `AddColumnEx( h, caption, kind, width, valueKind )` is the common case; `AddColumn` /
  `InsertColumn` take a whole `TKDATAGRID_COLUMN` (key, caption, kind, valueKind, width, minWidth,
  maxWidth, fillWeight, align, readOnly, visible, sortable, resizable, itemData). `GetColumnInfo` /
  `SetColumnInfo` read and change one; `FindColumn( key )`. With no valueKind, a number or progress
  column holds floats, a check column booleans, a date column dates, the rest text.
- **Column kinds**: `TKDG_COL_TEXT`, `_NUMBER` (right-aligned), `_CHECK` (a check box from the value
  as a boolean), `_COMBO` (edited in a combo box filled by `SetColumnItems`), `_DATE` (edited in a
  date picker), `_BUTTON` and `_LINK` (they fire ButtonClick), `_PROGRESS` (a bar, 0..100), `_ICON`
  (text), `_CUSTOM` (the CellPaint callback's).
- A column with `fillWeight > 0` shares the width the others leave; `minWidth` stops a drag;
  `SetFrozenColumns( n )` keeps the first n display positions from scrolling sideways.
  `SetDisplayIndex` moves a column on screen without renumbering it.
- **Values**: every cell holds a `TKDG_VALUE` of one kind -- `TKDG_EMPTY` (no value: a database
  NULL, a new row's cell), `TKDG_TEXT`, `TKDG_INT`, `TKDG_FLOAT`, `TKDG_BOOL`, `TKDG_DATE`. A value
  written in another kind is converted to the column's, or refused when it cannot be (the setter
  returns FALSE): `SetCellText( h, r, c, "abc" )` on an integer column is refused. `GetCell*` convert
  the other way; `IsCellEmpty`, `ClearCell`.

## Where the rows come from

| Feed | Set with | The grid keeps |
| --- | --- | --- |
| **Stored** (default) | `SetRowCount`, `SetCell*`, `InsertRows`, `AddRow`, `DeleteRows` | one typed array per column |
| **Virtual** | `SetVirtual( true )`, `SetRowCount( n )`, `SetCellValueNeededCallback` (and `SetCellValuePushedCallback` to take edits) | nothing per row |
| **Source** | `SetSource( h, @src )`: a `TKDATAGRID_SOURCE` procedure table and its `pCtx` | nothing per row |

`SetSource( h, 0 )` returns to the store. A source's procedures: `RowCount`, `GetCell`, `SetCell`,
`InsertRows`, `DeleteRows`, `Sort`; one left 0 means "cannot" (no SetCell: read-only; no Sort: the
grid sorts). `GetSourceContext( h )` answers the `pCtx` the grid shows.

When the host changes its data under a virtual grid or a source: `InvalidateCells` (values only),
`NotifyRowsInserted` / `NotifyRowsRemoved`, or `Reset` (everything; a source's row count is asked
again).

### The block cache

For a virtual feed or a source whose reads are slow, `tkDataGrid_SetBlockCache( h, rows = 100,
blocks = 50 )` keeps rows in blocks (`rows = 0` turns it off). **Painting never waits**: a cell whose
block is not loaded paints a placeholder bar, and the block is asked for once --

- with a `SetDataRequestCallback` handler, as `DataRequest( firstRow, count )`; the host answers
  with `tkDataGrid_SupplyRows( h, firstRow, count, values() )` (count rows of `GetColumnCount`
  values each, in model column order), at once or later. **SupplyRows runs on the UI thread**: a
  worker posts it with `tkApp_RunOnUI` (see [tkApp](tkApp));
- with no DataRequest handler, by the grid itself from the feed, once per block instead of once per
  paint.

Every other read -- the `GetCell*` API, copy, sort and filter keys, an editor's first value -- takes a
loaded block, else reads the feed at once, so copying rows not yet loaded fetches them. A write the
feed takes goes into its block too. Row and column changes, a new feed and `Reset` drop every block;
the least recently painted block is reused first. `IsRowLoaded( h, row )`.

## Selection and the current cell

There is always one **current cell** (`GetCurrentCell` / `SetCurrentCell`), apart from the
selection. `SetSelectionUnit( TKDG_SEL_CELL | TKDG_SEL_ROW | TKDG_SEL_CELLORROW )` (the default:
cells, or whole rows from the row headers), `SetMultiSelect`. The selection is held as row spans and
cell rectangles, never per row: `SelectAll` on 100 million rows costs nothing.
`SelectRows`, `SelectRange`, `ClearSelection`, `IsCellSelected`, `IsRowSelected`,
`GetSelectedRows`, `GetSelectedRanges`. `GetSelectionText` / `CopySelection` give the selection as
tab-separated text (Ctrl+C), the cells as shown.

## Mouse and keyboard

- A press on a cell moves the current cell and selects it (Ctrl toggles, Shift extends from the
  anchor); a drag extends, scrolling when it leaves the body. A row-header press selects rows; the
  corner selects all. `ShowRowHeaders`, `SetRowHeaderWidth`.
- A header click sorts (below), or selects the column with `SetColumnHeaderSelects( true )`. A drag
  past a few pixels reorders the column (`SetAllowColumnReorder`); the gutter between two headers
  resizes (`SetAllowColumnResize`), a double click on it autosizes (`AutoSizeColumn`).
- Keys: arrows, Ctrl+arrows to the edge, Home / End (Ctrl: first / last cell), PgUp / PgDn, Enter /
  Shift+Enter down / up, Tab / Shift+Tab along the row (at the grid's ends the focus moves on,
  unless `SetTabWraps`), Shift extends, Shift+Space a row, Ctrl+Space a column, Ctrl+A, Ctrl+C,
  Ctrl+V, Delete (whole rows, or empties cells), F2 edits, Esc cancels the row's changes.

## Editing

`SetEditMode` says what starts an edit: `TKDG_EDIT_ONENTER` (the cell becoming current),
`TKDG_EDIT_ONF2` (F2 or a double click), `TKDG_EDIT_ONKEYSTROKE` (a typed character replaces the
content), `TKDG_EDIT_ONKEYSTROKEORF2` (the default), `TKDG_EDIT_PROGRAMMATIC` (`BeginEdit` only).

- Text and number cells edit in a [tkTextBox](tkTextBox), combo cells in a [tkComboBox](tkComboBox)
  (`SetColumnItems`), date cells in a [tkDatePicker](tkDatePicker). A check cell toggles in place
  (Space or a click); button and link cells fire ButtonClick.
- **The lifecycle**: `CellBeginEdit` may veto. On commit the text is parsed by the column's value
  kind; `CellParse` may change the value or refuse it, and a refusal keeps the editor open, framed in
  the error colour, with the reason in `GetEditError`. A changed value is written and fires
  `CellValueChanged`; then `CellEndEdit`. `BeginEdit`, `EndEdit( h, bCommit )`, `IsEditing`,
  `GetEditor`.
- **The row transaction**: the row of a changed cell is the **dirty row** (`GetDirtyRow`) until it
  is left -- `RowValidating` may keep the current cell in it, then `RowCommitted` -- or Esc puts its
  values back (`CancelRowEdit`). `CommitRow`, `CancelRowEdit`.
- `SetAllowAddRows( true )` shows a placeholder row after the last; typing in it makes it real
  (`RowAdded`). `SetAllowDeleteRows`; `RowsDeleting` may keep the rows. `SetReadOnly` for the whole
  grid, `SetColumnReadOnly` for one column.
- `Paste` / `PasteText` put tab-separated text in from the current cell, rows down and columns
  right (a quoted field may hold tabs and line breaks). Each value is parsed by its column and one
  that will not go in is skipped; they are written at once, outside the row transaction.

## Sort and filter

A header click sorts by that column, ascending, then descending, then not; **Shift+click** adds a
key. The rows on screen are a view over the model rows: `ViewToModel`, `ModelToView`,
`GetViewCount`. `SetSortMode`:

- `TKDG_SORT_INTERNAL` -- the grid sorts (stable; empty values first; text case-insensitive);
- `TKDG_SORT_HOST` -- a key change fires `SortChanged`; the host re-queries and calls `Reset`;
- `TKDG_SORT_AUTO` (the default) -- HOST for a virtual grid, INTERNAL otherwise;
- `TKDG_SORT_NONE` -- header clicks do not sort.

A source with a `Sort` procedure is asked first and, when it sorts, the grid keeps no order of its
own. `SetSortKeys`, `GetSortKeys`, `ClearSort`. `SetFilterCallback` keeps the rows it returns TRUE
for; `SetQuickFilter( text )` keeps rows where any visible column's shown text contains it. Filtering
runs before sorting. A change of the data re-sorts nothing until `Sort` / `ApplyFilter` or a header
click.

## Notifications

| Callback | When |
| --- | --- |
| `SetCurrentCellChangedCallback` | the user moved the current cell (row, col) |
| `SetSelChangeCallback` | the user changed the selection |
| `SetCellClickCallback`, `SetCellActivateCallback` | a click; a double click, or Enter on a cell that cannot be edited |
| `SetButtonClickCallback` | a button or link cell was clicked or activated |
| `SetColumnClickCallback`, `SetColumnResizeCallback`, `SetColumnReorderedCallback` | the header: a click, a resize (`bLive` while dragging), a column moved |
| `SetSortChangedCallback` | the sort keys changed by a header click |
| `SetCellBeginEditCallback` | an edit is starting; FALSE vetoes it |
| `SetCellParseCallback` | the editor's text, parsed or not; may change the value or refuse it |
| `SetCellEndEditCallback` | an edit ended, committed or not |
| `SetCellValueChangedCallback` | the user changed a cell's value |
| `SetRowValidatingCallback`, `SetRowCommittedCallback`, `SetCancelRowEditCallback` | the row transaction |
| `SetRowAddedCallback`, `SetRowsDeletingCallback` | the placeholder became a row; rows are about to be deleted (FALSE keeps them) |
| `SetCellValueNeededCallback`, `SetCellValuePushedCallback` | virtual mode: give a cell's value; take an edited one |
| `SetDataRequestCallback` | the block cache wants rows |
| `SetFilterCallback` | keep this row? |
| `SetTooltipCallback` | a cell's (or, row -1, a header's) tip text |
| `SetCellFormattingCallback` | per visible cell per paint: change its text, colours, alignment |
| `SetCellPaintCallback` | replaces a cell's drawing; `tkDataGrid_PaintCellDefault( pi )` draws the stock one |
| `SetHeaderPaintCallback` | the header cells, painted as [tkColumnHeader](tkColumnHeader) paints |
| `SetMessageCallback` | the input stream, hit-tested; TRUE claims a message |

## Layout and geometry

`SetRowHeight` (every row the same height), `SetHeaderHeight`, `ShowHeader`, `SetGridLines(
TKDG_GRID_NONE | _HORZ | _VERT | _BOTH )`, `SetAlternateRows`, `SetBorderWidth`,
`SetScrollBarWidth`, `SetFont`, `SetHeaderFont`. Sizes are design units, scaled by the host.
`GetTopRow` / `SetTopRow`, `SetScrollX` / `SetScrollY`, `EnsureVisible`, `GetVisibleRows`,
`GetCellRect`, `GetColumnRect` and `HitTest` answer in the surface's pixels (`GetSurface`).
`BeginUpdate` / `EndUpdate` around a batch of changes.

## Colours and theme

`TKDATAGRID_COLORS` has the back and alternate-row back, text, grid lines, the hot row, the
selection with and without the focus, the current cell's frame, read-only text, the frozen line, the
accent (check fill, progress), links, button faces, the border, the row headers, the column drop mark
and the error frame. `tkDataGrid_ThemeColors( t )` maps them from the theme's roles. `SetColors`
pins the struct (a theme change leaves it) until `UnpinColors`. The header's colours are
tkColumnHeader's, through `GetHeader`.

## tkDataGridSqlite: an SQLite query as the rows

```freebasic
#import "vendor/tkControls/tkDataGridSqlite"
#import "vendor/sqlite3"

using tkDataGridSqlite

dim as TKDGSQL ptr q = tkDataGridSqlite_Open( g, db, "select id, name, age, born, vip from person" )
tkDataGridSqlite_SetWritable( q, "person", "id" )      ' edits and deletes write back, by id
' ...
tkDataGridSqlite_Close( q )                            ' db stays open: it is the caller's
```

Its own module, so a grid that does not read SQLite does not link it.

- `Open( h, db, query, bColumns = true, blockRows = 100, maxBlocks = 50 )` makes the grid's columns
  from the query's, each in the kind its declared type says: INT → a number column holding integers;
  REAL, FLOAT, DOUBLE, NUMERIC, DECIMAL → number; BOOL → check; DATE → date (stored as
  `yyyy-mm-dd` text); anything else → text. NULL is an empty cell. It returns 0 when the query does
  not prepare.
- The row count is `select count(*) from ( query )`; rows are read **a block at a time** (`select *
  from ( query ) … limit ? offset ?`) into an LRU of blocks, so a paint costs one query per block it
  has not seen, not one per cell.
- **Sorting happens in SQL**: the grid's sort keys become the query's `order by` (text columns
  `collate nocase`); clearing the keys goes back to the query's own order. `GetOrderBy`.
- **Writes are opt-in**: after `SetWritable( q, table, pkColumn )` an edit is `update <table> set
  <column> = ? where <pk> = ?` and a deleted row `delete from <table> where <pk> = ?`; the key column
  must be one of the query's. Adding rows is not offered: insert with SQL, then
  `tkDataGridSqlite_Refresh( q )` (rows counted again, the grid reset). `LastError`,
  `GetFetchCount`.

## In the Form Designer

The toolbox's **DataGrid** (Lists) has the properties RowHeight, HeaderHeight, ShowHeader,
ShowRowHeaders, RowHeaderWidth, FrozenColumns, GridLines, AlternateRows, SelectionUnit, MultiSelect,
EditMode, ReadOnly, AllowAddRows, AllowDeleteRows, EditSelectAll, SortMode, AllowColumnResize,
AllowColumnReorder, ColumnHeaderSelects, TabWraps, Virtual, BackColor, BorderWidth, ScrollBarWidth,
Font, HeaderFont and HoverTime, the colours above, and the events in the table (CurrentCellChanged
by default). Its **Columns** editor gives each column Text, Width, Kind, Field, Align, MinWidth,
Fill, ReadOnly and Visible.

**Binding** a grid to an `Array( of T )`:

- **ItemsField** names an array field of the form's DataType and **ItemType** its element type;
  each column's **Field** names a field of the element (or a method, `Total( )`, shown and never
  written). `LoadFrom` fills the grid, a column per field in its kind; `SaveTo` commits an open edit
  (a value the grid refuses stops the save), then writes every row back -- rows added and deleted
  included. **ItemsSource** fills it from any array, through the generated `<grid>_Fill( )`.
- **ItemsLive** shows the array in place instead: the grid reads and writes the elements, rows added
  and deleted change the array at once, and `SaveTo` copies only into another record. The array
  must outlive the binding (a record's field, or a name for ItemsSource, never a call).
- `<grid>_Item( )` is the current row's element index (the array's order, whatever the sort).
- A **Navigator** may follow a grid: a click on a row moves the navigator, and the navigator moves
  the grid's current row. `IsDirty` counts a grid's changed rows and its open edit.

See [Form Designer](Form-Designer), Data binding.

## Public declarations

### Constants

`TKDG_EMPTY`, `TKDG_TEXT`, `TKDG_INT`, `TKDG_FLOAT`, `TKDG_BOOL`, `TKDG_DATE` ·
`TKDG_COL_TEXT`, `TKDG_COL_NUMBER`, `TKDG_COL_CHECK`, `TKDG_COL_COMBO`, `TKDG_COL_DATE`,
`TKDG_COL_BUTTON`, `TKDG_COL_LINK`, `TKDG_COL_ICON`, `TKDG_COL_PROGRESS`, `TKDG_COL_CUSTOM` ·
`TKDG_ALIGN_AUTO`, `TKDG_ALIGN_LEFT`, `TKDG_ALIGN_CENTER`, `TKDG_ALIGN_RIGHT` ·
`TKDG_GRID_NONE`, `TKDG_GRID_HORZ`, `TKDG_GRID_VERT`, `TKDG_GRID_BOTH` ·
`TKDG_HT_NONE`, `TKDG_HT_HEADER`, `TKDG_HT_DIVIDER`, `TKDG_HT_CELL`, `TKDG_HT_EMPTY`,
`TKDG_HT_ROWHEADER`, `TKDG_HT_CORNER` ·
`TKDG_EDIT_ONENTER`, `TKDG_EDIT_ONF2`, `TKDG_EDIT_ONKEYSTROKE`, `TKDG_EDIT_ONKEYSTROKEORF2`,
`TKDG_EDIT_PROGRAMMATIC` · `TKDG_SORT_AUTO`, `TKDG_SORT_NONE`, `TKDG_SORT_INTERNAL`,
`TKDG_SORT_HOST` · `TKDG_SEL_CELL`, `TKDG_SEL_ROW`, `TKDG_SEL_CELLORROW` ·
`CDATAGRID_DEFAULT_ROWHEIGHT` (24), `CDATAGRID_DEFAULT_HEADERHEIGHT` (26),
`CDATAGRID_DEFAULT_SCROLLWIDTH` (12), `CDATAGRID_DEFAULT_COLWIDTH` (100),
`CDATAGRID_DEFAULT_MINWIDTH` (24), `CDATAGRID_CELL_PAD` (6), `CDATAGRID_DIVIDER_GUTTER` (3).

### Types

`TKDG_VALUE` (`kind`, `s`, `i`, `f`, `b`, `d`; `SetText`, `SetInt`, `SetFloat`, `SetBool`, `SetDate`,
`Clear`), `TKDATAGRID_COLUMN`, `TKDG_HITTEST`, `TKDG_SORTKEY` (`col`, `bDescending`), `TKDG_RANGE`,
`TKDATAGRID_COLORS`, `TKDATAGRID_CELLPAINTINFO`, `TKDATAGRID_FORMATINFO`,
`TKDATAGRID_MESSAGEINFO`, `TKDATAGRID_SOURCE`, and the callback types `DG_CellPaintFunc`,
`DG_CellFormattingSub`, `DG_MessageFunc`, `DG_CellSub`, `DG_GridSub`, `DG_ColumnSub`,
`DG_ColumnResizeSub`, `DG_ColumnReorderedSub`, `DG_TooltipFunc`, `DG_CellBeginEditFunc`,
`DG_CellParseFunc`, `DG_CellEndEditSub`, `DG_RowFunc`, `DG_RowSub`, `DG_RowsDeletingFunc`,
`DG_RowsSub`, `DG_FilterFunc`, `DG_CellValueNeededSub`, `DG_CellValuePushedFunc`.
tkDataGridSqlite: `TKDGSQL`.

### Procedures

```freebasic
' ---- the control, columns, rows and cells
function tkDataGrid_Create( byval hParent as TK_WIDGET ptr, byval CtrlID as long ) as TK_WIDGET ptr
function tkDataGrid_GetSurface( byval hGrid as TK_WIDGET ptr ) as TK_WIDGET ptr
function tkDataGrid_GetVScrollBar( byval hGrid as TK_WIDGET ptr ) as TK_WIDGET ptr
function tkDataGrid_GetHScrollBar( byval hGrid as TK_WIDGET ptr ) as TK_WIDGET ptr
function tkDataGrid_GetHeader( byval hGrid as TK_WIDGET ptr ) as TK_WIDGET ptr
sub tkDataGrid_BeginUpdate( byval hGrid as TK_WIDGET ptr )
sub tkDataGrid_EndUpdate( byval hGrid as TK_WIDGET ptr )
sub tkDataGrid_Refresh( byval hGrid as TK_WIDGET ptr )
function tkDataGrid_InsertColumn( byval hGrid as TK_WIDGET ptr, byval col as integer, byref c as const TKDATAGRID_COLUMN ) as integer
function tkDataGrid_AddColumn( byval hGrid as TK_WIDGET ptr, byref c as const TKDATAGRID_COLUMN ) as integer
function tkDataGrid_AddColumnEx( byval hGrid as TK_WIDGET ptr, byref caption as const ustring, byval kind as long = TKDG_COL_TEXT, byval nWidth as integer = CDATAGRID_DEFAULT_COLWIDTH, byval valueKind as long = -1 ) as integer
function tkDataGrid_DeleteColumn( byval hGrid as TK_WIDGET ptr, byval col as integer ) as boolean
sub tkDataGrid_ClearColumns( byval hGrid as TK_WIDGET ptr )
function tkDataGrid_GetColumnCount( byval hGrid as TK_WIDGET ptr ) as integer
function tkDataGrid_GetColumnInfo( byval hGrid as TK_WIDGET ptr, byval col as integer, byref c as TKDATAGRID_COLUMN ) as boolean
function tkDataGrid_SetColumnInfo( byval hGrid as TK_WIDGET ptr, byval col as integer, byref c as const TKDATAGRID_COLUMN ) as boolean
function tkDataGrid_FindColumn( byval hGrid as TK_WIDGET ptr, byref key as const ustring ) as integer
function tkDataGrid_GetColumnCaption( byval hGrid as TK_WIDGET ptr, byval col as integer ) as ustring
function tkDataGrid_SetColumnCaption( byval hGrid as TK_WIDGET ptr, byval col as integer, byref caption as const ustring ) as boolean
function tkDataGrid_SetColumnReadOnly( byval hGrid as TK_WIDGET ptr, byval col as integer, byval b as boolean ) as boolean
function tkDataGrid_GetColumnReadOnly( byval hGrid as TK_WIDGET ptr, byval col as integer ) as boolean
function tkDataGrid_GetColumnWidth( byval hGrid as TK_WIDGET ptr, byval col as integer ) as integer
function tkDataGrid_SetColumnWidth( byval hGrid as TK_WIDGET ptr, byval col as integer, byval nWidth as integer ) as boolean
function tkDataGrid_GetColumnVisible( byval hGrid as TK_WIDGET ptr, byval col as integer ) as boolean
function tkDataGrid_SetColumnVisible( byval hGrid as TK_WIDGET ptr, byval col as integer, byval bVisible as boolean ) as boolean
function tkDataGrid_GetDisplayIndex( byval hGrid as TK_WIDGET ptr, byval col as integer ) as integer
function tkDataGrid_ColumnAtDisplay( byval hGrid as TK_WIDGET ptr, byval dispPos as integer ) as integer
function tkDataGrid_SetDisplayIndex( byval hGrid as TK_WIDGET ptr, byval col as integer, byval dispPos as integer ) as boolean
function tkDataGrid_GetRowCount( byval hGrid as TK_WIDGET ptr ) as integer
sub tkDataGrid_SetRowCount( byval hGrid as TK_WIDGET ptr, byval n as integer )
function tkDataGrid_InsertRows( byval hGrid as TK_WIDGET ptr, byval row as integer, byval n as integer = 1 ) as integer
function tkDataGrid_AddRow( byval hGrid as TK_WIDGET ptr ) as integer
function tkDataGrid_DeleteRows( byval hGrid as TK_WIDGET ptr, byval row as integer, byval n as integer = 1 ) as boolean
sub tkDataGrid_Clear( byval hGrid as TK_WIDGET ptr )
function tkDataGrid_GetRowData( byval hGrid as TK_WIDGET ptr, byval row as integer ) as integer
function tkDataGrid_SetRowData( byval hGrid as TK_WIDGET ptr, byval row as integer, byval v as integer ) as boolean
function tkDataGrid_SetCell( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer, byref v as const TKDG_VALUE ) as boolean
function tkDataGrid_GetCell( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer, byref v as TKDG_VALUE ) as boolean
function tkDataGrid_SetCellText( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer, byref s as const ustring ) as boolean
function tkDataGrid_SetCellInt( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer, byval n as longint ) as boolean
function tkDataGrid_SetCellFloat( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer, byval x as float64 ) as boolean
function tkDataGrid_SetCellBool( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer, byval bv as boolean ) as boolean
function tkDataGrid_SetCellDate( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer, byref d as const TKDATE ) as boolean
function tkDataGrid_ClearCell( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer ) as boolean
function tkDataGrid_GetCellText( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer ) as ustring
function tkDataGrid_GetCellInt( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer ) as longint
function tkDataGrid_GetCellFloat( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer ) as float64
function tkDataGrid_GetCellBool( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer ) as boolean
function tkDataGrid_GetCellDate( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer ) as TKDATE
function tkDataGrid_IsCellEmpty( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer ) as boolean

' ---- look
function tkDataGrid_GetRowHeight( byval hGrid as TK_WIDGET ptr ) as integer
sub tkDataGrid_SetRowHeight( byval hGrid as TK_WIDGET ptr, byval nHeight as integer )
function tkDataGrid_GetRowHeightPx( byval hGrid as TK_WIDGET ptr ) as integer
function tkDataGrid_GetHeaderHeight( byval hGrid as TK_WIDGET ptr ) as integer
sub tkDataGrid_SetHeaderHeight( byval hGrid as TK_WIDGET ptr, byval nHeight as integer )
function tkDataGrid_GetHeaderHeightPx( byval hGrid as TK_WIDGET ptr ) as integer
sub tkDataGrid_ShowHeader( byval hGrid as TK_WIDGET ptr, byval bShow as boolean )
function tkDataGrid_IsHeaderVisible( byval hGrid as TK_WIDGET ptr ) as boolean
sub tkDataGrid_SetGridLines( byval hGrid as TK_WIDGET ptr, byval nLines as long )
function tkDataGrid_GetGridLines( byval hGrid as TK_WIDGET ptr ) as long
sub tkDataGrid_SetAlternateRows( byval hGrid as TK_WIDGET ptr, byval bAlt as boolean )
function tkDataGrid_GetAlternateRows( byval hGrid as TK_WIDGET ptr ) as boolean
sub tkDataGrid_SetScrollBarWidth( byval hGrid as TK_WIDGET ptr, byval nWidth as integer )
function tkDataGrid_GetBorderWidth( byval hGrid as TK_WIDGET ptr ) as integer
sub tkDataGrid_SetBorderWidth( byval hGrid as TK_WIDGET ptr, byval nWidth as integer )
function tkDataGrid_GetFont( byval hGrid as TK_WIDGET ptr ) as TTF_Font ptr
sub tkDataGrid_SetFont( byval hGrid as TK_WIDGET ptr, byval f as TTF_Font ptr )
sub tkDataGrid_SetHeaderFont( byval hGrid as TK_WIDGET ptr, byval f as TTF_Font ptr )
sub tkDataGrid_ApplyFonts( byval hGrid as TK_WIDGET ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
sub tkDataGrid_GetColors( byval hGrid as TK_WIDGET ptr, byval pColors as TKDATAGRID_COLORS ptr )
sub tkDataGrid_SetColors( byval hGrid as TK_WIDGET ptr, byval pColors as TKDATAGRID_COLORS ptr )
function tkDataGrid_GetBackColor( byval hGrid as TK_WIDGET ptr ) as ulong
sub tkDataGrid_SetBackColor( byval hGrid as TK_WIDGET ptr, byval clr as ulong )
function tkDataGrid_ThemeColors( byref t as TKTHEME_COLORS ) as TKDATAGRID_COLORS
sub tkDataGrid_ApplyTheme( byval hGrid as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkDataGrid_UnpinColors( byval hGrid as TK_WIDGET ptr )
sub tkDataGrid_PaintCellDefault( byval pi as TKDATAGRID_CELLPAINTINFO ptr )

' ---- scrolling and geometry
function tkDataGrid_GetTopRow( byval hGrid as TK_WIDGET ptr ) as integer
function tkDataGrid_SetTopRow( byval hGrid as TK_WIDGET ptr, byval row as integer ) as integer
function tkDataGrid_GetScrollX( byval hGrid as TK_WIDGET ptr ) as integer
function tkDataGrid_GetScrollY( byval hGrid as TK_WIDGET ptr ) as integer
function tkDataGrid_SetScrollX( byval hGrid as TK_WIDGET ptr, byval x as integer ) as integer
function tkDataGrid_SetScrollY( byval hGrid as TK_WIDGET ptr, byval y as integer ) as integer
function tkDataGrid_GetVisibleRows( byval hGrid as TK_WIDGET ptr, byref first as integer, byref last as integer ) as integer
sub tkDataGrid_EnsureVisible( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer = -1 )
function tkDataGrid_GetCellRect( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer, byref rc as TKRECT ) as boolean
function tkDataGrid_GetColumnRect( byval hGrid as TK_WIDGET ptr, byval col as integer, byref rc as TKRECT ) as boolean
function tkDataGrid_GetContentWidth( byval hGrid as TK_WIDGET ptr ) as integer
function tkDataGrid_GetFrozenWidthPx( byval hGrid as TK_WIDGET ptr ) as integer
function tkDataGrid_GetRowHeaderWidthPx( byval hGrid as TK_WIDGET ptr ) as integer
function tkDataGrid_HitTest( byval hGrid as TK_WIDGET ptr, byval x as integer, byval y as integer, byref ht as TKDG_HITTEST ) as long
function tkDataGrid_GetHotRow( byval hGrid as TK_WIDGET ptr ) as integer
function tkDataGrid_AutoSizeColumn( byval hGrid as TK_WIDGET ptr, byval col as integer, byval nSampleRows as integer = 200 ) as integer

' ---- selection, the current cell, behaviour
sub tkDataGrid_SetSelectionUnit( byval hGrid as TK_WIDGET ptr, byval nUnit as long )
function tkDataGrid_GetSelectionUnit( byval hGrid as TK_WIDGET ptr ) as long
sub tkDataGrid_SetMultiSelect( byval hGrid as TK_WIDGET ptr, byval bMulti as boolean )
function tkDataGrid_GetMultiSelect( byval hGrid as TK_WIDGET ptr ) as boolean
function tkDataGrid_GetCurrentCell( byval hGrid as TK_WIDGET ptr, byref row as integer, byref col as integer ) as boolean
function tkDataGrid_SetCurrentCell( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer, byval bSelect as boolean = true ) as boolean
sub tkDataGrid_ClearSelection( byval hGrid as TK_WIDGET ptr )
sub tkDataGrid_SelectAll( byval hGrid as TK_WIDGET ptr )
sub tkDataGrid_SelectRows( byval hGrid as TK_WIDGET ptr, byval row1 as integer, byval row2 as integer, byval bAdd as boolean = false )
sub tkDataGrid_SelectRange( byval hGrid as TK_WIDGET ptr, byval row1 as integer, byval col1 as integer, byval row2 as integer, byval col2 as integer, byval bAdd as boolean = false )
function tkDataGrid_IsCellSelected( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer ) as boolean
function tkDataGrid_IsRowSelected( byval hGrid as TK_WIDGET ptr, byval row as integer ) as boolean
function tkDataGrid_IsAllSelected( byval hGrid as TK_WIDGET ptr ) as boolean
function tkDataGrid_GetSelectedRowCount( byval hGrid as TK_WIDGET ptr ) as integer
function tkDataGrid_GetSelectedRows( byval hGrid as TK_WIDGET ptr, rows() as integer ) as integer
function tkDataGrid_GetSelectedRanges( byval hGrid as TK_WIDGET ptr, ranges() as TKDG_RANGE ) as integer
function tkDataGrid_GetSelectionText( byval hGrid as TK_WIDGET ptr, byval bHeaders as boolean = false ) as ustring
function tkDataGrid_CopySelection( byval hGrid as TK_WIDGET ptr, byval bHeaders as boolean = false ) as boolean
sub tkDataGrid_SetTabWraps( byval hGrid as TK_WIDGET ptr, byval b as boolean )
function tkDataGrid_GetTabWraps( byval hGrid as TK_WIDGET ptr ) as boolean
sub tkDataGrid_SetColumnHeaderSelects( byval hGrid as TK_WIDGET ptr, byval b as boolean )
function tkDataGrid_GetColumnHeaderSelects( byval hGrid as TK_WIDGET ptr ) as boolean
sub tkDataGrid_SetAllowColumnResize( byval hGrid as TK_WIDGET ptr, byval b as boolean )
function tkDataGrid_GetAllowColumnResize( byval hGrid as TK_WIDGET ptr ) as boolean
sub tkDataGrid_SetAllowColumnReorder( byval hGrid as TK_WIDGET ptr, byval b as boolean )
function tkDataGrid_GetAllowColumnReorder( byval hGrid as TK_WIDGET ptr ) as boolean
sub tkDataGrid_SetFrozenColumns( byval hGrid as TK_WIDGET ptr, byval n as integer )
function tkDataGrid_GetFrozenColumns( byval hGrid as TK_WIDGET ptr ) as integer
sub tkDataGrid_ShowRowHeaders( byval hGrid as TK_WIDGET ptr, byval bShow as boolean )
function tkDataGrid_AreRowHeadersVisible( byval hGrid as TK_WIDGET ptr ) as boolean
sub tkDataGrid_SetRowHeaderWidth( byval hGrid as TK_WIDGET ptr, byval nWidth as integer )
function tkDataGrid_GetRowHeaderWidth( byval hGrid as TK_WIDGET ptr ) as integer
function tkDataGrid_GetTooltipHandle( byval hGrid as TK_WIDGET ptr ) as TK_TIP ptr
sub tkDataGrid_SetHoverTime( byval hGrid as TK_WIDGET ptr, byval ms as long )
function tkDataGrid_GetTipText( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer ) as ustring

' ---- editing
sub tkDataGrid_SetEditMode( byval hGrid as TK_WIDGET ptr, byval nMode as long )
function tkDataGrid_GetEditMode( byval hGrid as TK_WIDGET ptr ) as long
sub tkDataGrid_SetReadOnly( byval hGrid as TK_WIDGET ptr, byval b as boolean )
function tkDataGrid_GetReadOnly( byval hGrid as TK_WIDGET ptr ) as boolean
sub tkDataGrid_SetAllowAddRows( byval hGrid as TK_WIDGET ptr, byval b as boolean )
function tkDataGrid_GetAllowAddRows( byval hGrid as TK_WIDGET ptr ) as boolean
sub tkDataGrid_SetAllowDeleteRows( byval hGrid as TK_WIDGET ptr, byval b as boolean )
function tkDataGrid_GetAllowDeleteRows( byval hGrid as TK_WIDGET ptr ) as boolean
sub tkDataGrid_SetEditSelectAll( byval hGrid as TK_WIDGET ptr, byval b as boolean )
function tkDataGrid_IsNewRow( byval hGrid as TK_WIDGET ptr, byval row as integer ) as boolean
sub tkDataGrid_SetColumnItems( byval hGrid as TK_WIDGET ptr, byval col as integer, items() as ustring )
function tkDataGrid_GetColumnItemCount( byval hGrid as TK_WIDGET ptr, byval col as integer ) as integer
function tkDataGrid_BeginEdit( byval hGrid as TK_WIDGET ptr, byval row as integer, byval col as integer, byval bSelectAll as boolean = true ) as boolean
function tkDataGrid_EndEdit( byval hGrid as TK_WIDGET ptr, byval bCommit as boolean = true ) as boolean
function tkDataGrid_IsEditing( byval hGrid as TK_WIDGET ptr ) as boolean
function tkDataGrid_GetEditRow( byval hGrid as TK_WIDGET ptr ) as integer
function tkDataGrid_GetEditCol( byval hGrid as TK_WIDGET ptr ) as integer
function tkDataGrid_GetEditor( byval hGrid as TK_WIDGET ptr ) as TK_WIDGET ptr
function tkDataGrid_GetEditError( byval hGrid as TK_WIDGET ptr ) as ustring
function tkDataGrid_GetDirtyRow( byval hGrid as TK_WIDGET ptr ) as integer
function tkDataGrid_CommitRow( byval hGrid as TK_WIDGET ptr ) as boolean
sub tkDataGrid_CancelRowEdit( byval hGrid as TK_WIDGET ptr )
function tkDataGrid_Paste( byval hGrid as TK_WIDGET ptr ) as integer
function tkDataGrid_PasteText( byval hGrid as TK_WIDGET ptr, byval text as ustring ) as integer

' ---- feeds, the block cache, sort and filter
sub tkDataGrid_SetVirtual( byval hGrid as TK_WIDGET ptr, byval bVirtual as boolean )
function tkDataGrid_IsVirtual( byval hGrid as TK_WIDGET ptr ) as boolean
sub tkDataGrid_SetSource( byval hGrid as TK_WIDGET ptr, byval src as TKDATAGRID_SOURCE ptr )
function tkDataGrid_HasSource( byval hGrid as TK_WIDGET ptr ) as boolean
function tkDataGrid_GetSourceContext( byval hGrid as TK_WIDGET ptr ) as any ptr
sub tkDataGrid_InvalidateCells( byval hGrid as TK_WIDGET ptr, byval row1 as integer = -1, byval col1 as integer = -1, byval row2 as integer = -1, byval col2 as integer = -1 )
sub tkDataGrid_NotifyRowsInserted( byval hGrid as TK_WIDGET ptr, byval row as integer, byval n as integer )
sub tkDataGrid_NotifyRowsRemoved( byval hGrid as TK_WIDGET ptr, byval row as integer, byval n as integer )
sub tkDataGrid_Reset( byval hGrid as TK_WIDGET ptr )
sub tkDataGrid_SetBlockCache( byval hGrid as TK_WIDGET ptr, byval rows as integer = 100, byval blocks as integer = 50 )
function tkDataGrid_GetBlockCacheRows( byval hGrid as TK_WIDGET ptr ) as integer
function tkDataGrid_IsRowLoaded( byval hGrid as TK_WIDGET ptr, byval row as integer ) as boolean
function tkDataGrid_GetBlockRequestCount( byval hGrid as TK_WIDGET ptr ) as integer
function tkDataGrid_SupplyRows( byval hGrid as TK_WIDGET ptr, byval firstRow as integer, byval count as integer, values() as TKDG_VALUE ) as boolean
sub tkDataGrid_SetSortMode( byval hGrid as TK_WIDGET ptr, byval nMode as long )
function tkDataGrid_GetSortMode( byval hGrid as TK_WIDGET ptr ) as long
sub tkDataGrid_SetSortKeys( byval hGrid as TK_WIDGET ptr, keys() as TKDG_SORTKEY )
function tkDataGrid_GetSortKeys( byval hGrid as TK_WIDGET ptr, keys() as TKDG_SORTKEY ) as integer
sub tkDataGrid_ClearSort( byval hGrid as TK_WIDGET ptr )
sub tkDataGrid_Sort( byval hGrid as TK_WIDGET ptr )
sub tkDataGrid_ApplyFilter( byval hGrid as TK_WIDGET ptr )
sub tkDataGrid_SetQuickFilter( byval hGrid as TK_WIDGET ptr, byval text as ustring )
function tkDataGrid_GetQuickFilter( byval hGrid as TK_WIDGET ptr ) as ustring
function tkDataGrid_GetViewCount( byval hGrid as TK_WIDGET ptr ) as integer
function tkDataGrid_ViewToModel( byval hGrid as TK_WIDGET ptr, byval v as integer ) as integer
function tkDataGrid_ModelToView( byval hGrid as TK_WIDGET ptr, byval row as integer ) as integer

' ---- callbacks
sub tkDataGrid_SetCellPaintCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_CellPaintFunc )
sub tkDataGrid_SetCellFormattingCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_CellFormattingSub )
sub tkDataGrid_SetHeaderPaintCallback( byval hGrid as TK_WIDGET ptr, byval cb as HDR_PaintCallbackSub )
sub tkDataGrid_SetMessageCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_MessageFunc )
sub tkDataGrid_SetCurrentCellChangedCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_CellSub )
sub tkDataGrid_SetSelChangeCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_GridSub )
sub tkDataGrid_SetCellClickCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_CellSub )
sub tkDataGrid_SetCellActivateCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_CellSub )
sub tkDataGrid_SetColumnClickCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_ColumnSub )
sub tkDataGrid_SetColumnResizeCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_ColumnResizeSub )
sub tkDataGrid_SetColumnReorderedCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_ColumnReorderedSub )
sub tkDataGrid_SetTooltipCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_TooltipFunc )
sub tkDataGrid_SetCellBeginEditCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_CellBeginEditFunc )
sub tkDataGrid_SetCellParseCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_CellParseFunc )
sub tkDataGrid_SetCellEndEditCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_CellEndEditSub )
sub tkDataGrid_SetCellValueChangedCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_CellSub )
sub tkDataGrid_SetButtonClickCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_CellSub )
sub tkDataGrid_SetRowValidatingCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_RowFunc )
sub tkDataGrid_SetRowCommittedCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_RowSub )
sub tkDataGrid_SetCancelRowEditCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_RowSub )
sub tkDataGrid_SetRowAddedCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_RowSub )
sub tkDataGrid_SetRowsDeletingCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_RowsDeletingFunc )
sub tkDataGrid_SetDataRequestCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_RowsSub )
sub tkDataGrid_SetCellValueNeededCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_CellValueNeededSub )
sub tkDataGrid_SetCellValuePushedCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_CellValuePushedFunc )
sub tkDataGrid_SetSortChangedCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_GridSub )
sub tkDataGrid_SetFilterCallback( byval hGrid as TK_WIDGET ptr, byval cb as DG_FilterFunc )

' ---- tkDataGridSqlite
function tkDataGridSqlite_Open( byval hGrid as TK_WIDGET ptr, byval db as sqlite3 ptr, byref query as const ustring, byval bColumns as boolean = true, byval blockRows as integer = 100, byval maxBlocks as integer = 50 ) as TKDGSQL ptr
function tkDataGridSqlite_SetWritable( byval q as TKDGSQL ptr, byref table as const ustring, byref pkColumn as const ustring ) as boolean
sub tkDataGridSqlite_Refresh( byval q as TKDGSQL ptr )
function tkDataGridSqlite_GetFetchCount( byval q as TKDGSQL ptr ) as integer
function tkDataGridSqlite_GetOrderBy( byval q as TKDGSQL ptr ) as ustring
function tkDataGridSqlite_LastError( byval q as TKDGSQL ptr ) as ustring
sub tkDataGridSqlite_Close( byval q as TKDGSQL ptr )
```

### See also

- [tkControls](Category-tkControls)
- [tkListTree](tkListTree), the list and tree for rows that are mostly read
- [tkColumnHeader](tkColumnHeader), whose painter draws the grid's header
- [tkTextBox](tkTextBox), [tkComboBox](tkComboBox), [tkDatePicker](tkDatePicker), the editors
- [tkApp](tkApp) (`tkApp_RunOnUI`, for a worker answering the block cache)
- [Form Designer](Form-Designer), data binding
