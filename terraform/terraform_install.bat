@echo off
setlocal

:: Check if Terraform is installed
terraform --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Terraform is not installed. Installing using winget...

    :: Check if winget is available
    winget --version >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo Winget is not installed. Please install winget manually and run the script again.
        pause
        exit /b 1
    )

    :: Install Terraform using winget
    winget install HashiCorp.Terraform
    if %ERRORLEVEL% NEQ 0 (
        echo Failed to install Terraform. Exiting...
        pause
        exit /b 1
    )

    echo Terraform installation complete. Restarting the script...
    :: Restart the script after installation
    start cmd /c "%~0"
    exit /b 0
)

:: If Terraform is installed, initialize and apply Terraform
echo Terraform is installed. Running Terraform...
terraform init
terraform apply -auto-approve

pause
