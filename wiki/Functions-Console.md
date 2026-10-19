[Home](Home) › [Function Finder](Function-Finder) › **Console and terminal**

# Console and terminal

The functions to print, read the keyboard, colour text, build full-screen text UIs, grouped by what you want to do. The **From** column says what a program needs before it can call one:

- **built-in**: nothing; it is always available.
- `std/tui`: `#import "std/tui"`, then `using tui` to call it by its bare name.

Jump to: [Print text to the console](#print-text-to-the-console) · [Ask the user to type a line or values](#ask-the-user-to-type-a-line-or-values) · [Read single keys](#read-single-keys) · [Clear, position and colour console text](#clear-position-and-colour-console-text) · [Write a full-screen TUI app](#write-a-full-screen-tui-app) · [Handle keys and the mouse in a TUI](#handle-keys-and-the-mouse-in-a-tui) · [Redraw, quit and run timers](#redraw-quit-and-run-timers) · [Show boxes, text, tabs and progress](#show-boxes-text-tabs-and-progress) · [Show lists, tables and trees](#show-lists-tables-and-trees) · [Build forms and move focus between fields](#build-forms-and-move-focus-between-fields) · [Show pop-ups, dialogs, menus and status bars](#show-pop-ups-dialogs-menus-and-status-bars) · [Draw graphs, charts and braille dots](#draw-graphs-charts-and-braille-dots) · [Split the screen into panels](#split-the-screen-into-panels) · [Rectangles, sizes and margins](#rectangles-sizes-and-margins) · [Style text: attributes and themes](#style-text-attributes-and-themes) · [Pick colours](#pick-colours) · [Measure, cut and wrap text by columns](#measure-cut-and-wrap-text-by-columns) · [Draw on the frame and write your own widgets](#draw-on-the-frame-and-write-your-own-widgets) · [Render frames and test without a terminal](#render-frames-and-test-without-a-terminal) · [Drive the terminal and parse input yourself](#drive-the-terminal-and-parse-input-yourself)

## Print text to the console

| Function | What it does | From |
|---|---|---|
| [Print](Print) | Writes values to the console, then a new line unless it ends with a comma or semicolon. | built-in |
| [Print Using](Print-Using) | Writes values formatted by a template such as "##.##" or "&". | built-in |
| [Write](Write) | Writes values separated by commas, with strings in double quotes. | built-in |
| [Spc](Spc) | Skips a number of columns inside a Print, leaving those cells unchanged. | built-in |
| [Tab](Tab) | Moves to a column inside a Print, on the next line if already past it. | built-in |

## Ask the user to type a line or values

| Function | What it does | From |
|---|---|---|
| [Input](procedures-Input) | Reads values the user types, up to Enter, after an optional prompt. | built-in |
| [Line Input](procedures-Line-Input) | Reads a whole typed line into a string, commas included, after an optional prompt. | built-in |

## Read single keys

| Function | What it does | From |
|---|---|---|
| [Inkey](Inkey) | Returns the next key waiting, or an empty string at once if there is none. | built-in |
| [GetKey](Getkey) | Waits for a key and returns its code; the key is not shown on screen. | built-in |
| [Input](Input-2) (function) | Waits for a number of characters from the keyboard or a file and returns them. | built-in |
| [WInput](Winput) | Reads a number of wide characters from a file or device and returns them. | built-in |

## Clear, position and colour console text

| Function | What it does | From |
|---|---|---|
| [Cls](Cls) | Clears the screen, or only the text or graphics viewport. | built-in |
| [Locate](Locate) | Moves the text cursor to a row and column, and can show or hide it. | built-in |
| [CsrLin](Csrlin) | Returns the row the cursor is on, counting from 1 at the top. | built-in |
| [Pos](Pos) | Returns the column the cursor is in, counting from 1 at the left. | built-in |
| [Color](Color) | Sets the colours for text printed from now on, and returns the previous ones. | built-in |
| [Width](Width) | Sets or returns the number of columns and rows of the console. | built-in |
| [View Print](View-Print) | Limits printing and scrolling to a range of rows, or to the whole screen again. | built-in |
| [Screen](Screen-Console) | Returns the character, or its colour, at a row and column of the console. | built-in |

## Write a full-screen TUI app

| Function | What it does | From |
|---|---|---|
| [TuiApp](Modern-Tui-TuiApp) | Holds your app: you write Init to set up, Update to react and View to draw. | `std/tui` |
| [TuiApp.Init](Modern-Tui-TuiApp-Init) | Sets up your app and returns its first command, such as a tick to start animating. | `std/tui` |
| [TuiApp.Update](Modern-Tui-TuiApp-Update) | Reacts to one event and returns what the loop should do next; it never draws. | `std/tui` |
| [TuiApp.View](Modern-Tui-TuiApp-View) | Draws the whole screen from your app's state, changing nothing. | `std/tui` |
| [TuiApp.Shutdown](Modern-Tui-TuiApp-Shutdown) | Runs once as the loop ends, while the terminal is still taken. | `std/tui` |
| [TuiRun](Modern-Tui-TuiRun) | Runs your app full-screen and restores the terminal; returns the exit code or an error. | `std/tui` |
| [TuiRunOptions](Modern-Tui-TuiRunOptions) | Holds loop settings: frames per second and whether Ctrl+C quits. | `std/tui` |
| [TuiRunOptionsDefault](Modern-Tui-TuiRunOptionsDefault) | Returns the default loop settings: 60 frames per second, quit on Ctrl+C. | `std/tui` |
| [TuiTermOptions](Modern-Tui-TuiTermOptions) | Holds which terminal features to take: alternate screen, raw keys, mouse and more. | `std/tui` |
| [TuiTermOptionsDefault](Modern-Tui-TuiTermOptionsDefault) | Returns the usual terminal settings, with the mouse and focus events left off. | `std/tui` |

## Handle keys and the mouse in a TUI

| Function | What it does | From |
|---|---|---|
| [TuiEvent](Modern-Tui-TuiEvent) | Holds one event: a key, mouse action, resize, paste, focus change or tick. | `std/tui` |
| [TuiKey](Modern-Tui-TuiKey) | Holds a key press: a character or a named key, plus Shift, Ctrl and Alt. | `std/tui` |
| [TuiKey.IsChar](Modern-Tui-TuiKey-IsChar) | Returns true if the key is a typed character rather than a named key. | `std/tui` |
| [TuiKey.HasMod](Modern-Tui-TuiKey-HasMod) | Returns true if the given modifier, Shift, Alt or Ctrl, was held. | `std/tui` |
| [TuiKeyName](Modern-Tui-TuiKeyName) | Returns a readable name for a key, such as "Ctrl+Shift+F5". | `std/tui` |
| [TuiMouse](Modern-Tui-TuiMouse) | Holds a mouse event: press, release, move or wheel, the button, and the cell. | `std/tui` |

## Redraw, quit and run timers

| Function | What it does | From |
|---|---|---|
| [TuiCmd](Modern-Tui-TuiCmd) | Holds a command for the loop: what to do, plus a delay or an exit code. | `std/tui` |
| [TuiNone](Modern-Tui-TuiNone) | Returns a command that does nothing, for events your app ignores. | `std/tui` |
| [TuiRedraw](Modern-Tui-TuiRedraw) | Returns a command that draws the next frame; only the cells that changed are sent. | `std/tui` |
| [TuiQuit](Modern-Tui-TuiQuit) | Returns a command that ends the loop, so TuiRun returns the given exit code. | `std/tui` |
| [TuiTick](Modern-Tui-TuiTick) | Returns a command that sends one tick event after a delay; return another to repeat. | `std/tui` |
| [TuiInvalidate](Modern-Tui-TuiInvalidate) | Returns a command that repaints the whole screen instead of only the changes. | `std/tui` |
| [TuiSuspend](Modern-Tui-TuiSuspend) | Returns a command that leaves the terminal, suspends the program, then comes back. | `std/tui` |
| [TuiClockMs](Modern-Tui-TuiClockMs) | Returns a clock in milliseconds that never goes backwards, the one the loop uses. | `std/tui` |

## Show boxes, text, tabs and progress

| Function | What it does | From |
|---|---|---|
| [TuiBlock](Modern-Tui-TuiBlock) | Draws a border with titles and an optional fill; Inner gives the space inside. | `std/tui` |
| [TuiBlock.AddTitle](Modern-Tui-TuiBlock-AddTitle) | Adds a title to one side of the border, aligned left, centre or right. | `std/tui` |
| [TuiBlock.Inner](Modern-Tui-TuiBlock-Inner) | Returns the space inside the border, which is empty for a very small block. | `std/tui` |
| [TuiTitle](Modern-Tui-TuiTitle) | Holds one title on a block's border: its text, style and alignment. | `std/tui` |
| [TuiTitleOf](Modern-Tui-TuiTitleOf) | Returns a title value; the side argument comes before the alignment. | `std/tui` |
| [TuiBorderGlyphs](Modern-Tui-TuiBorderGlyphs) | Returns the characters for a border kind, such as plain ASCII for older consoles. | `std/tui` |
| [TuiBorderSet](Modern-Tui-TuiBorderSet) | Holds the six characters a border is drawn from: two lines and four corners. | `std/tui` |
| [TuiParagraph](Modern-Tui-TuiParagraph) | Draws text, wrapped or not, aligned left, centre or right, and scrollable. | `std/tui` |
| [TuiTabs](Modern-Tui-TuiTabs) | Draws a one-row strip of tab titles with the selected one highlighted. | `std/tui` |
| [TuiGauge](Modern-Tui-TuiGauge) | Draws a progress bar for a ratio from 0 to 1, labelled with the percentage. | `std/tui` |
| [TuiMeter](Modern-Tui-TuiMeter) | Draws a bar filled to a ratio whose colour shades from one end to the other. | `std/tui` |
| [TuiSpinner](Modern-Tui-TuiSpinner) | Draws a busy indicator that moves on one step each time you call Advance. | `std/tui` |
| [TuiSpinner.Advance](Modern-Tui-TuiSpinner-Advance) | Moves the spinner to its next frame, wrapping at the end. | `std/tui` |
| [TuiSpinnerDefaultFrames](Modern-Tui-TuiSpinnerDefaultFrames) | Fills an array with the default braille spinner frames. | `std/tui` |

## Show lists, tables and trees

| Function | What it does | From |
|---|---|---|
| [TuiList](Modern-Tui-TuiList) | Draws a scrolling list the user moves through with the arrow keys. | `std/tui` |
| [TuiListState](Modern-Tui-TuiListState) | Holds a list's selected item and scroll position; -1 means nothing is selected. | `std/tui` |
| [TuiTable](Modern-Tui-TuiTable) | Draws a scrolling table with headers, its columns sized like a layout. | `std/tui` |
| [TuiTableState](Modern-Tui-TuiTableState) | Holds a table's selected row and scroll position. | `std/tui` |
| [TuiRow](Modern-Tui-TuiRow) | Holds one table row: its cell texts in column order. | `std/tui` |
| [TuiTree](Modern-Tui-TuiTree) | Draws a tree of nodes that the user expands and collapses with the arrow keys. | `std/tui` |
| [TuiTree.Add](Modern-Tui-TuiTree-Add) | Appends a node at a depth; the deeper nodes after it become its children. | `std/tui` |
| [TuiTree.VisibleCount](Modern-Tui-TuiTree-VisibleCount) | Counts the nodes currently shown, leaving out those inside collapsed nodes. | `std/tui` |
| [TuiTreeNode](Modern-Tui-TuiTreeNode) | Holds one tree node: its label, depth, whether it has children, and your own id. | `std/tui` |
| [TuiTreeState](Modern-Tui-TuiTreeState) | Holds a tree's selected node and scroll position. | `std/tui` |
| [TuiScrollbar](Modern-Tui-TuiScrollbar) | Draws a scrollbar from a total, the number visible and the current position. | `std/tui` |

## Build forms and move focus between fields

| Function | What it does | From |
|---|---|---|
| [TuiTextInput](Modern-Tui-TuiTextInput) | Draws a one-line text box with a cursor, selection and optional password masking. | `std/tui` |
| [TuiTextInputState](Modern-Tui-TuiTextInputState) | Holds a text box's text, cursor, selection and scroll position. | `std/tui` |
| [TuiTextInputStateInit](Modern-Tui-TuiTextInputStateInit) | Sets a text box's state to empty with nothing selected; call it before first use. | `std/tui` |
| [TuiTextInput.Insert](Modern-Tui-TuiTextInput-Insert) | Inserts text at the cursor, replacing any selection first. | `std/tui` |
| [TuiTextInput.DeleteSelection](Modern-Tui-TuiTextInput-DeleteSelection) | Removes the selected text, or does nothing if none is selected. | `std/tui` |
| [TuiTextInput.SelectionStart](Modern-Tui-TuiTextInput-SelectionStart) | Returns where the selection starts, or the cursor position if nothing is selected. | `std/tui` |
| [TuiTextInput.SelectionEnd](Modern-Tui-TuiTextInput-SelectionEnd) | Returns where the selection ends, or the cursor position if nothing is selected. | `std/tui` |
| [TuiTextArea](Modern-Tui-TuiTextArea) | Draws a multi-line text editor with optional line numbers. | `std/tui` |
| [TuiTextAreaState](Modern-Tui-TuiTextAreaState) | Holds a text area's lines, cursor line and column, and scroll position. | `std/tui` |
| [TuiTextAreaStateInit](Modern-Tui-TuiTextAreaStateInit) | Sets a text area's state to one empty line; call it before first use. | `std/tui` |
| [TuiCheckbox](Modern-Tui-TuiCheckbox) | Draws a labelled checkbox that Space or Enter toggles, changing your own boolean. | `std/tui` |
| [TuiRadioGroup](Modern-Tui-TuiRadioGroup) | Draws a set of options where one is chosen, stored in your own variable. | `std/tui` |
| [TuiSelect](Modern-Tui-TuiSelect) | Draws a dropdown list of options that opens over whatever is below it. | `std/tui` |
| [TuiSelect.IsOpen](Modern-Tui-TuiSelect-IsOpen) | Returns true if the dropdown's list is showing. | `std/tui` |
| [TuiSelectState](Modern-Tui-TuiSelectState) | Holds a dropdown's chosen option, whether it is open, and the highlighted entry. | `std/tui` |
| [TuiButton](Modern-Tui-TuiButton) | Draws a button that calls your procedure when the user presses Enter on it. | `std/tui` |
| [TuiButtonOf](Modern-Tui-TuiButtonOf) | Draws a button whose handler is a lambda that captures variables. | `std/tui` |
| [TuiFocusRing](Modern-Tui-TuiFocusRing) | Holds the Tab order of your widgets and tells each one when it has focus. | `std/tui` |
| [TuiFocusRing.Add](Modern-Tui-TuiFocusRing-Add) | Adds a widget to the end of the Tab order; the widget must outlive the frame. | `std/tui` |
| [TuiFocusRing.Next_](Modern-Tui-TuiFocusRing-Next) | Moves focus to the next widget, wrapping at the end, as Tab does. | `std/tui` |
| [TuiFocusRing.Prev](Modern-Tui-TuiFocusRing-Prev) | Moves focus to the previous widget, wrapping at the start, as Shift+Tab does. | `std/tui` |
| [TuiFocusRing.Focus](Modern-Tui-TuiFocusRing-Focus) | Focuses a given widget, or returns false if it is not in the ring. | `std/tui` |
| [TuiFocusRing.Current](Modern-Tui-TuiFocusRing-Current) | Returns the focused widget, or no value if the ring is empty. | `std/tui` |
| [TuiFocusRing.Count](Modern-Tui-TuiFocusRing-Count) | Counts the widgets in the Tab order. | `std/tui` |
| [TuiFocusRing.Clear](Modern-Tui-TuiFocusRing-Clear) | Empties the Tab order; the widgets themselves are left alone. | `std/tui` |

## Show pop-ups, dialogs, menus and status bars

| Function | What it does | From |
|---|---|---|
| [TuiPopup](Modern-Tui-TuiPopup) | Draws a floating panel over the screen, optionally modal and dimming what is behind. | `std/tui` |
| [TuiMessageBox](Modern-Tui-TuiMessageBox) | Draws a dialog with a title, a message and buttons, coloured by its kind. | `std/tui` |
| [TuiMessageBox.Accepted](Modern-Tui-TuiMessageBox-Accepted) | Returns true once Enter was pressed on a button; selected says which. | `std/tui` |
| [TuiMessageBox.Cancelled](Modern-Tui-TuiMessageBox-Cancelled) | Returns true once the dialog was dismissed with Esc. | `std/tui` |
| [TuiMenuBar](Modern-Tui-TuiMenuBar) | Draws a one-row menu bar whose menus drop down with Enter. | `std/tui` |
| [TuiMenuBar.IsOpen](Modern-Tui-TuiMenuBar-IsOpen) | Returns true if one of the menus is dropped down. | `std/tui` |
| [TuiMenu](Modern-Tui-TuiMenu) | Holds one menu of a menu bar: its label and its items. | `std/tui` |
| [TuiStatusBar](Modern-Tui-TuiStatusBar) | Draws one row of status items, some packed to the left and some to the right. | `std/tui` |
| [TuiStatusBar.Add](Modern-Tui-TuiStatusBar-Add) | Adds an item at the left or right; include any padding spaces in the text. | `std/tui` |
| [TuiStatusItem](Modern-Tui-TuiStatusItem) | Holds one status bar item: its text, style and alignment. | `std/tui` |
| [TuiStatusItemOf](Modern-Tui-TuiStatusItemOf) | Returns a status bar item from text, a style and an alignment. | `std/tui` |

## Draw graphs, charts and braille dots

| Function | What it does | From |
|---|---|---|
| [TuiGraph](Modern-Tui-TuiGraph) | Draws a line graph of one or more series, scaled to fit or to a fixed range. | `std/tui` |
| [TuiSeries](Modern-Tui-TuiSeries) | Holds one line of a graph: its values, newest last, plus a colour and name. | `std/tui` |
| [TuiSparkline](Modern-Tui-TuiSparkline) | Draws a one-row trend of values as block characters, one value per cell. | `std/tui` |
| [TuiBarChart](Modern-Tui-TuiBarChart) | Draws labelled bars, vertical or horizontal, scaled to the largest value. | `std/tui` |
| [TuiBar](Modern-Tui-TuiBar) | Holds one bar of a bar chart: its label, value and colour. | `std/tui` |
| [TuiCanvas](Modern-Tui-TuiCanvas) | Holds a braille drawing surface with a grid of 2 by 4 dots in every cell. | `std/tui` |
| [TuiCanvas.Dot](Modern-Tui-TuiCanvas-Dot) | Sets one dot in a colour; a dot outside the canvas is ignored. | `std/tui` |
| [TuiCanvas.Line_](Modern-Tui-TuiCanvas-Line) | Draws a straight line of dots between two points. | `std/tui` |
| [TuiCanvas.Clear](Modern-Tui-TuiCanvas-Clear) | Turns every dot off. | `std/tui` |
| [TuiCanvas.Blit](Modern-Tui-TuiCanvas-Blit) | Draws the canvas into an area of the frame as braille characters. | `std/tui` |
| [TuiCanvas.Resize](Modern-Tui-TuiCanvas-Resize) | Changes the canvas size in cells and clears it. | `std/tui` |
| [TuiCanvas.CellCols](Modern-Tui-TuiCanvas-CellCols) | Returns the canvas width in cells. | `std/tui` |
| [TuiCanvas.CellRows](Modern-Tui-TuiCanvas-CellRows) | Returns the canvas height in cells. | `std/tui` |
| [TuiCanvas.DotWidth](Modern-Tui-TuiCanvas-DotWidth) | Returns the canvas width in dots, two per cell. | `std/tui` |
| [TuiCanvas.DotHeight](Modern-Tui-TuiCanvas-DotHeight) | Returns the canvas height in dots, four per cell. | `std/tui` |
| [TuiCanvas.Pattern](Modern-Tui-TuiCanvas-Pattern) | Returns the braille dot pattern of one cell as a byte. | `std/tui` |

## Split the screen into panels

| Function | What it does | From |
|---|---|---|
| [TuiSplitV](Modern-Tui-TuiSplitV) | Splits a rectangle into rows stacked top to bottom, sized by constraints. | `std/tui` |
| [TuiSplitH](Modern-Tui-TuiSplitH) | Splits a rectangle into columns side by side, sized by constraints. | `std/tui` |
| [TuiLength](Modern-Tui-TuiLength) | Returns a constraint for exactly n cells. | `std/tui` |
| [TuiFill](Modern-Tui-TuiFill) | Returns a constraint that shares the space left over, by weight. | `std/tui` |
| [TuiPercent](Modern-Tui-TuiPercent) | Returns a constraint for a percentage of the whole space being split. | `std/tui` |
| [TuiRatio](Modern-Tui-TuiRatio) | Returns a constraint for a fraction of the whole space, such as one third. | `std/tui` |
| [TuiMin_](Modern-Tui-TuiMin) | Returns a constraint for at least n cells, more if there is room. | `std/tui` |
| [TuiMax_](Modern-Tui-TuiMax) | Returns a constraint for at most n cells. | `std/tui` |
| [TuiConstraint](Modern-Tui-TuiConstraint) | Holds one sizing rule for a split, such as a fixed length or a share of the rest. | `std/tui` |
| [TuiSolve](Modern-Tui-TuiSolve) | Returns the sizes that constraints give a total, adding up to exactly that total. | `std/tui` |
| [TuiCenter](Modern-Tui-TuiCenter) | Returns a rectangle of a given size centred in another, as for a dialog. | `std/tui` |
| [TuiAlignIn](Modern-Tui-TuiAlignIn) | Returns a rectangle of a given width at the left, centre or right of another. | `std/tui` |
| [TuiPad](Modern-Tui-TuiPad) | Returns a rectangle shrunk by a margin. | `std/tui` |
| [TuiPadAll](Modern-Tui-TuiPadAll) | Returns a rectangle shrunk by the same amount on every side. | `std/tui` |
| [TuiStack](Modern-Tui-TuiStack) | Holds child widgets laid out in a row or column; it deletes them when it goes. | `std/tui` |
| [TuiStack.Add](Modern-Tui-TuiStack-Add) | Adds a child widget made with New and the constraint that sizes it. | `std/tui` |
| [TuiStack.ChildRect](Modern-Tui-TuiStack-ChildRect) | Returns the rectangle a child got at the last Render, for mouse hit tests. | `std/tui` |

## Rectangles, sizes and margins

| Function | What it does | From |
|---|---|---|
| [TuiRect](Modern-Tui-TuiRect) | Holds a rectangle of cells: x, y, width and height, counted from 0. | `std/tui` |
| [TuiRectOf](Modern-Tui-TuiRectOf) | Returns a rectangle from x, y, width and height. | `std/tui` |
| [TuiRect.Contains](Modern-Tui-TuiRect-Contains) | Returns true if a cell is inside the rectangle; use it to hit-test the mouse. | `std/tui` |
| [TuiRect.Intersect](Modern-Tui-TuiRect-Intersect) | Returns the overlap of two rectangles, or an empty one if they do not touch. | `std/tui` |
| [TuiRect.Inner](Modern-Tui-TuiRect-Inner) | Returns the rectangle shrunk by a margin, empty rather than negative. | `std/tui` |
| [TuiRect.IsEmpty](Modern-Tui-TuiRect-IsEmpty) | Returns true if the rectangle has no width or no height. | `std/tui` |
| [TuiRect.Equals](Modern-Tui-TuiRect-Equals) | Returns true if two rectangles have the same position and size. | `std/tui` |
| [TuiRect.Right](Modern-Tui-TuiRect-Right) | Returns x plus the width: the first column past the right edge. | `std/tui` |
| [TuiRect.Bottom](Modern-Tui-TuiRect-Bottom) | Returns y plus the height: the first row below the bottom edge. | `std/tui` |
| [TuiPos](Modern-Tui-TuiPos) | Holds a cell position: x and y. | `std/tui` |
| [TuiSize](Modern-Tui-TuiSize) | Holds a size in columns and rows. | `std/tui` |
| [TuiSizeOf](Modern-Tui-TuiSizeOf) | Returns a size from columns and rows. | `std/tui` |
| [TuiMargin](Modern-Tui-TuiMargin) | Holds an inset for each side, in the order left, top, right, bottom. | `std/tui` |
| [TuiMarginOf](Modern-Tui-TuiMarginOf) | Returns a margin from left, top, right and bottom. | `std/tui` |
| [TuiMarginAll](Modern-Tui-TuiMarginAll) | Returns a margin of the same size on every side. | `std/tui` |

## Style text: attributes and themes

| Function | What it does | From |
|---|---|---|
| [TuiStyle](Modern-Tui-TuiStyle) | Holds a text style: colours, attributes such as bold, and which of them it sets. | `std/tui` |
| [TuiStyleOf](Modern-Tui-TuiStyleOf) | Returns a style with a foreground, a background and optional attributes. | `std/tui` |
| [TuiStylePatch](Modern-Tui-TuiStylePatch) | Returns a partial style that sets only the parts you name, such as just bold. | `std/tui` |
| [TuiStyleDefault](Modern-Tui-TuiStyleDefault) | Returns the terminal's default style: default colours and no attributes. | `std/tui` |
| [TuiStyle.Patch](Modern-Tui-TuiStyle-Patch) | Returns this style with another laid over it, keeping whatever the other leaves unset. | `std/tui` |
| [TuiStyle.HasAttr](Modern-Tui-TuiStyle-HasAttr) | Returns true if the style has an attribute such as bold or underline. | `std/tui` |
| [TuiStyle.Equals](Modern-Tui-TuiStyle-Equals) | Returns true if two styles are identical, including which parts they set. | `std/tui` |
| [TuiTheme](Modern-Tui-TuiTheme) | Holds twelve named styles, such as normal, accent, selected and danger. | `std/tui` |
| [TuiThemeDefault](Modern-Tui-TuiThemeDefault) | Returns the stock colour theme. | `std/tui` |
| [TuiThemeMono](Modern-Tui-TuiThemeMono) | Returns a theme made from bold, dim, reverse and underline, with no colours. | `std/tui` |

## Pick colours

| Function | What it does | From |
|---|---|---|
| [TuiColor](Modern-Tui-TuiColor) | Holds a colour: the terminal's default, one of 16 or 256, or 24-bit RGB. | `std/tui` |
| [TuiRgb](Modern-Tui-TuiRgb) | Returns a 24-bit colour, reduced for you on terminals with fewer colours. | `std/tui` |
| [TuiAnsi](Modern-Tui-TuiAnsi) | Returns one of the 16 classic colours, which follow the user's terminal theme. | `std/tui` |
| [TuiIndexed](Modern-Tui-TuiIndexed) | Returns a colour from the 256-colour palette by its number. | `std/tui` |
| [TuiDefaultColor](Modern-Tui-TuiDefaultColor) | Returns the terminal's own default colour; as a background it does not paint. | `std/tui` |
| [TuiBlack](Modern-Tui-TuiBlack) | Returns the classic black, palette colour 0. | `std/tui` |
| [TuiRed](Modern-Tui-TuiRed) | Returns the classic red, palette colour 1. | `std/tui` |
| [TuiGreen](Modern-Tui-TuiGreen) | Returns the classic green, palette colour 2. | `std/tui` |
| [TuiYellow](Modern-Tui-TuiYellow) | Returns the classic yellow, palette colour 3. | `std/tui` |
| [TuiBlue](Modern-Tui-TuiBlue) | Returns the classic blue, palette colour 4. | `std/tui` |
| [TuiMagenta](Modern-Tui-TuiMagenta) | Returns the classic magenta, palette colour 5. | `std/tui` |
| [TuiCyan](Modern-Tui-TuiCyan) | Returns the classic cyan, palette colour 6. | `std/tui` |
| [TuiWhite](Modern-Tui-TuiWhite) | Returns the classic white, palette colour 7. | `std/tui` |
| [TuiBrightBlack](Modern-Tui-TuiBrightBlack) | Returns the classic bright black, palette colour 8. | `std/tui` |
| [TuiBrightRed](Modern-Tui-TuiBrightRed) | Returns the classic bright red, palette colour 9. | `std/tui` |
| [TuiBrightGreen](Modern-Tui-TuiBrightGreen) | Returns the classic bright green, palette colour 10. | `std/tui` |
| [TuiBrightYellow](Modern-Tui-TuiBrightYellow) | Returns the classic bright yellow, palette colour 11. | `std/tui` |
| [TuiBrightBlue](Modern-Tui-TuiBrightBlue) | Returns the classic bright blue, palette colour 12. | `std/tui` |
| [TuiBrightMagenta](Modern-Tui-TuiBrightMagenta) | Returns the classic bright magenta, palette colour 13. | `std/tui` |
| [TuiBrightCyan](Modern-Tui-TuiBrightCyan) | Returns the classic bright cyan, palette colour 14. | `std/tui` |
| [TuiBrightWhite](Modern-Tui-TuiBrightWhite) | Returns the classic bright white, palette colour 15. | `std/tui` |
| [TuiColor.Equals](Modern-Tui-TuiColor-Equals) | Returns true if two colours were built the same way with the same values. | `std/tui` |
| [TuiColor.Index](Modern-Tui-TuiColor-Index) | Returns the palette number of a 16-colour or 256-colour value. | `std/tui` |
| [TuiColor.IsDefault](Modern-Tui-TuiColor-IsDefault) | Returns true if the colour is the terminal's own default. | `std/tui` |
| [TuiLerpColor](Modern-Tui-TuiLerpColor) | Returns a colour part of the way between two others, for t from 0 to 1. | `std/tui` |
| [TuiDowngrade](Modern-Tui-TuiDowngrade) | Returns the colour that a terminal with fewer colours would show instead. | `std/tui` |
| [TuiDowngradeStyle](Modern-Tui-TuiDowngradeStyle) | Returns a style with both its colours reduced to what a terminal can show. | `std/tui` |
| [TuiRgbTo256](Modern-Tui-TuiRgbTo256) | Returns the nearest 256-palette colour number for red, green and blue values. | `std/tui` |
| [TuiRgbTo16](Modern-Tui-TuiRgbTo16) | Returns the nearest of the 16 classic colours for red, green and blue values. | `std/tui` |
| [TuiLuminance](Modern-Tui-TuiLuminance) | Returns how bright a colour looks, from 0.0 to 1.0. | `std/tui` |

## Measure, cut and wrap text by columns

| Function | What it does | From |
|---|---|---|
| [TuiStringWidth](Modern-Tui-TuiStringWidth) | Counts the columns a string takes on screen, wide characters as two. | `std/tui` |
| [TuiCharWidth](Modern-Tui-TuiCharWidth) | Returns the columns one character takes: 0, 1 or 2. | `std/tui` |
| [TuiTruncate](Modern-Tui-TuiTruncate) | Cuts a string to fit a number of columns, ending in "..." unless you pass "". | `std/tui` |
| [TuiWrap](Modern-Tui-TuiWrap) | Breaks text into lines that fit a number of columns, keeping its line breaks. | `std/tui` |
| [TuiSetAmbiguousWide](Modern-Tui-TuiSetAmbiguousWide) | Sets whether characters of ambiguous width count as two columns, for CJK terminals. | `std/tui` |
| [TuiAmbiguousWide](Modern-Tui-TuiAmbiguousWide) | Returns true if characters of ambiguous width count as two columns. | `std/tui` |

## Draw on the frame and write your own widgets

| Function | What it does | From |
|---|---|---|
| [TuiFrame](Modern-Tui-TuiFrame) | Holds the surface View draws on; drawing never fails and is clipped to fit. | `std/tui` |
| [TuiFrame.Area](Modern-Tui-TuiFrame-Area) | Returns the whole screen as a rectangle at 0, 0, the start of every layout. | `std/tui` |
| [TuiFrame.DrawText](Modern-Tui-TuiFrame-DrawText) | Draws a string at a cell and returns the number of columns it used. | `std/tui` |
| [TuiFrame.SetCell](Modern-Tui-TuiFrame-SetCell) | Writes one character cell, replacing the style that was there. | `std/tui` |
| [TuiFrame.FillRect](Modern-Tui-TuiFrame-FillRect) | Fills a rectangle with one character in one style. | `std/tui` |
| [TuiFrame.BlendStyle](Modern-Tui-TuiFrame-BlendStyle) | Lays a style over every cell of a rectangle, keeping the characters. | `std/tui` |
| [TuiFrame.Clip](Modern-Tui-TuiFrame-Clip) | Returns the rectangle that drawing is currently limited to. | `std/tui` |
| [TuiFrame.PushClip](Modern-Tui-TuiFrame-PushClip) | Limits drawing to a rectangle and returns the previous limit, to restore later. | `std/tui` |
| [TuiFrame.PopClip](Modern-Tui-TuiFrame-PopClip) | Restores the drawing limit that PushClip returned. | `std/tui` |
| [TuiFrame.PushLayer](Modern-Tui-TuiFrame-PushLayer) | Starts an overlay layer, as a popup or an open dropdown uses. | `std/tui` |
| [TuiFrame.PopLayer](Modern-Tui-TuiFrame-PopLayer) | Ends the overlay layer that PushLayer started. | `std/tui` |
| [TuiFrame.SetCursor](Modern-Tui-TuiFrame-SetCursor) | Shows the text cursor at a cell for this frame. | `std/tui` |
| [TuiFrame.HideCursor](Modern-Tui-TuiFrame-HideCursor) | Hides the text cursor for this frame, which is the default. | `std/tui` |
| [TuiFrame.CursorVisible](Modern-Tui-TuiFrame-CursorVisible) | Returns true if this frame asked to show the cursor. | `std/tui` |
| [TuiFrame.CursorPos](Modern-Tui-TuiFrame-CursorPos) | Returns the cell where the cursor was last put. | `std/tui` |
| [TuiWidget](Modern-Tui-TuiWidget) | Holds the base type every widget extends; you write Render and Kind for your own. | `std/tui` |
| [TuiWidget.Render](Modern-Tui-TuiWidget-Render) | Draws the widget into an area of the frame, changing no app state. | `std/tui` |
| [TuiWidget.HandleEvent](Modern-Tui-TuiWidget-HandleEvent) | Offers an event to the widget and returns true if the widget used it. | `std/tui` |
| [TuiWidget.Kind](Modern-Tui-TuiWidget-Kind) | Returns the widget's short type name, such as "Block". | `std/tui` |
| [TuiWidget.CanFocus](Modern-Tui-TuiWidget-CanFocus) | Returns true if the widget can take focus; false unless it is interactive. | `std/tui` |
| [TuiWidget.SetFocused](Modern-Tui-TuiWidget-SetFocused) | Tells the widget whether it has focus; the focus ring calls it for you. | `std/tui` |
| [TuiWidget.SizeHint](Modern-Tui-TuiWidget-SizeHint) | Returns the size the widget would like in the space given; layouts may ignore it. | `std/tui` |

## Render frames and test without a terminal

| Function | What it does | From |
|---|---|---|
| [TuiRenderOnce](Modern-Tui-TuiRenderOnce) | Runs Init and View once with no terminal and returns the bytes it would write. | `std/tui` |
| [TuiScreen](Modern-Tui-TuiScreen) | Holds two cell buffers and works out the bytes that turn one frame into the next. | `std/tui` |
| [TuiScreen.BeginFrame](Modern-Tui-TuiScreen-BeginFrame) | Clears the back buffer and returns the frame to draw into. | `std/tui` |
| [TuiScreen.Render](Modern-Tui-TuiScreen-Render) | Returns the bytes that change the last frame into the new one, then swaps buffers. | `std/tui` |
| [TuiScreen.Resize](Modern-Tui-TuiScreen-Resize) | Changes the screen size in cells and forces a full repaint. | `std/tui` |
| [TuiScreen.Invalidate](Modern-Tui-TuiScreen-Invalidate) | Makes the next Render clear and repaint the whole screen. | `std/tui` |
| [TuiScreen.Cols](Modern-Tui-TuiScreen-Cols) | Returns the screen width in cells. | `std/tui` |
| [TuiScreen.Rows](Modern-Tui-TuiScreen-Rows) | Returns the screen height in cells. | `std/tui` |
| [TuiScreen.Back](Modern-Tui-TuiScreen-Back) | Returns the buffer being drawn into, so a test can read its cells. | `std/tui` |
| [TuiScreen.Front](Modern-Tui-TuiScreen-Front) | Returns the buffer the terminal is taken to show: the last frame sent. | `std/tui` |
| [TuiBuffer](Modern-Tui-TuiBuffer) | Holds a grid of character cells, stored row by row. | `std/tui` |
| [TuiBuffer.At](Modern-Tui-TuiBuffer-At) | Returns a pointer to the cell at x, y, without checking the bounds. | `std/tui` |
| [TuiBuffer.InBounds](Modern-Tui-TuiBuffer-InBounds) | Returns true if x, y is inside the buffer. | `std/tui` |
| [TuiBuffer.Clear](Modern-Tui-TuiBuffer-Clear) | Fills every cell with a space in the given style. | `std/tui` |
| [TuiBuffer.Resize](Modern-Tui-TuiBuffer-Resize) | Changes the grid size and blanks every cell. | `std/tui` |
| [TuiBuffer.Count](Modern-Tui-TuiBuffer-Count) | Returns the number of cells: columns times rows. | `std/tui` |
| [TuiCell](Modern-Tui-TuiCell) | Holds one character cell: the character, its style and its width in columns. | `std/tui` |
| [TuiCell.SetChar](Modern-Tui-TuiCell-SetChar) | Sets the cell's character and works out its width in columns. | `std/tui` |
| [TuiCell.Equals](Modern-Tui-TuiCell-Equals) | Returns true if two cells have the same character, style and width. | `std/tui` |
| [TuiCellBlank](Modern-Tui-TuiCellBlank) | Returns a cell holding a space in the given style. | `std/tui` |

## Drive the terminal and parse input yourself

| Function | What it does | From |
|---|---|---|
| [TuiTerminal](Modern-Tui-TuiTerminal) | Holds the terminal itself, for writing your own loop: modes, size and output. | `std/tui` |
| [TuiTerminal.Enter](Modern-Tui-TuiTerminal-Enter) | Takes over the terminal with the options asked for; fails if output is not a terminal. | `std/tui` |
| [TuiTerminal.Leave](Modern-Tui-TuiTerminal-Leave) | Puts the terminal back the way Enter found it; safe to call more than once. | `std/tui` |
| [TuiTerminal.IsActive](Modern-Tui-TuiTerminal-IsActive) | Returns true between a successful Enter and its Leave. | `std/tui` |
| [TuiTerminal.Size](Modern-Tui-TuiTerminal-Size) | Returns the terminal's size in columns and rows, or an error if it reports none. | `std/tui` |
| [TuiTerminal.TakeResize](Modern-Tui-TuiTerminal-TakeResize) | Returns true once after each resize of the terminal, then false. | `std/tui` |
| [TuiTerminal.Write](Modern-Tui-TuiTerminal-Write) | Adds bytes to the output buffer; nothing is sent until Flush. | `std/tui` |
| [TuiTerminal.WriteText](Modern-Tui-TuiTerminal-WriteText) | Adds a string to the output buffer as UTF-8. | `std/tui` |
| [TuiTerminal.Flush](Modern-Tui-TuiTerminal-Flush) | Sends the buffered output in one write and empties the buffer. | `std/tui` |
| [TuiTerminal.Discard](Modern-Tui-TuiTerminal-Discard) | Throws the buffered output away without sending it. | `std/tui` |
| [TuiTerminal.Pending](Modern-Tui-TuiTerminal-Pending) | Counts the bytes buffered and not yet sent. | `std/tui` |
| [TuiTerminal.Caps](Modern-Tui-TuiTerminal-Caps) | Returns what the terminal can do, as detected once when it was entered. | `std/tui` |
| [TuiTerminal.DetectCaps](Modern-Tui-TuiTerminal-DetectCaps) | Detects what the terminal can do again, without entering it. | `std/tui` |
| [TuiCaps](Modern-Tui-TuiCaps) | Holds what a terminal can do: colour depth, mouse, paste, focus events, Unicode. | `std/tui` |
| [TuiError](Modern-Tui-TuiError) | Holds a terminal error: a code and what was being attempted. | `std/tui` |
| [TuiError.Message](Modern-Tui-TuiError-Message) | Returns a readable line saying what failed, including any system error number. | `std/tui` |
| [TuiInput](Modern-Tui-TuiInput) | Holds the parser that turns raw terminal bytes into events. | `std/tui` |
| [TuiInput.Feed](Modern-Tui-TuiInput-Feed) | Adds raw bytes from the terminal; an unfinished sequence is kept for later. | `std/tui` |
| [TuiInput.NextEvent](Modern-Tui-TuiInput-NextEvent) | Returns the next complete event, or no value yet; a lone Esc waits for a timeout. | `std/tui` |
| [TuiInput.PushEvent](Modern-Tui-TuiInput-PushEvent) | Adds an event to the back of the queue, to inject input yourself. | `std/tui` |
| [TuiInput.Queued](Modern-Tui-TuiInput-Queued) | Counts the parsed events waiting to be taken. | `std/tui` |
| [TuiInput.Buffered](Modern-Tui-TuiInput-Buffered) | Counts the bytes held that do not yet make a whole event. | `std/tui` |
| [TuiInput.Reset](Modern-Tui-TuiInput-Reset) | Throws away the held bytes and the queued events. | `std/tui` |
| [TuiInput.WaitingOnLoneEsc](Modern-Tui-TuiInput-WaitingOnLoneEsc) | Returns true if the parser holds an Esc it cannot yet tell from a key sequence. | `std/tui` |
| [TuiEnterSeq](Modern-Tui-TuiEnterSeq) | Returns the escape sequence that Enter writes for a set of options. | `std/tui` |
| [TuiLeaveSeq](Modern-Tui-TuiLeaveSeq) | Returns the escape sequence that Leave writes to undo those options. | `std/tui` |
| [TuiClearScreenSeq](Modern-Tui-TuiClearScreenSeq) | Returns the escape sequence that clears the terminal screen. | `std/tui` |
| [TuiCursorTo](Modern-Tui-TuiCursorTo) | Returns the escape sequence that moves the cursor to a cell counted from 0. | `std/tui` |
| [TuiShowCursorSeq](Modern-Tui-TuiShowCursorSeq) | Returns the escape sequence that shows or hides the cursor. | `std/tui` |
| [TuiSgr](Modern-Tui-TuiSgr) | Returns the escape sequence that changes the terminal from one style to another. | `std/tui` |
| [TuiSgrReset](Modern-Tui-TuiSgrReset) | Returns the escape sequence that resets every colour and attribute. | `std/tui` |
| [TuiWin32InputMode](Modern-Tui-TuiWin32InputMode) | Returns the Windows console input mode that Enter would set for given options. | `std/tui` |

## See Also

- [Console functions overview](Console-Functions)
- [Keyboard input overview](User-Input-Runtime-Library)
- [Terminal TUI Library guide](Category-Terminal-TUI-Library)
- [hello.tiko: the smallest TUI program](Modern-Tui-Example-Hello)
- [dashboard.tiko: a full TUI dashboard](Modern-Tui-Example-Dashboard)

---

[Home](Home) · [Function Finder](Function-Finder) · [Keyword Index](Keyword-Index)

<!-- Generated by tools/wikifinder/finder.py. Edit the data, not this page. -->
