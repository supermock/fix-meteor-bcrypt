@ECHO OFF
SETLOCAL EnableDelayedExpansion

if "%1"=="" (
call:echo red "Pass path of meteor project."
goto:END
) else (
    if exist %1 (
        set meteor_project_path=%1
        call:checkInstalledDependencies
        call:getMeteorVersion
        call:echo yellow "Fixing problem with bcrypt..."
        for /f %%r in ('node getMeteorVersion.js !meteor_project_path! %0') do (
            if "%%r" equ "true" (
                call:echo green "Operation completed successfully."
            ) else (
                call:echo red "Failed to complete the operation. Try as administrator."
                call:echo yellow "Log file in: %0/log_error.txt"
            )
        )
    ) else (
        call:echo red "Project location does not exist."
    )
)
goto:END

REM BEGIN METHODS

:checkInstalledDependencies
SETLOCAL
set list=windows-build-tools node-gyp
for %%a in (%list%) do (
    call:checkInstalled %%a
)
ENDLOCAL
goto:eof

:checkInstalled
call:echo cyan "Checking %~1 installed..." %~1
npm ls -g 2^> nul ^| find "%~1" >nul 2>&1 && (
    call:echo green "%~1 installed."
) || (
    call:echo yellow "%~1 not installed by initializing installation..."
    npm install -g %1
)
goto:eof

:getMeteorVersion
for /f %%v in ('node getMeteorVersion.js %meteor_project_path%') do set meteor_version=%%v
echo %meteor_version% | find /i "Error" >nul && (
call:echo red "Error getting a version of Meteor."
goto:END
) || (
call:echo green "Meteor version: %meteor_version%"
call:checkExistPythonInDevTools "C:\Users\%USERNAME%\AppData\Local\.meteor\packages\meteor-tool\%meteor_version%\mt-os.windows.x86_32\dev_bundle\python"
)
goto:eof

:checkExistPythonInDevTools
if exist %1 (
    call:echo green "Python found."
) else (
    call:echo yellow "Python not found, copying to folder..."
    xcopy "C:\Users\%USERNAME%\.windows-build-tools\python27" %1 /s /i /h
)
goto:eof

REM END METHODS

REM BEGIN COMMANDS UTILS

:echo
if exist %Windir%\System32\WindowsPowerShell\v1.0\Powershell.exe (
%Windir%\System32\WindowsPowerShell\v1.0\Powershell.exe write-host -foregroundcolor %1 %2
) else (
echo.%~2
)
goto:eof

:END
pause

REM END COMMANDS UTILS
ENDLOCAL