@echo off
pushd %~dp0
set currentuser=%username%
rem UAC code begin
set getadminfile="%temp%\getadmin.vbs"
echo Windows Desktop Optimization
echo ============================
echo Starting
"%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\SYSTEM" >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    goto :Admin
) else (
    if %ERRORLEVEL% EQU 2 (
        goto :PathErr
    ) else (
        goto :UAC
    )
)
:PathErr
echo.
echo Please open "%~n0%~x0" by explorer.exe
echo.
echo Press any key to explore the folder...
pause>nul
start "" "%SYSTEMROOT%\system32\explorer.exe" /select,"%~f0"
goto :END
:UAC
echo Set sh = CreateObject^("Shell.Application"^) > %getadminfile%
echo sh.ShellExecute "%~f0", "", "", "runas", 1 >> %getadminfile%
ping 127.1 -n 1 >nul
"%SYSTEMROOT%\system32\cscript.exe" %getadminfile%
goto :END
:Admin
if exist %getadminfile% ( del %getadminfile% )
cls
rem UAC code end
echo Windows Desktop Optimization
echo ============================
PowerShell /Command "&{Get-WmiObject -Class Win32_OperatingSystem | Select-Object -ExpandProperty Caption}"
echo Current Domain: %USERDOMAIN%
echo Current User: %currentuser%
echo.
set /p tmpInput=Are you ready? (Y/N):
if /i "%tmpInput%"=="y" goto :START
echo Canelled.
echo Press any key to exit...
pause>nul
goto :END
:START
echo (1/3) Config Service
echo - [Disabled] Windows Update
call :disableService wuauserv
echo - [Disabled] Windows Search
call :disableService WSearch
echo - [Manual] Update Orchestrator Service for Windows Update
call :manualService UsoSvc
echo - [Manual] Superfetch
call :manualService SysMain
::echo - [Disabled] Security Center
::call :disableService wscsvc
echo - [Disabled] Network Connected Devices Auto-Setup
call :disableService NcdAutoSetup
echo - [Disabled] Microsoft Windows SMS Router Service
call :disableService SmsRouter
echo - [Disabled] HomeGroup Provider Server
call :disableService HomeGroupProvider
echo - [Disabled] HomeGroup Listener Server
call :disableService HomeGroupListener
echo - [Manual] Function Discovery Resource Publication
call :manualService FDResPub
echo - [Manual] Function Discovery Provider Host
call :manualService fdPHost
echo (2/3) Config Registry And Settings
echo - Disable UAC (* REBOOT)
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0x0 /f>nul
::echo - Disable Windows Defender
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 0x1 /f>nul
echo - Disable TCP Auto-Tuning
netsh interface tcp set heuristics disabled>nul
echo - Hide This PC 7 folders (* RESTART EXPLORER)
rem 3D Objects
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f>nul 2>nul
rem Desktop
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f>nul 2>nul
rem Documents
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f>nul 2>nul
rem Downloads
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f>nul 2>nul
rem Music
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f>nul 2>nul
rem Pictures
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f>nul 2>nul
rem Videos
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f>nul 2>nul
echo - Show extensions for known file types
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0x0 /f>nul
echo - Open File Explorer to This PC
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 0x1 /f>nul
echo - Hide recently used files in Quick access
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d 0x0 /f>nul
echo - Hide frequently used files in Quick access
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d 0x0 /f>nul
echo - Hide Recycle bin on Desktop
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 0x1 /f>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 0x1 /f>nul
::echo - Show Recycle bin on This PC
::reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{645FF040-5081-101B-9F08-00AA002F954E}" /f>nul
::rem reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{645FF040-5081-101B-9F08-00AA002F954E}" /f>nul 2>nul
echo - Pin Recycle bin to Quick access
call :pintohomeCLSID {645FF040-5081-101B-9F08-00AA002F954E}
::echo - Pin GodMode control panel to Quick access
::call :pintohomeDir "Control Panel (GodMode).{ED7BA470-8E54-465E-825C-99712043E01C}"
echo - Disable Windows Feedback
reg add "HKCU\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0x0 /f>nul
reg add "HKCU\Software\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /t REG_DWORD /d 0x0 /f>nul
echo - Disable Application Experience task schedulers
schtasks /change /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable>nul 2>nul
schtasks /change /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable>nul 2>nul
schtasks /change /tn "\Microsoft\Windows\Application Experience\StartupAppTask" /disable>nul 2>nul
echo - Disable Customer Experience Improvement Program task schedulers
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable>nul 2>nul
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /disable>nul 2>nul
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /disable>nul 2>nul
echo (3/3) Config Appx
echo - Nothing to do.
::echo - Remove XBox
::call :removeAppx *xbox*
::echo - Remove Zune
::call :removeAppx *zune*
::echo - Remove Bing
::call :removeAppx *bing*
echo.
echo Press any key to EXIT...
pause>nul
goto :END
:pintohomeCLSID
reg add "HKCR\CLSID\%1\shell\pintohome" /v "MUIVerb" /t REG_SZ /d "@shell32.dll,-51377" /f>nul
reg add "HKCR\CLSID\%1\shell\pintohome\command" /v "DelegateExecute" /t REG_SZ /d "{b455f46e-e4af-4035-b0a4-cf18d2f6f28e}" /f>nul
PowerShell /Command "&{$o=New-Object -ComObject shell.application;$o.Namespace('shell:::%1').Self.InvokeVerb('pintohome')}">nul
reg delete "HKCR\CLSID\%1\shell\pintohome" /f>nul
goto :eof
:pintohomeDir
set tmpDir=%userprofile%\Desktop\%~1
md "%tmpDir%">nul
PowerShell /Command "&{$o=New-Object -ComObject shell.application;$o.Namespace('%tmpDir%').Self.InvokeVerb('pintohome')}">nul
rd /q "%tmpDir%">nul
goto :eof
:disableService
call :configService %1 4 null stop
goto :eof
:manualService
call :configService %1 3 null stop
goto :eof
:configService
::%1 is service name (not DisplayName)
::%2 is startup type (2-Automatic, 3-Manual, 4-Disabled)
::%3 is DelayedAutostart (1-Enabled, 0-Disable, null-skip)
::%4 is net command (start, stop, null-skip)
set serviceName=%~1
if "%serviceName%"=="" goto :eof
if "%2"=="" goto :eof
set regKey="HKLM\SYSTEM\CurrentControlSet\services\%serviceName%"
reg query %regKey% /v Start>nul 2>nul
if ERRORLEVEL 1 goto :eof
reg add %regKey% /v Start /t REG_DWORD /d %2 /f>nul
if "%3"=="" goto :eof
if /i %3==null goto :eof
reg add %regKey% /v DelayedAutostart /t REG_DWORD /d %3 /f>nul
if "%4"=="" goto :eof
if /i %4==null goto :eof
net %4 %serviceName%>nul
goto :eof
:removeAppx
if "%1"=="" goto :eof
PowerShell /Command "&{Get-AppxPackage %1 | Remove-AppxPackage}">nul
::%1 filter
goto :eof
:END
if exist %getadminfile% ( del %getadminfile% )
popd
