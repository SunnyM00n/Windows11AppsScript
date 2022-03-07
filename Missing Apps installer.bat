@echo off

echo Checking for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

echo Permission check result: %errorlevel%

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
echo Requesting administrative privileges...
goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

echo Running created temporary "%temp%\getadmin.vbs"
timeout /T 2
"%temp%\getadmin.vbs"
exit /B

:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0" 

echo Batch was successfully started with admin privileges
echo .
cls

Title Windows App Installer

pause

cls
dir /b Microsoft.NET.Native.Framework*.appx >>appstore.txt
dir /b Microsoft.NET.Native.Runtime*.appx >>appstore.txt
dir /b Microsoft.UI.Xaml*.appx >>appstore.txt
dir /b Microsoft.VCLibs.140.00_14.0.30704.0_x64*.appx >>appstore.txt
dir /b Microsoft.VCLibs.140.00.UWPDesktop_14.0.30704.0_x64*.appx >>appstore.txt
dir /b Microsoft.SecHealthUI*.appx >>appstore.txt
dir /b MicrosoftWindows.Client.WebExperience*.AppxBundle >>appstore.txt
dir /b Microsoft.WindowsStore*.msixbundle >>appstore.txt
dir /b Microsoft.WindowsNotepad*.msixbundle >>appstore.txt
dir /b Microsoft.WindowsTerminalPreview*.msixbundle >>appstore.txt


for /f %%i in ('findstr /i . appstore.txt 2^>nul') do dism /Online /add-provisionedappxpackage /packagepath:%%i /SkipLicense

del appstore.txt

pause
exit