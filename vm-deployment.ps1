# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Software
choco install visualstudiocode -y
choco install git -y 
choco install nodejs-lts -y
choco install notepadplusplus -y
choco install azure-cli -y
choco install microsoftazurestorageexplorer -y
choco install azurepowershell -y
choco install azcopy -y
choco install sql-server-management-studio -y
choco install cosmosdbexplorer -y
choco install servicebusexplorer -y
choco install freshbing -y
choco install microsoft-windows-terminal --pre -y
choco install docker-desktop -y
choco install wsl2 -y
choco install wsl-ubuntu-2004 -y
choco install powerbi -y
choco install daxstudio -y
choco install fiddler -y
choco install irfanview -y
choco install irfanviewplugins -y
choco install postman -y
choco install speedtest -y
choco install ojdkbuild11 -y
choco install maven -y
choco install golang -y
choco install python -y
choco install azure-functions-core-tools-3 -y
choco install vcredist-all -y
choco install sqlserver-odbcdriver -y
choco install msoidcli -y
choco install bicep -y

code --install-extension eg2.vscode-npm-script --force
code --install-extension hashicorp.terraform --force
code --install-extension ms-azure-devops.azure-pipelines --force
code --install-extension ms-azuretools.vscode-azureappservice --force
code --install-extension ms-azuretools.vscode-azurefunctions --force
code --install-extension ms-azuretools.vscode-azureterraform --force
code --install-extension ms-azuretools.vscode-docker --force
code --install-extension ms-dotnettools.csharp --force
code --install-extension ms-dotnettools.vscode-dotnet-runtime --force
code --install-extension ms-vscode-remote.remote-wsl --force
code --install-extension ms-vscode.azure-account --force
code --install-extension ms-vscode.azurecli --force
code --install-extension ms-vscode.powershell --force
code --install-extension ms-vsonline.vsonline --force
code --install-extension msazurermtools.azurerm-vscode-tools --force
code --install-extension pjmiravalle.terraform-advanced-syntax-highlighting --force
code --install-extension redhat.vscode-yaml --force
code --install-extension visualstudioonlineapplicationinsights.application-insights --force
code --install-extension thiagolciobittencourt.ubuntuvscode --force
code --install-extension vscjava.vscode-java-pack --force
code --install-extension golang.Go --force
code --install-extension ms-python.python --force

npm install -g artillery
net localgroup docker-users azureuser /add