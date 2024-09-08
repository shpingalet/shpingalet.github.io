@echo off
setlocal

:: Define the name of the temporary directory for this Terraform run
set temp_dir=%TEMP%\terraform_run_%RANDOM%

:: Create the temporary directory
mkdir %temp_dir%

if not exist %temp_dir% (
    echo Failed to create temporary directory. Exiting...
    pause
    exit /b 1
)

echo Created temporary directory: %temp_dir%

:: Write Terraform configuration to main.tf in the temp directory
echo Writing Terraform configuration to %temp_dir%\main.tf...

echo provider "azuread" { > %temp_dir%\main.tf
echo     tenant_id = "YOUR_TENANT_ID" >> %temp_dir%\main.tf
echo } >> %temp_dir%\main.tf

echo resource "azuread_group" "example" { >> %temp_dir%\main.tf
echo     display_name     = "ExampleGroup" >> %temp_dir%\main.tf
echo     mail_nickname    = "examplegroup" >> %temp_dir%\main.tf
echo     security_enabled = true >> %temp_dir%\main.tf

echo } >> %temp_dir%\main.tf

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

:: Navigate to the temp directory
cd %temp_dir%

:: Initialize and apply Terraform in the temp directory
echo Initializing Terraform in %temp_dir%...
terraform init

if %ERRORLEVEL% NEQ 0 (
    echo Terraform initialization failed. Exiting...
    pause
    exit /b 1
)

echo Applying Terraform in %temp_dir%...
terraform apply

if %ERRORLEVEL% NEQ 0 (
    echo Terraform apply failed. Exiting...
    pause
    exit /b 1
)

:: Cleanup (optional)
echo Would you like to delete the temporary directory? [Y/N]
set /p cleanup=
if /i "%cleanup%" == "Y" (
    rd /s /q %temp_dir%
    echo Temporary directory deleted.
) else (
    echo Temporary directory kept for review: %temp_dir%
)

pause
