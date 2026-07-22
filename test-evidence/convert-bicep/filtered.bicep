resource kv_iacv_v9r4t 'Microsoft.KeyVault/vaults@2026-03-01-preview' = {
  location: 'eastus2'
  name: 'kv-iacv-v9r4t'
  properties: {
    accessPolicies: [
      {
        objectId: '4b645026-a054-4404-8f64-62929c02052c'
        permissions: {
          certificates: []
          keys: []
          secrets: [
            'Get'
            'List'
            'Set'
            'Delete'
            'Purge'
            'Recover'
          ]
          storage: []
        }
        tenantId: '4f00b3b6-2940-4f2c-b037-94637c180d30'
      }
    ]
    enableRbacAuthorization: false
    enableSoftDelete: true
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    provisioningState: 'Succeeded'
    publicNetworkAccess: 'Enabled'
    sku: {
      family: 'A'
      name: 'standard'
    }
    softDeleteRetentionInDays: 7
    tenantId: '4f00b3b6-2940-4f2c-b037-94637c180d30'
    vaultUri: 'https://kv-iacv-v9r4t.vault.azure.net/'
  }
  tags: {
    environment: 'iacvanillatest'
    owner: 'stema'
    purpose: 'iac-vanilla-livetest'
  }
}

resource vnet_iacv_v9r4t 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  location: 'eastus2'
  name: 'vnet-iacv-v9r4t'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.43.0.0/16'
      ]
    }
    dhcpOptions: {
      dnsServers: []
    }
    enableDdosProtection: false
    privateEndpointVNetPolicies: 'Disabled'
    virtualNetworkPeerings: []
  }
  tags: {
    environment: 'iacvanillatest'
    owner: 'stema'
    purpose: 'iac-vanilla-livetest'
  }
}

resource law_iacv_v9r4t 'Microsoft.OperationalInsights/workspaces@2025-07-01' = {
  location: 'eastus2'
  name: 'law-iacv-v9r4t'
  properties: {
    features: {
      disableLocalAuth: false
      enableLogAccessUsingOnlyResourcePermissions: true
      legacy: 0
      searchVersion: 1
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    retentionInDays: 30
    sku: {
      name: 'PerGB2018'
    }
    workspaceCapping: {
      dailyQuotaGb: json('-1')
    }
  }
  tags: {
    environment: 'iacvanillatest'
    owner: 'stema'
    purpose: 'iac-vanilla-livetest'
  }
}

resource stiacvv9r4t 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  identity: {
    type: 'None'
  }
  kind: 'StorageV2'
  location: 'eastus2'
  name: 'stiacvv9r4t'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowCrossTenantReplication: false
    allowSharedKeyAccess: true
    defaultToOAuthAuthentication: false
    dnsEndpointType: 'Standard'
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Account'
        }
      }
    }
    isHnsEnabled: false
    isLocalUserEnabled: true
    isNfsV3Enabled: false
    isSftpEnabled: false
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
      ipRules: []
      ipv6Rules: []
      resourceAccessRules: []
      virtualNetworkRules: []
    }
    publicNetworkAccess: 'Enabled'
    supportsHttpsTrafficOnly: true
  }
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  tags: {
    environment: 'iacvanillatest'
    owner: 'stema'
    purpose: 'iac-vanilla-livetest'
  }
}

resource kv_iacv_v9r4t_demo_secret 'Microsoft.KeyVault/vaults/secrets@2026-03-01-preview' = {
  parent: kv_iacv_v9r4t
  location: 'eastus2'
  name: 'demo-secret'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vnet_iacv_v9r4t_snet_app 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  parent: vnet_iacv_v9r4t
  name: 'snet-app'
  properties: {
    addressPrefix: '10.43.1.0/24'
    defaultOutboundAccess: true
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    serviceEndpoints: []
  }
}

resource stiacvv9r4t_default 'Microsoft.Storage/storageAccounts/blobServices@2026-04-01' = {
  parent: stiacvv9r4t
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
    staticWebsite: {
      enabled: false
    }
  }
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_stiacvv9r4t_default 'Microsoft.Storage/storageAccounts/fileServices@2026-04-01' = {
  parent: stiacvv9r4t
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
    protocolSettings: {
      smb: {}
    }
    shareDeleteRetentionPolicy: {
      days: 7
      enabled: true
    }
  }
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_stiacvv9r4t_default 'Microsoft.Storage/storageAccounts/queueServices@2026-04-01' = {
  parent: stiacvv9r4t
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_stiacvv9r4t_default 'Microsoft.Storage/storageAccounts/tableServices@2026-04-01' = {
  parent: stiacvv9r4t
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource stiacvv9r4t_default_data 'Microsoft.Storage/storageAccounts/blobServices/containers@2026-04-01' = {
  parent: stiacvv9r4t_default
  name: 'data'
  properties: {
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    immutableStorageWithVersioning: {
      enabled: false
    }
    publicAccess: 'None'
  }
  dependsOn: [
    stiacvv9r4t
  ]
}
