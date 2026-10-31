' ########################################################################################
' Microsoft Windows
' Contents: GDI+ - MeasureCharacterRanges example
' Compiler: tiko-lang
' Copyright (c) 2026 José Roca. Freeware. Use at your own risk.
' THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
' EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
' MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
' ########################################################################################

#import "sys/win"
#import "sys/win/gui"
#import "sys/win/gdiplus"
using win, gui, gdiplus

CONST IDC_GRCTX = 1001

' // Forward declaration
DECLARE FUNCTION WndProc (BYVAL hwnd AS HWND, BYVAL uMsg AS UINT, BYVAL wParam AS WPARAM, BYVAL lParam AS LPARAM) AS LRESULT

' ========================================================================================
' The following example defines three ranges of character positions within a string and
' sets those ranges in a StringFormat object. Next, the MeasureCharacterRanges method is
' used to get the three regions of the display that are occupied by the characters that
' are specified by the ranges. This is done for three different layout rectangles to show
' how the regions change according to the layout of the string. Also, on the third repetition
' of this, the string format flags are changed so that the regions measured will include
' trailing spaces.
' ========================================================================================
SUB Example_MeasureCharacterRanges (BYVAL hdc AS HDC)

   ' // Create a graphics object from the window device context
   DIM graphics AS CGpGraphics = hdc
   ' // Set the scale transform
   DIM rxRatio AS SINGLE = graphics.GetDpiX / 96
   DIM ryRatio AS SINGLE = graphics.GetDpiY / 96
   graphics.ScaleTransform(rxRatio, ryRatio)

   ' // Create font
   DIM font AS CGpFont = CGpFont("Times New Roman", PointsToPixels(16, TRUE), FontStyleRegular)

   ' // Create brushes and pen
   DIM blueBrush AS CGpSolidBrush = ARGB_BLUE
   DIM redBrush AS CGpSolidBrush = GDIP_ARGB(100, 255, 0, 0)
   DIM blackPen AS CGpPen = CGpPen(ARGB_BLACK, 1.0)
   blackPen.ScaleTransform(rxRatio, ryRatio)

   ' // Create string format and define character ranges
   DIM stringFormat AS CGpStringFormat
   DIM charRanges(2) AS GpCharacterRange
   charRanges(0).First = 3  : charRanges(0).Length = 5
   charRanges(1).First = 15 : charRanges(1).Length = 2
   charRanges(2).First = 30 : charRanges(2).Length = 15
   stringFormat.SetMeasurableCharacterRanges(3, @charRanges(0))

   ' // Allocate regions
   DIM regions(2) AS CGpRegion

   ' // Text to measure
   DIM text AS WSTRING * 128 = "The quick, brown fox easily jumps over the lazy dog."

   ' // Measure and draw for layoutRectA
   DIM layoutRectA AS GpRectF = (20.0, 20.0, 130.0, 130.0)
   graphics.MeasureCharacterRanges(text, -1, @font, @layoutRectA, @stringFormat, 3, @regions(0))
   graphics.DrawString(text, -1, @font, @layoutRectA, @stringFormat, @blueBrush)
   graphics.DrawRectangle(@blackPen, layoutRectA.X, layoutRectA.Y, layoutRectA.Width, layoutRectA.Height)
   FOR i AS LONG = 0 TO 2
      graphics.FillRegion(@redBrush, @regions(i))
   NEXT

   ' // Measure and draw for layoutRectB
   DIM layoutRectB AS GpRectF = (160.0, 20.0, 165.0, 130.0)
   graphics.MeasureCharacterRanges(text, -1, @font, @layoutRectB, @stringFormat, 3, @regions(0))
   graphics.DrawString(text, -1, @font, @layoutRectB, @stringFormat, @blueBrush)
   graphics.DrawRectangle(@blackPen, layoutRectB.X, layoutRectB.Y, layoutRectB.Width, layoutRectB.Height)
   FOR i AS LONG = 0 TO 2
      graphics.FillRegion(@redBrush, @regions(i))
   NEXT

   ' // Set trailing space flag and draw for layoutRectC
   DIM layoutRectC AS GpRectF = (335.0, 20.0, 165.0, 130.0)
   stringFormat.SetFormatFlags(StringFormatFlagsMeasureTrailingSpaces)
   graphics.MeasureCharacterRanges(text, -1, @font, @layoutRectC, @stringFormat, 3, @regions(0))
   graphics.DrawString(text, -1, @font, @layoutRectC, @stringFormat, @blueBrush)
   graphics.DrawRectangle(@blackPen, layoutRectC.X, layoutRectC.Y, layoutRectC.Width, layoutRectC.Height)
   FOR i AS LONG = 0 TO 2
      graphics.FillRegion(@redBrush, @regions(i))
   NEXT

END SUB
' ========================================================================================

' ========================================================================================
' Main
' ========================================================================================
FUNCTION main (BYVAL nCmdShow AS LONG = SW_SHOW) AS LONG

   ' // Set process DPI aware
   SetProcessDpiAwareness(PROCESS_SYSTEM_DPI_AWARE)
   ' // Enable visual styles without including a manifest file
   EnableVisualStyles

   ' // Create the main window
   DIM pWindow AS CWindow = "MyClassName"
   pWindow.Create(NULL, "GDI+ MeasureCharacterRanges", @WndProc)
   ' // Size it by setting the wanted width and height of its client area
   pWindow.SetClientSize(520, 250)
   ' // Center the window
   pWindow.Center

   ' // Add a graphic control
   DIM pGraphCtx AS CGraphCtx = CGraphCtx(@pWindow, IDC_GRCTX, "", 0, 0, pWindow.ClientWidth, pWindow.ClientHeight)
   pGraphCtx.Clear RGB_WHITE
   ' // Anchor the control
   pWindow.AnchorControl(pGraphCtx.hWindow, ANCHOR_HEIGHT_WIDTH)

   ' // Get the memory device context of the graphic control
   DIM hdc AS HDC = pGraphCtx.GetMemDc
   ' // Draw the graphics
   Example_MeasureCharacterRanges(hdc)

   ' // Displays the window and dispatches the Windows messages
   FUNCTION = pWindow.DoEvents(nCmdShow)

END FUNCTION
' ========================================================================================

' ========================================================================================
' Main window procedure
' ========================================================================================
FUNCTION WndProc (BYVAL hwnd AS HWND, BYVAL uMsg AS UINT, BYVAL wParam AS WPARAM, BYVAL lParam AS LPARAM) AS LRESULT

   SELECT CASE uMsg

      ' // If an application processes this message, it should return zero to continue
      ' // creation of the window. If the application returns –1, the window is destroyed
      ' // and the CreateWindowExW function returns a NULL handle.
      CASE WM_CREATE
         EnableDarkModeForWindow(hwnd)
         RETURN 0

      ' // Theme has changed
      CASE WM_THEMECHANGED
         EnableDarkModeForWindow(hwnd)
         RETURN 0

      CASE WM_COMMAND
         SELECT CASE CBCTL(wParam, lParam)
            CASE IDCANCEL
               ' // If ESC key pressed, close the application by sending an WM_CLOSE message
               IF CBCTLMSG(wParam, lParam) = BN_CLICKED THEN
                  SendMessageW hwnd, WM_CLOSE, 0, 0
                  RETURN 0
               END IF
         END SELECT

    	CASE WM_DESTROY
         ' // Ends the application by sending a WM_QUIT message
         PostQuitMessage(0)
         RETURN 0

   END SELECT

   ' // Default processing of Windows messages
   FUNCTION = DefWindowProcW(hwnd, uMsg, wParam, lParam)

END FUNCTION
' ========================================================================================

' ========================================================================================
' // Call main() and return the error code to the OS
' ========================================================================================
END main()
' ========================================================================================
