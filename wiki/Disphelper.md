[Home](Home) › [Tutorials](Category-Tutorials) › **disphelper**

# disphelper

Disphelper is a COM helper library that can be used in plain C. No MFC or ATL is required. It allows you to call COM objects with an easy printf style syntax.

 Website: http://disphelper.sourceforge.net/  
 Platforms supported: Win32, Linux (using WINE)  
 Headers to include: disphelper/disphelper.bi  
 Header version: from 2005

Example

```freebasic
'' HTTP GET example, using MSXML2

#define UNICODE

#include "disphelper/disphelper.bi"

DISPATCH_OBJ(objHTTP)

dhInitialize(True)

dhToggleExceptions(True)

dhCreateObject("MSXML2.XMLHTTP.4.0", NULL, @objHTTP)

dhCallMethod(objHTTP, ".Open(%s, %s, %b)", "GET", "http://sourceforge.net", False)

dhCallMethod(objHTTP, ".Send")

Dim As ZString Ptr szResponse

dhGetValue("%s", @szResponse, objHTTP, ".ResponseText")

Print "Response: "; *szResponse

dhFreeString(szResponse)

SAFE_RELEASE(objHTTP)

dhUninitialize(True)
```

```freebasic
'' IExplorer example

#define UNICODE

#include "disphelper/disphelper.bi"

Sub navigate(ByRef url As String)

    DISPATCH_OBJ(ieApp)

    dhInitialize(True)

    dhToggleExceptions(True)

    dhCreateObject("InternetExplorer.Application", NULL, @ieApp)

    dhPutValue(ieApp, "Visible = %b", True)

    dhCallMethod(ieApp, ".Navigate(%s)", url)

    SAFE_RELEASE(ieApp)

    dhUninitialize(True)

End Sub

    navigate("www.freebasic.net")
```

```freebasic
'' VB Script example

#define UNICODE

#include "disphelper/disphelper.bi"

'' This function runs a script using the MSScriptControl.

'' Optionally returns a result.

Sub RunScript _

    ( _

        ByVal result_identifier As LPWSTR, _

        ByVal result As LPVOID, _

        ByVal script As LPWSTR, _

        ByVal language As LPWSTR _

    )

    DISPATCH_OBJ(control)

    If (SUCCEEDED(dhCreateObject("MSScriptControl.ScriptControl", NULL, @control))) Then

        If (SUCCEEDED(dhPutValue(control, ".Language = %T", language))) Then

            dhPutValue(control, ".AllowUI = %b", True)

            dhPutValue(control, ".UseSafeSubset = %b", False)

            If (result) Then

                dhGetValue(result_identifier, result, control, ".Eval(%T)", script)

            Else

                dhCallMethod(control, ".Eval(%T)", script)

            End If

        End If

    End If

    SAFE_RELEASE(control)

End Sub

    dhInitialize(True)

    dhToggleExceptions(True)

    '' VBScript sample

    RunScript(NULL, NULL, !"MsgBox(\"This Is a VBScript test.\" & vbcrlf & \"It worked!\",64 Or 3)", "VBScript")

    '' JScript sample

    Dim As Integer result

    RunScript("%d", @result, "Math.round(Math.pow(5, 2) * Math.PI)", "JScript")

    Print "Result ="; result

    Print "Press any key to exit..."

    Sleep

    dhUninitialize(True)
```

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
