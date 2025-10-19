@echo off
setlocal enabledelayedexpansion

REM ========================================
REM Secrets Dev Setup Batch Script
REM Clones from torfin-secrets repository
REM ========================================

REM Configuration variables
set "repoUrl=https://github.com/udyan-dev/torfin-secrets.git"
set "projectDir=%~dp0"
set "projectDir=!projectDir:~0,-1!"
set "androidDir=!projectDir!\android"
for %%i in ("!projectDir!") do set "parentDir=%%~dpi"
set "parentDir=!parentDir:~0,-1!"
set "repoClonePath=!parentDir!\torfin-secrets"
set "appDir=!androidDir!\app"
set "libDir=!projectDir!\lib"

echo [INFO] Initializing secrets dev setup...

REM Remove old clone if it exists
if exist "!repoClonePath!" (
    echo [INFO] Removing old clone: !repoClonePath!
    rmdir /s /q "!repoClonePath!"
)

REM Clone the repository
echo [INFO] Cloning from !repoUrl!
git clone "!repoUrl!" "!repoClonePath!" 2>&1
if !errorlevel! neq 0 (
    echo [ERROR] Git clone failed with exit code !errorlevel!
    exit /b !errorlevel!
)

echo [INFO] Copying secret files...

REM Define file mappings and copy them (files are directly in repo root)
call :copySecret "!repoClonePath!\google-services.json" "!appDir!\google-services.json" "google-services.json"
call :copySecret "!repoClonePath!\firebase_options.dart" "!libDir!\firebase_options.dart" "firebase_options.dart"
call :copySecret "!repoClonePath!\secrets.env" "!projectDir!\secrets.env" "secrets.env"
call :copySecret "!repoClonePath!\firebase.json" "!projectDir!\firebase.json" "firebase.json"

echo [SUCCESS] Secrets dev setup complete.
goto :eof

REM Function to copy a secret file
:copySecret
set "src=%~1"
set "dest=%~2"
set "label=%~3"

if not exist "!src!" (
    echo [ERROR] Missing !label!: !src!
    exit /b 1
)

copy /Y "!src!" "!dest!" >nul 2>&1
if !errorlevel! equ 0 (
    echo [SUCCESS] !label! copied to !dest!
) else (
    echo [ERROR] Failed to copy !label! to !dest!
    echo [DEBUG] Source: !src!
    echo [DEBUG] Destination: !dest!
    exit /b 1
)
goto :eof
