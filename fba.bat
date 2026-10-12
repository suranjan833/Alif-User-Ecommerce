@echo off
setlocal EnableExtensions
chcp 65001 >nul
title Flutter APK Builder

REM ==========================================
REM Flutter APK Builder for Windows
REM ==========================================

REM Use current folder name
for %%I in ("%CD%") do set "PROJECT=%%~nxI"

REM Telegram configuration
REM Set TELEGRAM_BOT_TOKEN in your environment
set "CHAT_ID=-5197747250"
set "BOT_TOKEN=8315195425:AAGHv8s-amgSAN9DRsoERsrWpND9t0bNjoA"

REM ==========================================
REM Ask options FIRST
REM ==========================================

echo.
echo [BUILD OPTIONS]
echo ----------------------------------------

set "OPEN_EXPLORER=N"
set "SEND_TG=Y"

set /p "OPEN_EXPLORER=Open APK folder in File Explorer after build? (y/N): "
if not defined OPEN_EXPLORER set "OPEN_EXPLORER=N"

set /p "SEND_TG=Send APK to Telegram after build? (Y/n): "
if not defined SEND_TG set "SEND_TG=Y"

REM ==========================================
REM Build information
REM ==========================================

set "BUILD_VERSION=no-git"

where git >nul 2>&1
if not errorlevel 1 (
    for /f "delims=" %%V in ('git describe --tags --always 2^>nul') do (
        set "BUILD_VERSION=%%V"
    )
)

if not defined BUILD_VERSION set "BUILD_VERSION=no-git"

REM Generate timestamps
for /f "delims=" %%T in ('powershell -NoProfile -Command "Get-Date -Format 'yyyy-MM-dd hh:mm:ss tt'"') do set "BUILD_TIME=%%T"

for /f "delims=" %%T in ('powershell -NoProfile -Command "Get-Date -Format 'yyyyMMdd_hhmmss_tt'"') do set "FILE_TIME=%%T"

echo.
echo Building APK for %PROJECT%...
echo Version: %BUILD_VERSION%
echo Time: %BUILD_TIME%
echo.

REM ==========================================
REM Flutter build
REM ==========================================

call flutter build apk ^
    --release ^
    --split-per-abi ^
    --tree-shake-icons ^
    --obfuscate ^
    --split-debug-info=build/debug-info ^
    "--dart-define=BUILD_VERSION=%BUILD_VERSION%" ^
    "--dart-define=BUILD_TIME=%BUILD_TIME%"

if errorlevel 1 (
    echo.
    echo ERROR: Flutter build failed.
    pause
    exit /b 1
)

REM ==========================================
REM APK paths
REM ==========================================

set "APK_DIR=build\app\outputs\flutter-apk"
set "ORIGINAL_APK=%APK_DIR%\app-arm64-v8a-release.apk"
set "CUSTOM_APK_NAME=%PROJECT%_%BUILD_VERSION%_%FILE_TIME%_arm64.apk"
set "CUSTOM_APK_PATH=%APK_DIR%\%CUSTOM_APK_NAME%"

if not exist "%ORIGINAL_APK%" (
    echo.
    echo ERROR: ARM64 APK not found:
    echo %ORIGINAL_APK%
    pause
    exit /b 1
)

REM ==========================================
REM Copy and rename APK
REM ==========================================

copy /Y "%ORIGINAL_APK%" "%CUSTOM_APK_PATH%" >nul

if errorlevel 1 (
    echo ERROR: Failed to copy APK.
    pause
    exit /b 1
)

echo.
echo APK created successfully:
echo %CUSTOM_APK_PATH%

REM ==========================================
REM Open File Explorer
REM ==========================================

if /I "%OPEN_EXPLORER%"=="Y" (
    echo Opening File Explorer...
    start "" "%CD%\%APK_DIR%"
)

REM ==========================================
REM Telegram upload
REM Compatible with PowerShell 5.1 and 7
REM ==========================================

if /I "%SEND_TG%"=="N" goto SKIP_TELEGRAM

if not defined BOT_TOKEN (
    echo.
    echo ERROR: TELEGRAM_BOT_TOKEN is not set.
    echo Set your new token in PowerShell:
    echo $env:TELEGRAM_BOT_TOKEN = "YOUR_NEW_BOT_TOKEN"
    pause
    exit /b 1
)

echo.
echo Uploading APK to Telegram...

REM Pass variables through environment variables
set "UPLOAD_FILE=%CD%\%CUSTOM_APK_PATH%"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$ErrorActionPreference = 'Stop';" ^
 "$file = $env:UPLOAD_FILE;" ^
 "$token = $env:BOT_TOKEN;" ^
 "$chat = $env:CHAT_ID;" ^
 "$project = $env:PROJECT;" ^
 "$version = $env:BUILD_VERSION;" ^
 "$buildTime = $env:BUILD_TIME;" ^
 "$boundary = [Guid]::NewGuid().ToString();" ^
 "$nl = [char]13 + [char]10;" ^
 "$ms = New-Object System.IO.MemoryStream;" ^
 "$enc = New-Object System.Text.UTF8Encoding($false);" ^
 "try {" ^
 "  if (-not (Test-Path -LiteralPath $file -PathType Leaf)) { throw 'APK file not found.' };" ^
 "  $caption = \"🚀 $project`n`nNew Build Available`n`n📦 Version: $version`n⏰ Time: $buildTime`n📱 ABI: arm64-v8a\";" ^
 "  foreach ($f in @(@{N='chat_id';V=$chat},@{N='caption';V=$caption})) {" ^
 "    $h = '--' + $boundary + $nl + 'Content-Disposition: form-data; name=\"' + $f.N + '\"' + $nl + $nl;" ^
 "    $b = $enc.GetBytes($h + $f.V + $nl);" ^
 "    $ms.Write($b,0,$b.Length);" ^
 "  };" ^
 "  $name = [IO.Path]::GetFileName($file);" ^
 "  $h = '--' + $boundary + $nl + 'Content-Disposition: form-data; name=\"document\"; filename=\"' + $name + '\"' + $nl + 'Content-Type: application/vnd.android.package-archive' + $nl + $nl;" ^
 "  $b = $enc.GetBytes($h);" ^
 "  $ms.Write($b,0,$b.Length);" ^
 "  $b = [IO.File]::ReadAllBytes($file);" ^
 "  $ms.Write($b,0,$b.Length);" ^
 "  $b = $enc.GetBytes($nl + '--' + $boundary + '--' + $nl);" ^
 "  $ms.Write($b,0,$b.Length);" ^
 "  $body = $ms.ToArray();" ^
 "  $url = 'https://api.telegram.org/bot' + $token + '/sendDocument';" ^
 "  $r = Invoke-RestMethod -Uri $url -Method Post -ContentType ('multipart/form-data; boundary=' + $boundary) -Body $body;" ^
 "  if (-not $r.ok) { throw $r.description };" ^
 "  Write-Host 'APK sent successfully to Telegram!' -ForegroundColor Green;" ^
 "} catch {" ^
 "  Write-Host ('Telegram upload failed: ' + $_.Exception.Message) -ForegroundColor Red;" ^
 "  exit 1;" ^
 "} finally { $ms.Dispose() }"

if errorlevel 1 (
    echo.
    echo ERROR: Telegram upload failed.
    pause
    exit /b 1
)

goto FINISH

REM ==========================================
REM Skip Telegram
REM ==========================================

:SKIP_TELEGRAM
echo Telegram upload skipped.

REM ==========================================
REM Finished
REM ==========================================

:FINISH
echo.
echo Build process completed!
echo Output: %CUSTOM_APK_PATH%
echo.

pause
endlocal