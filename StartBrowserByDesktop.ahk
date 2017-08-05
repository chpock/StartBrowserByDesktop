; StartBrowserByDesktop v1.0
; https://github.com/chpock/StartBrowserByDesktop

; Configuration

Desktop3 = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" -- "%1%"
DesktopSwitch3 = 3
DesktopDefault = "C:\Program Files (x86)\Mozilla Firefox\firefox.exe" -osint -url "%1%"
DesktopSwitchDefault = 2

hVirtualDesktopAccessor := DllCall("LoadLibrary", "Str", A_ScriptDir . "\libraries\virtual-desktop-accessor.dll", "Ptr")

global GoToDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GoToDesktopNumber", "Ptr")
global RegisterPostMessageHookProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "RegisterPostMessageHook", "Ptr")
global UnregisterPostMessageHookProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "UnregisterPostMessageHook", "Ptr")
global GetCurrentDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GetCurrentDesktopNumber", "Ptr")
global GetDesktopCountProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GetDesktopCount", "Ptr")
global IsWindowOnDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsWindowOnDesktopNumber", "Ptr")
global MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "MoveWindowToDesktopNumber", "Ptr")
global IsPinnedWindowProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsPinnedWindow", "Ptr")
global PinWindowProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "PinWindow", "Ptr")
global UnPinWindowProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "UnPinWindow", "Ptr")
global IsPinnedAppProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsPinnedApp", "Ptr")
global PinAppProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "PinApp", "Ptr")
global UnPinAppProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "UnPinApp", "Ptr")

#NoTrayIcon

_GetCurrentDesktopNumber() {
    return DllCall(GetCurrentDesktopNumberProc) + 1
}

_ChangeDesktop(n:=1) {
    if (n == 0) {
        n := 10
    }
    DllCall(GoToDesktopNumberProc, Int, n-1)
}

var1=%1%

If(var1 == "register") {
    if not A_IsAdmin {
        ShellExecute := A_IsUnicode ? "shell32\ShellExecute":"shell32\ShellExecuteA"
        DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_ScriptFullPath, str, "register" , str, A_WorkingDir, int, 1)
        ExitApp
    }
    Regwrite, REG_SZ, HKLM\SOFTWARE\RegisteredApplications, BrowserByVDesktop, Software\Clients\StartMenuInternet\BrowserByVDesktop\Capabilities
    Regwrite, REG_SZ, HKLM\SOFTWARE\Clients\StartMenuInternet\BrowserByVDesktop, , BrowserByVDesktop
    Regwrite, REG_SZ, HKLM\SOFTWARE\Clients\StartMenuInternet\BrowserByVDesktop\Capabilities, ApplicationDescription, Start browser by virtual desktop
    Regwrite, REG_SZ, HKLM\SOFTWARE\Clients\StartMenuInternet\BrowserByVDesktop\Capabilities, ApplicationName, BrowserByVDesktop
    Regwrite, REG_SZ, HKLM\SOFTWARE\Clients\StartMenuInternet\BrowserByVDesktop\Capabilities\FileAssociations, .htm, BrowserByVDesktop
    Regwrite, REG_SZ, HKLM\SOFTWARE\Clients\StartMenuInternet\BrowserByVDesktop\Capabilities\FileAssociations, .html, BrowserByVDesktop
    Regwrite, REG_SZ, HKLM\SOFTWARE\Clients\StartMenuInternet\BrowserByVDesktop\Capabilities\FileAssociations, .shtml, BrowserByVDesktop
    Regwrite, REG_SZ, HKLM\SOFTWARE\Clients\StartMenuInternet\BrowserByVDesktop\Capabilities\FileAssociations, .xhtml, BrowserByVDesktop
    Regwrite, REG_SZ, HKLM\SOFTWARE\Clients\StartMenuInternet\BrowserByVDesktop\Capabilities\FileAssociations, .xht, BrowserByVDesktop
    Regwrite, REG_SZ, HKLM\SOFTWARE\Clients\StartMenuInternet\BrowserByVDesktop\Capabilities\StartMenu, StartMenuInternet, BrowserByVDesktop
    Regwrite, REG_SZ, HKLM\SOFTWARE\Clients\StartMenuInternet\BrowserByVDesktop\Capabilities\URLAssociations, ftp, BrowserByVDesktop
    Regwrite, REG_SZ, HKLM\SOFTWARE\Clients\StartMenuInternet\BrowserByVDesktop\Capabilities\URLAssociations, http, BrowserByVDesktop
    Regwrite, REG_SZ, HKLM\SOFTWARE\Clients\StartMenuInternet\BrowserByVDesktop\Capabilities\URLAssociations, https, BrowserByVDesktop
    Regwrite, REG_SZ, HKLM\SOFTWARE\Clients\StartMenuInternet\BrowserByVDesktop\shell\open\command, , "%A_ScriptFullPath%" "`%1"
    Regwrite, REG_SZ, HKCR\BrowserByVDesktop, , BrowserByVDesktop HTML Document
    Regwrite, REG_SZ, HKCR\BrowserByVDesktop, AppUserModelId, BrowserByVDesktop
    Regwrite, REG_SZ, HKCR\BrowserByVDesktop\Application, ApplicationCompany, No company
    Regwrite, REG_SZ, HKCR\BrowserByVDesktop\Application, ApplicationDescription, Start browser by virtual desktop
    Regwrite, REG_SZ, HKCR\BrowserByVDesktop\Application, ApplicationName, BrowserByVDesktop
    Regwrite, REG_SZ, HKCR\BrowserByVDesktop\shell\open\command, , "%A_ScriptFullPath%" "`%1"
} else {
    VDesktop := _GetCurrentDesktopNumber()
    RunBrowser := Desktop%VDesktop%
    SwitchDesktop := DesktopSwitch%VDesktop%
    If(RunBrowser = "") {
        RunBrowser := DesktopDefault
        SwitchDesktop := DesktopSwitchDefault
    }
    If(SwitchDesktop <> "") {
        _ChangeDesktop(SwitchDesktop)
    }
    Run %RunBrowser%
}
ExitApp
