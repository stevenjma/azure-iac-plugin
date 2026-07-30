targetScope = 'resourceGroup'

// PR2 AVM-adopt Bicep lane — brownfield fidelity test via what-if.
// All values sourced from live harvest (.avm/harvest/*.json). Pinned AVM versions.

@description('Azure region of the brownfield resources.')
param location string = 'eastus2'

var tags = {
  environment: 'iacsharedtest'
  owner: 'stema'
  purpose: 'iac-shared-livetest-r1'
}


// ---------------------------------------------------------------------------
// Log Analytics workspace
// ---------------------------------------------------------------------------
module law 'br/public:avm/res/operational-insights/workspace:0.16.0' = {
  name: 'law-adopt'
  params: {
    name: 'law-iacx-s4r1k'
    location: location
    tags: tags
    skuName: 'PerGB2018'
    dataRetention: 30
    forceCmkForQuery: false
    enableTelemetry: false
  }
}

// ---------------------------------------------------------------------------
// Key Vault
// ---------------------------------------------------------------------------
module keyvault 'br/public:avm/res/key-vault/vault:0.14.0' = {
  name: 'kv-adopt'
  params: {
    name: 'kv-iacx-s4r1k'
    location: location
    tags: tags
    sku: 'standard'
    enableRbacAuthorization: false
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    enablePurgeProtection: false
    publicNetworkAccess: 'Enabled'
    networkAcls: null
    enableVaultForDeployment: false
    enableVaultForDiskEncryption: false
    enableVaultForTemplateDeployment: false
    enableTelemetry: false
    accessPolicies: [
      {
        objectId: '4b645026-a054-4404-8f64-62929c02052c'
        permissions: {
          secrets: [
            'get'
            'list'
            'set'
            'delete'
            'purge'
            'recover'
          ]
        }
      }
    ]
  }
}

// ---------------------------------------------------------------------------
// Virtual Network + subnet
// ---------------------------------------------------------------------------
module vnet 'br/public:avm/res/network/virtual-network:0.10.0' = {
  name: 'vnet-adopt'
  params: {
    name: 'vnet-iacx-s4r1k'
    location: location
    tags: tags
    addressPrefixes: [
      '10.44.0.0/16'
    ]
    subnets: [
      {
        name: 'snet-app'
        addressPrefix: '10.44.1.0/24'
        defaultOutboundAccess: true
        privateEndpointNetworkPolicies: 'Disabled'
      }
    ]
    enableTelemetry: false
  }
}

// ---------------------------------------------------------------------------
// Storage account + blob container
// ---------------------------------------------------------------------------
module storage 'br/public:avm/res/storage/storage-account:0.33.0' = {
  name: 'st-adopt'
  params: {
    name: 'stiacxs4r1k'
    location: location
    tags: tags
    kind: 'StorageV2'
    skuName: 'Standard_LRS'
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    publicNetworkAccess: 'Enabled'
    isLocalUserEnabled: true
    allowCrossTenantReplication: false
    requireInfrastructureEncryption: false
    dnsEndpointType: 'Standard'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    blobServices: {
      deleteRetentionPolicyEnabled: false
      containerDeleteRetentionPolicyEnabled: false
      containers: [
        {
          name: 'data'
          publicAccess: 'None'
        }
      ]
    }
    enableTelemetry: false
  }
}
