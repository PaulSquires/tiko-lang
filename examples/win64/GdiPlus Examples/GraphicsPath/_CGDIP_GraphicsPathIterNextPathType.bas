' ########################################################################################
' Microsoft Windows
' File: GraphicsPathIterNextPathType.bas
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
' Using NextPathType to group points by type.
' Helps you understand how a path is constructed—lines vs. curves.
' Enables selective rendering, editing, or flattening based on segment type.
' ========================================================================================
SUB Example_NextPathType (BYVAL hdc AS HDC)

   ' // Create a graphics object from the window device context
   DIM graphics AS CGpGraphics = hdc
   ' // Set the scale transform
   graphics.ScaleTransformForDpi

   ' // Create a GraphicsPath with grouped types
   DIM path AS CGpGraphicsPath
   path.AddLine(20, 20, 120, 20)
   path.AddLine(120, 20, 70, 100)
   path.AddLine(70, 100, 20, 20)
   path.AddBezier(150, 30, 180, 10, 210, 50, 240, 30)

   ' // Create a GraphicsPathIterator
   DIM iterator AS CGpGraphicsPathIterator = @path

   ' // Create font and brush for displaying segment info
   DIM fontFamily AS CGpFontFamily = CGpFontFamily("Arial")
   DIM font AS CGpFont = CGpFont(@fontFamily, PointsToPixels(12, TRUE), FontStyleRegular)
   DIM brush AS CGpSolidBrush = ARGB_BLACK

   ' // Iterate through path segments grouped by type
   DIM resultCount AS LONG, pathType AS BYTE
   DIM startIdx AS LONG, endIdx AS LONG
   DIM yOffset AS SINGLE = 10.0
   DIM segmentIndex AS LONG = 1

   DO
      resultCount = iterator.NextPathType(@pathType, @startIdx, @endIdx)
      IF resultCount = 0 THEN EXIT DO
      DIM typeName AS STRING
      SELECT CASE pathType AND &H07
         CASE PathPointTypeStart
            typeName = "Start"
         CASE PathPointTypeLine
            typeName = "Line"
         CASE PathPointTypeBezier
            typeName = "Bezier"
         CASE ELSE
            typeName = "Unknown"
      END SELECT
      DIM info AS STRING = "Segment " & segmentIndex & ": Type=" & typeName & _
                           ", Start=" & startIdx & ", End=" & endIdx
      DIM layout AS GpRectF = (10.0, yOffset, 400.0, 20.0)
      graphics.DrawString(info, -1, @font, @layout, @brush)
      yOffset += 20.0
      segmentIndex += 1
   LOOP

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
   pWindow.Create(NULL, "GDI+ GraphicsPathIterNextPathType", @WndProc)
   ' // Size it by setting the wanted width and height of its client area
   pWindow.SetClientSize(400, 250)
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
   Example_NextPathType(hdc)

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
