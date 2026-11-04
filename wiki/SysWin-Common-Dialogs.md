[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › **Common dialogs**

# Common dialogs

Shows the open, save, folder and colour dialogs, and opens Control Panel applets.

Each function shows a dialog and returns when the user closes it, with what the user chose, or
an empty result when they cancelled. Pass your window as the owner so that the dialog sits over
it and the window is disabled until the dialog closes.

The file dialogs take their filter as one string of `|`-separated pairs, a description and a
pattern: `"Text files (*.txt)|*.txt|All files (*.*)|*.*"`. Several patterns for one entry are
separated by semicolons, `*.bmp;*.png`.

The file dialogs here are the classic ones. For the newer Vista-style dialogs, with
customisation and events, see [File dialogs](SysWin-Gui-File-Dialogs).

## Importing

```freebasic
#import "sys/win"
using win
```

## Example

A window with two buttons: one opens text files and shows the path chosen in the caption, the
other picks a colour for the window's background:

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

dim shared as HBRUSH hBack

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "DialogDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Common dialogs", @WndProc )
    SetWindowClientSizeForDpi( hWin, 360, 120 )
    CenterWindow( hWin )
    pWindow.AddControl( "Button", hWin, 100, "&Open...", 40, 45, 120, 30 )
    pWindow.AddControl( "Button", hWin, 101, "&Colour...", 200, 45, 120, 30 )
    dim result as long = pWindow.DoEvents( SW_NORMAL )
    if hBack then DeleteObject( hBack )
    return result
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_COMMAND
            if CBCTLMSG( wParam, lParam ) = BN_CLICKED then
                select case CBCTL( wParam, lParam )
                    case 100
                        dim flags as DWORD = OFN_FILEMUSTEXIST or OFN_HIDEREADONLY
                        dim file as ustring = OpenFileDialog( hwnd, "Open a text file", "", "", _
                            "Text files (*.txt)|*.txt|All files (*.*)|*.*", "txt", @flags )
                        if len( file ) then SetWindowText( hwnd, file )
                    case 101
                        dim clr as long = ChooseColorDialog( hwnd, BGR( 255, 255, 255 ) )
                        if clr <> -1 then
                            if hBack then DeleteObject( hBack )
                            hBack = CreateSolidBrush( clr )
                            InvalidateRect( hwnd, NULL, true )
                        end if
                end select
            end if
            return 0
        case WM_ERASEBKGND
            if hBack then
                dim rc as RECT
                GetClientRect( hwnd, @rc )
                FillRect( cast( HDC, wParam ), @rc, hBack )
                return 1
            end if
        case WM_DESTROY
            PostQuitMessage( 0 )
            return 0
    end select
    return DefWindowProcW( hwnd, uMsg, wParam, lParam )
end function

end main()
```

## Functions

| Function | Does |
| --- | --- |
| [BrowseForFolder](#browseforfolder) | Lets the user pick a folder. |
| [OpenFileDialog](#openfiledialog) | Lets the user pick one or more files to open. |
| [SaveFileDialog](#savefiledialog) | Lets the user pick a file name to save to. |
| [ChooseColorDialog](#choosecolordialog) | Lets the user pick a colour. |
| [ControlRunDLL](#controlrundll) | Opens Control Panel or one of its applets. |
| [LaunchConnectionDialog](#launchconnectiondialog) | Opens Internet Properties at the Connections tab. |
| [LaunchInternetControlPanel](#launchinternetcontrolpanel) | Opens Internet Properties at the General tab. |
| [LaunchPrivacyDialog](#launchprivacydialog) | Opens Internet Properties at the Privacy tab. |
| [LaunchSecurityDialog](#launchsecuritydialog) | Opens Internet Properties at the Security tab. |

## Reference

### BrowseForFolder

```freebasic
function BrowseForFolder( byval hWin as HWND, byval pwszTitle as wstring ptr = NULL, byval pwszStartFolder as wstring ptr = NULL, byval nFlags as long = 0 ) as ustring
```

Shows the shell's folder picker, a tree of the user's drives and folders, and returns the
folder the user chose. COM is initialised on the calling thread for the dialog.

The **OK** button is enabled only for a folder on a drive letter (`C:\…`, or a mapped network
drive); network paths written `\\server\share`, virtual folders such as Control Panel, and
folders with the system attribute (other than the root of a drive) cannot be chosen.

| Parameter | Meaning |
| --- | --- |
| `hWin` | The owner window, or `NULL`. |
| `pwszTitle` | Text shown above the tree, such as `"Choose the output folder"`. |
| `pwszStartFolder` | The folder selected when the dialog opens. |
| `nFlags` | `BIF_*` flags; 0 gives `BIF_RETURNONLYFSDIRS or BIF_DONTGOBELOWDOMAIN or BIF_USENEWUI or BIF_RETURNFSANCESTORS`, the resizable dialog with a **Make New Folder** button. |

**Returns** the full path of the folder, or `""` when the user cancelled.

**Example**

```freebasic
dim folder as ustring = BrowseForFolder( hwnd, "Choose the output folder", "C:\" )
if len( folder ) then print "saving to "; folder
```

Microsoft Learn: [SHBrowseForFolderW](https://learn.microsoft.com/en-us/windows/win32/api/shlobj_core/nf-shlobj_core-shbrowseforfolderw)

### OpenFileDialog

```freebasic
function OpenFileDialog( byval hwndOwner as HWND, byref wszTitle as wstring, byref wszFile as wstring, byref wszInitialDir as wstring, byref wszFilter as wstring, byref wszDefExt as wstring, byval pdwFlags as DWORD ptr = NULL, byval pdwBufLen as DWORD ptr = NULL ) as ustring
```

Shows the Open dialog and returns the file or files the user chose. `OFN_EXPLORER` is always
added to the flags.

| Parameter | Meaning |
| --- | --- |
| `hwndOwner` | The owner window, or `NULL`. |
| `wszTitle` | The caption; `""` gives **Open**. |
| `wszFile` | The name shown in the **File name** box at first, or `""`. |
| `wszInitialDir` | The folder shown at first; `""` uses the current folder. |
| `wszFilter` | The filter pairs, `"Text files (*.txt)\|*.txt\|All files (*.*)\|*.*"`. The first pair is selected. |
| `wszDefExt` | An extension, without the period, added when the user types a name without one; `""` for none. |
| `pdwFlags` | Optional, in and out: `OFN_*` flags such as `OFN_FILEMUSTEXIST`, `OFN_HIDEREADONLY`, `OFN_ALLOWMULTISELECT`. On return it holds the dialog's flags, so `OFN_READONLY` says whether **Open as read-only** was ticked. |
| `pdwBufLen` | Optional, in and out: the size in characters of the buffer for the names. The default is 260, or 32768 with `OFN_ALLOWMULTISELECT`. When the names do not fit, the call returns `""` and this receives the size needed. |

With one file chosen, the result is its full path. With `OFN_ALLOWMULTISELECT` and several files,
it is a comma-separated list: the folder first, then each file name, `C:\Docs,a.txt,b.txt`; split
it with [ParseStr](SysWin-Strings#parsestr) (a comma inside a file name splits it too).

**Returns** the path or the list, or `""` when the user cancelled or the buffer was too small.

**Example**

```freebasic
dim flags as DWORD = OFN_FILEMUSTEXIST or OFN_HIDEREADONLY or OFN_ALLOWMULTISELECT
dim picked as ustring = OpenFileDialog( hwnd, "", "", "", "Images|*.bmp;*.png", "png", @flags )
if ParseCount( picked ) > 1 then print ParseCount( picked ) - 1; " files in "; ParseStr( picked, 1 )
```

Microsoft Learn: [GetOpenFileNameW](https://learn.microsoft.com/en-us/windows/win32/api/commdlg/nf-commdlg-getopenfilenamew)

### SaveFileDialog

```freebasic
function SaveFileDialog( byval hwndOwner as HWND, byref wszTitle as wstring, byref wszFileName as wstring, byref wszInitialDir as wstring, byref wszFilter as wstring, byref wszDefExt as wstring, byval pdwFlags as DWORD ptr = NULL ) as ustring
```

Shows the Save As dialog and returns the path the user chose. The parameters are those of
[OpenFileDialog](#openfiledialog) without the buffer size; the path can be up to 259 characters.
Add `OFN_OVERWRITEPROMPT` to `*pdwFlags` to have the dialog ask before an existing file is
replaced.

**Returns** the path, or `""` when the user cancelled.

**Example**

```freebasic
dim flags as DWORD = OFN_OVERWRITEPROMPT or OFN_HIDEREADONLY
dim target as ustring = SaveFileDialog( hwnd, "Export", "report.csv", "", "CSV files|*.csv", "csv", @flags )
if len( target ) then print "exporting to "; target
```

Microsoft Learn: [GetSaveFileNameW](https://learn.microsoft.com/en-us/windows/win32/api/commdlg/nf-commdlg-getsavefilenamew)

### ChooseColorDialog

```freebasic
function ChooseColorDialog( byval hParent as HWND, byval rgbDefaultColor as COLORREF = 0, byval lpCustColors as COLORREF ptr = NULL ) as long
```

Shows the colour dialog, opened in full with the custom colour mixer, starting at
`rgbDefaultColor`.

The dialog has sixteen **Custom colors** boxes. Pass an array of 16 `COLORREF` values to fill them
and to get back any the user changed; keep the array between calls so that they persist.
Without one, the boxes show a fixed ramp from blue to green and changes to them are lost.

| Parameter | Meaning |
| --- | --- |
| `hParent` | The owner window, or `NULL`. |
| `rgbDefaultColor` | The colour selected at first, a `COLORREF`; black by default. |
| `lpCustColors` | Optional: the first of 16 `COLORREF` values for the custom colour boxes. |

**Returns** the colour chosen, as a `COLORREF`, or -1 when the user cancelled.

**Example**

```freebasic
static custom( 15 ) as COLORREF
dim clr as long = ChooseColorDialog( hwnd, BGR( 0, 120, 215 ), @custom( 0 ) )
if clr <> -1 then print "red"; GetRValue( clr ); " green"; GetGValue( clr ); " blue"; GetBValue( clr )
```

Microsoft Learn: [CHOOSECOLORW](https://learn.microsoft.com/en-us/windows/win32/api/commdlg/ns-commdlg-choosecolorw)

### ControlRunDLL

```freebasic
function ControlRunDLL( byval hWin as HWND, byval hInst as HINSTANCE, byval cmd as wstring ptr, byval nCmdShow as long ) as boolean
```

Opens Control Panel, or one of its applets, through the shell's `Control_RunDLLW` entry point.
`cmd` names the applet file: `""` opens Control Panel itself, `"appwiz.cpl"` **Programs and
Features**, `"desk.cpl"` the display settings, `"timedate.cpl"` **Date and Time**. Some applets
also want an owner window and an instance handle.

The entry point returns no value, so the boolean result says nothing about whether the applet
opened; it is `false` only when the entry point cannot be found.

| Parameter | Meaning |
| --- | --- |
| `hWin` | The owner window, or `NULL`. |
| `hInst` | The program's instance handle, or `NULL`. |
| `cmd` | The `.cpl` file, with any arguments it takes. |
| `nCmdShow` | How to show it, normally `SW_SHOWNORMAL`. |

**Returns** a value that carries no meaning on success; `false` when the shell entry point is
missing.

**Example**

```freebasic
ControlRunDLL( hwnd, GetModuleHandleW( NULL ), "appwiz.cpl", SW_SHOWNORMAL )
```

### LaunchConnectionDialog

```freebasic
function LaunchConnectionDialog( byval hParent as HWND ) as long
```

Opens the **Internet Properties** dialog at its **Connections** tab, where proxy and dial-up
settings live, from `inetcpl.cpl`.

**Returns** what the `inetcpl.cpl` entry point returns, or 0 when it cannot be loaded.

**Example**

```freebasic
LaunchConnectionDialog( hwnd )
```

### LaunchInternetControlPanel

```freebasic
function LaunchInternetControlPanel( byval hParent as HWND ) as long
```

Opens the **Internet Properties** dialog at its **General** tab, from `inetcpl.cpl`.

**Returns** what the `inetcpl.cpl` entry point returns, or 0 when it cannot be loaded.

**Example**

```freebasic
LaunchInternetControlPanel( hwnd )
```

### LaunchPrivacyDialog

```freebasic
function LaunchPrivacyDialog( byval hParent as HWND ) as long
```

Opens the **Internet Properties** dialog at its **Privacy** tab, from `inetcpl.cpl`.

**Returns** what the `inetcpl.cpl` entry point returns, or 0 when it cannot be loaded.

**Example**

```freebasic
LaunchPrivacyDialog( hwnd )
```

### LaunchSecurityDialog

```freebasic
function LaunchSecurityDialog( byval hParent as HWND ) as long
```

Opens the **Internet Properties** dialog at its **Security** tab, with its zones, from
`inetcpl.cpl`.

**Returns** what the `inetcpl.cpl` entry point returns, or 0 when it cannot be loaded.

**Example**

```freebasic
LaunchSecurityDialog( hwnd )
```

## See also

- [Category: sys/win](Category-Sys-Win)
- [File dialogs](SysWin-Gui-File-Dialogs) for the newer open and save dialogs
- [Strings](SysWin-Strings) for `ParseCount` and `ParseStr`
- [Colours](SysWin-Colors) for `COLORREF` values
- [Internet](SysWin-Internet) for connection state
