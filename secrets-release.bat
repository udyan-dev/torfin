@echo off
setlocal enabledelayedexpansion

REM ========================================
REM Secrets Setup Batch Script
REM Converted from secrets.gradle.kts
REM ========================================

REM Configuration variables
set "repoUrl=git@github.com:udyan-dev/secrets.git"
set "projectDir=%~dp0"
set "projectDir=!projectDir:~0,-1!"
set "androidDir=!projectDir!\android"
for %%i in ("!projectDir!") do set "parentDir=%%~dpi"
set "parentDir=!parentDir:~0,-1!"
set "repoClonePath=!parentDir!\secrets"
set "appDir=!androidDir!\app"
set "libDir=!projectDir!\lib"



echo [INFO] Initializing secrets setup...

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

REM Define file mappings and copy them
call :copySecret "!repoClonePath!\torfin\key.properties" "!androidDir!\key.properties" "key.properties"
call :copySecret "!repoClonePath!\torfin\google-services.json" "!appDir!\google-services.json" "google-services.json"
call :copySecret "!repoClonePath!\torfin\upload-keystore.jks" "!projectDir!\upload-keystore.jks" "upload-keystore.jks"
call :copySecret "!repoClonePath!\torfin\firebase_options.dart" "!libDir!\firebase_options.dart" "firebase_options.dart"
call :copySecret "!repoClonePath!\torfin\secrets.env" "!projectDir!\secrets.env" "secrets.env"
call :copySecret "!repoClonePath!\torfin\firebase.json" "!projectDir!\firebase.json" "firebase.json"

echo [SUCCESS] Secrets setup complete.
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
