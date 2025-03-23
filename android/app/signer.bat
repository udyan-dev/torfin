@echo off
REM Set the destination path for the cloned repository - use %USERPROFILE% for Windows
SET REPO_PATH=%USERPROFILE%\AppData\Local\Temp\keystore-repo

REM Remove the existing repository if it exists
IF EXIST "%REPO_PATH%" (
    echo Removing existing repository...
    rmdir /s /q "%REPO_PATH%"
)

REM Create the directory structure
mkdir "%REPO_PATH%"

REM Clone the keystore secrets
echo Cloning the keystore secrets...
git clone git@github.com:udyan-dev/secrets.git "%REPO_PATH%"

REM Check if the repository has the required files
if not exist "%REPO_PATH%\upload-keystore.jks" (
    echo Failed to clone the repository or find the keystore file.
    exit /b 1
)

if not exist "%REPO_PATH%\key.properties" (
    echo Failed to clone the repository or find the key.properties file.
    exit /b 1
)

echo Keystore secrets was setup successfully!