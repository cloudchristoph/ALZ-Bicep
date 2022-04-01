targetScope = 'subscription'

param parRegion string = 'eastus'
param parRgSuffix string = '01'

resource hubNetworkingRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-core-network-weu-${parRgSuffix}'
  location: parRegion
}

resource privateDnsZoneRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-privatednszones-weu-${parRgSuffix}'
  location: parRegion
}

module hubNetworking '../infra-as-code/bicep/modules/hubNetworking/hubNetworking.bicep' = {
  scope: hubNetworkingRg
  name: 'hubNetworking'
  params: {
    parRegion: parRegion
    parAzureFirewallEnabled: false
    parCompanyPrefix: 'alz'
    parDDoSEnabled: false
    parBastionEnabled: false
    parPrivateDNSZonesEnabled: true
    parPrivateDNSZonesResourceGroup: privateDnsZoneRg.name
    parVpnGatewayConfig: {}
    parExpressRouteGatewayConfig: {}
  }
}
/* 
module privateDnsZones '../infra-as-code/bicep/modules/privateDnsZones/privateDnsZones.bicep' = {
  scope: privateDnsZoneRg
  name: 'privateDnsZones'
  params: {
    parRegion: parRegion
    parHubVirtualNetworkId: hubNetworking.outputs.outHubVirtualNetworkID
  }
}
 */
