# peakws.ps1 -- the peak working set of one run of a program, in bytes.
#
# WHY A SCRIPT AND NOT A PROPERTY. .NET's Process.PeakWorkingSet64 reads EMPTY once the
# process has exited, which is the only moment the peak is interesting. The kernel still
# answers for an exited process while a HANDLE to it is open, so this asks psapi's
# GetProcessMemoryInfo through the handle .NET is already holding.
#
# Arguments arrive one per line in a file, because a Windows argument list that has
# hundreds of paths in it does not survive being spliced through a shell twice.
param([string]$Exe, [string]$ArgsFile)
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class TkoMem {
  [StructLayout(LayoutKind.Sequential)]
  public struct PMC {
    public uint cb; public uint PageFaultCount;
    public IntPtr PeakWorkingSetSize; public IntPtr WorkingSetSize;
    public IntPtr QuotaPeakPagedPoolUsage; public IntPtr QuotaPagedPoolUsage;
    public IntPtr QuotaPeakNonPagedPoolUsage; public IntPtr QuotaNonPagedPoolUsage;
    public IntPtr PagefileUsage; public IntPtr PeakPagefileUsage;
  }
  [DllImport("psapi.dll", SetLastError=true)]
  public static extern bool GetProcessMemoryInfo(IntPtr h, out PMC c, uint cb);
  public static long PeakWS(IntPtr h) {
    PMC c = new PMC();
    c.cb = (uint)Marshal.SizeOf(typeof(PMC));
    if (!GetProcessMemoryInfo(h, out c, c.cb)) return -1;
    return (long)c.PeakWorkingSetSize;
  }
}
"@
$tikoArgs = @(Get-Content -LiteralPath $ArgsFile)
$p = Start-Process -FilePath $Exe -ArgumentList $tikoArgs -PassThru -Wait -NoNewWindow `
     -RedirectStandardOutput "$env:TEMP\tko-peak-out.txt" -RedirectStandardError "$env:TEMP\tko-peak-err.txt"
[TkoMem]::PeakWS($p.Handle)
