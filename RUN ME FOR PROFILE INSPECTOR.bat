@echo off
setlocal

set "___args="%~f0" %*"
fltmc > nul 2>&1 || (
    echo Administrator privileges are required.
    powershell -c "Start-Process -Verb RunAs -FilePath 'cmd' -ArgumentList """/c $env:___args"""" 2> nul || (
        echo You must run this script as admin.
        if "%*"=="" pause
        exit /b 1
    )
    exit /b
)

set "url=https://raw.githubusercontent.com/RadNotRed/nvidia-profile-inspector-run/main/Nvidia_Profile_Inspector.ps1"
set "script=%TEMP%\Nvidia_Profile_Inspector.ps1"

echo Downloading script to "%script%" ...

curl -L "%url%" -o "%script%"
if errorlevel 1 (
    echo.
    echo Download failed. Please report this and @ @radnotred1
    pause
    exit /b 1
)

echo Download finished.
echo Launching elevated PowerShell

powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process PowerShell -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"\"%script%\"\"'"

echo.
echo If nothing appeared, check for a UAC prompt or errors above
pause

endlocal
