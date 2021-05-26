@description('Password for Administrator/SQL Administrator')
@secure()
param password string

resource vnet 'Microsoft.Network/virtualNetworks@2020-07-01' = {
  name: 'vnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'DevelopmentSubnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
          ]
          networkSecurityGroup: {
            id: nsg_development.id
          }
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
  dependsOn: [
    nsg_development
  ]
}

resource nsg_development 'Microsoft.Network/networkSecurityGroups@2019-02-01' = {
  name: 'nsg-development'
  location: resourceGroup().location

  resource rdp 'securityRules@2020-11-01' = {
    name: 'Port_RDP'
    properties: {
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '3389'
      sourceAddressPrefix: '*'
      destinationAddressPrefix: '*'
      access: 'Allow'
      priority: 100
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      sourceAddressPrefixes: []
      destinationAddressPrefixes: []
    }
  }
}

resource vm_development 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: 'vm-development'
  location: resourceGroup().location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D8s_v3'
    }
    storageProfile: {
      osDisk: {
        name: 'vm-development-disk-os'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      imageReference: {
        publisher: 'microsoftvisualstudio'
        offer: 'visualstudio2019latest'
        sku: 'vs-2019-ent-latest-win10-n'
        version: 'latest'
      }
      dataDisks: [
        {
          name: 'vm-development-disk-data'
          lun: 0
          createOption: 'Empty'
          diskSizeGB: 1023
          managedDisk: {
            storageAccountType: 'Premium_LRS'
          }
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vm_development_networkInterface.id
        }
      ]
    }
    osProfile: {
      computerName: 'vm-development'
      adminUsername: 'azureuser'
      adminPassword: password
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
        }
      }
    }
    licenseType: 'Windows_Client'
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }

  dependsOn: [
    vm_development_networkInterface
  ]

  resource vm_dev_script_extension_choco 'extensions@2018-06-01' = {
    name: 'choco'
    location: resourceGroup().location
    properties: {
      publisher: 'Microsoft.Compute'
      type: 'CustomScriptExtension'
      typeHandlerVersion: '1.10'
      autoUpgradeMinorVersion: true
      settings: {
        fileUris: [
          'https://raw.githubusercontent.com/weslbo/development/main/vm-deployment.ps1'
        ]
      }
      protectedSettings: {
        commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File ./vm-deployment.ps1'
      }
    }
  }
}

resource vm_development_networkInterface 'Microsoft.Network/networkInterfaces@2018-10-01' = {
  name: 'vm-development-nic'
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: '${vnet.id}/subnets/DevelopmentSubnet'
          }
          publicIPAddress: {
            id: vm_development_publicIPAddress.id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource vm_development_publicIPAddress 'Microsoft.Network/publicIPAddresses@2020-03-01' = {
  name: 'vm-development-pip'
  location: resourceGroup().location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: 'vm-development'
    }
  }
}

resource vm_development_shutdown_name 'Microsoft.DevTestLab/schedules@2018-09-15' = {
  name: 'shutdown-computevm-${vm_development.name}'
  location: resourceGroup().location
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: '1800'
    }
    timeZoneId: 'Central Europe Standard Time'
    notificationSettings: {
      status: 'Disabled'
      timeInMinutes: 30
    }
    targetResourceId: vm_development.id
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'managed-identity'
  location: resourceGroup().location
}
