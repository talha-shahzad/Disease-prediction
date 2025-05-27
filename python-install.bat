@echo off
SETLOCAL ENABLEEXTENSIONS

:: Ensure admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script must be run as administrator.
    pause
    exit /b
)

:: Set curl download URL if needed
SET CURL_URL=https://curl.se/windows/dl-8.7.1_4/curl-8.7.1_4-win64-mingw.zip
SET CURL_ZIP=curl.zip
SET CURL_DIR=%TEMP%\curl_temp

:: Check if curl exists
where curl >nul 2>&1
if %errorlevel% neq 0 (
    echo curl not found. Downloading curl...
    mkdir "%CURL_DIR%"
    powershell -Command "Invoke-WebRequest -Uri %CURL_URL% -OutFile %CURL_ZIP%"
    powershell -Command "Expand-Archive -LiteralPath '%CURL_ZIP%' -DestinationPath '%CURL_DIR%'"
    set "CURL_EXE=%CURL_DIR%\curl-8.7.1_4-win64-mingw\bin\curl.exe"
) else (
    set "CURL_EXE=curl"
)

:: Download Python installer using curl
echo Downloading Python installer...
%CURL_EXE% -o python-installer.exe https://www.python.org/ftp/python/3.12.2/python-3.12.2-amd64.exe

:: Install Python silently
echo Installing Python silently and adding to PATH...
python-installer.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0

echo Waiting for installation to complete...
timeout /t 10 >nul

:: Verify Python installation
echo Verifying Python installation...
where python
python --version
pip --version

:: Clean up
del python-installer.exe >nul 2>&1
if exist %CURL_ZIP% del %CURL_ZIP%
if exist "%CURL_DIR%" rd /s /q "%CURL_DIR%"

echo Python is now installed and added to PATH.
pause
ENDLOCAL
