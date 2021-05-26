# Development template

This template deploys a Visual Studio Development machine (visualstudio2019latest) with additional tools installed on top of it.

```bash
az group create --name rg-development --location westeurope
az deployment group create --template-uri https://raw.githubusercontent.com/weslbo/development/main/azuredeploy.bicep --resource-group rg-development --parameters password=demo!pass123 
```

Following additional tools are installed (with Chocolatey):

- visualstudiocode
- git 
- nodejs-lts
- notepadplusplus
- azure-cli
- microsoftazurestorageexplorer
- azurepowershell
- azcopy
- sql-server-management-studio
- cosmosdbexplorer
- servicebusexplorer
- freshbing
- microsoft-windows-terminal --pre
- docker-desktop
- wsl2
- wsl-ubuntu-2004
- powerbi
- daxstudio
- fiddler
- irfanview
- irfanviewplugins
- postman
- speedtest
- ojdkbuild11
- maven
- golang
- python
- azure-functions-core-tools-3
- vcredist-all
- sqlserver-odbcdriver
- msoidcli
- bicep