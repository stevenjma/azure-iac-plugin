resource kv_iacx_p1x7q 'Microsoft.KeyVault/vaults@2026-03-01-preview' = {
  name: 'kv-iacx-p1x7q'
  location: 'eastus2'
  tags: {
    environment: 'iacexporttest'
    owner: 'iac-demo'
    purpose: 'iac-export-livetest'
  }
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: '11111111-1111-1111-1111-111111111111'
    accessPolicies: [
      {
        tenantId: '11111111-1111-1111-1111-111111111111'
        objectId: '00000000-0000-0000-0000-000000000200'
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
      }
    ]
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    enableRbacAuthorization: false
    vaultUri: 'https://kv-iacx-p1x7q.vault.azure.net/'
    provisioningState: 'Succeeded'
    publicNetworkAccess: 'Enabled'
  }
}

resource vnet_iacx_p1x7q 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: 'vnet-iacx-p1x7q'
  location: 'eastus2'
  tags: {
    environment: 'iacexporttest'
    owner: 'iac-demo'
    purpose: 'iac-export-livetest'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.43.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    dhcpOptions: {
      dnsServers: []
    }
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource law_iacx_p1x7q 'Microsoft.OperationalInsights/workspaces@2025-07-01' = {
  name: 'law-iacx-p1x7q'
  location: 'eastus2'
  tags: {
    environment: 'iacexporttest'
    owner: 'iac-demo'
    purpose: 'iac-export-livetest'
  }
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      legacy: 0
      searchVersion: 1
      enableLogAccessUsingOnlyResourcePermissions: true
      disableLocalAuth: false
    }
    workspaceCapping: {
      dailyQuotaGb: json('-1')
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource stiacxp1x7q 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: 'stiacxp1x7q'
  location: 'eastus2'
  tags: {
    environment: 'iacexporttest'
    owner: 'iac-demo'
    purpose: 'iac-export-livetest'
  }
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  identity: {
    type: 'None'
  }
  properties: {
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: false
    isNfsV3Enabled: false
    isLocalUserEnabled: true
    isSftpEnabled: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    isHnsEnabled: false
    networkAcls: {
      ipv6Rules: []
      resourceAccessRules: []
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource kv_iacx_p1x7q_demo_secret 'Microsoft.KeyVault/vaults/secrets@2026-03-01-preview' = {
  parent: kv_iacx_p1x7q
  name: 'demo-secret'
  location: 'eastus2'
  properties: {
    attributes: {
      enabled: true
    }
  }
}

resource vnet_iacx_p1x7q_snet_app 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  parent: vnet_iacx_p1x7q
  name: 'snet-app'
  properties: {
    addressPrefix: '10.43.1.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: true
  }
}

resource stiacxp1x7q_default 'Microsoft.Storage/storageAccounts/blobServices@2026-04-01' = {
  parent: stiacxp1x7q
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    staticWebsite: {
      enabled: false
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
  }
}

resource stiacxp1x7q_default_data 'Microsoft.Storage/storageAccounts/blobServices/containers@2026-04-01' = {
  parent: stiacxp1x7q_default
  name: 'data'
  properties: {
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    stiacxp1x7q
  ]
}
