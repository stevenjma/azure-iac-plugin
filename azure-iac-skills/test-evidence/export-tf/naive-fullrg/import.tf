import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.KeyVault/vaults/kv-iacx-p1x7q"
  to = azurerm_key_vault.res-1
}
import {
  id = "https://kv-iacx-p1x7q.vault.azure.net/secrets/demo-secret/610a627e918f46b7ab3830e9e604d8c4"
  to = azurerm_key_vault_secret.res-2
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.Network/virtualNetworks/vnet-iacx-p1x7q"
  to = azurerm_virtual_network.res-3
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.Network/virtualNetworks/vnet-iacx-p1x7q/subnets/snet-app"
  to = azurerm_subnet.res-4
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q"
  to = azurerm_log_analytics_workspace.res-5
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_General|AlphabeticallySortedComputers"
  to = azurerm_log_analytics_saved_search.res-6
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_General|StaleComputers"
  to = azurerm_log_analytics_saved_search.res-7
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_General|dataPointsPerManagementGroup"
  to = azurerm_log_analytics_saved_search.res-8
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_General|dataTypeDistribution"
  to = azurerm_log_analytics_saved_search.res-9
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|AllEvents"
  to = azurerm_log_analytics_saved_search.res-10
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|AllSyslog"
  to = azurerm_log_analytics_saved_search.res-11
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|AllSyslogByFacility"
  to = azurerm_log_analytics_saved_search.res-12
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|AllSyslogByProcessName"
  to = azurerm_log_analytics_saved_search.res-13
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|AllSyslogsWithErrors"
  to = azurerm_log_analytics_saved_search.res-14
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|AverageHTTPRequestTimeByClientIPAddress"
  to = azurerm_log_analytics_saved_search.res-15
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|AverageHTTPRequestTimeHTTPMethod"
  to = azurerm_log_analytics_saved_search.res-16
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|CountIISLogEntriesClientIPAddress"
  to = azurerm_log_analytics_saved_search.res-17
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|CountIISLogEntriesHTTPRequestMethod"
  to = azurerm_log_analytics_saved_search.res-18
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|CountIISLogEntriesHTTPUserAgent"
  to = azurerm_log_analytics_saved_search.res-19
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|CountOfIISLogEntriesByHostRequestedByClient"
  to = azurerm_log_analytics_saved_search.res-20
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|CountOfIISLogEntriesByURLForHost"
  to = azurerm_log_analytics_saved_search.res-21
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|CountOfIISLogEntriesByURLRequestedByClient"
  to = azurerm_log_analytics_saved_search.res-22
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|CountOfWarningEvents"
  to = azurerm_log_analytics_saved_search.res-23
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|DisplayBreakdownRespondCodes"
  to = azurerm_log_analytics_saved_search.res-24
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|EventsByEventLog"
  to = azurerm_log_analytics_saved_search.res-25
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|EventsByEventSource"
  to = azurerm_log_analytics_saved_search.res-26
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|EventsByEventsID"
  to = azurerm_log_analytics_saved_search.res-27
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|EventsInOMBetween2000to3000"
  to = azurerm_log_analytics_saved_search.res-28
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|EventsWithStartedinEventID"
  to = azurerm_log_analytics_saved_search.res-29
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|FindMaximumTimeTakenForEachPage"
  to = azurerm_log_analytics_saved_search.res-30
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|IISLogEntriesForClientIP"
  to = azurerm_log_analytics_saved_search.res-31
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|ListAllIISLogEntries"
  to = azurerm_log_analytics_saved_search.res-32
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|NoOfConnectionsToOMSDKService"
  to = azurerm_log_analytics_saved_search.res-33
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|ServerRestartTime"
  to = azurerm_log_analytics_saved_search.res-34
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|Show404PagesList"
  to = azurerm_log_analytics_saved_search.res-35
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|ShowServersThrowingInternalServerError"
  to = azurerm_log_analytics_saved_search.res-36
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|TotalBytesReceivedByEachAzureRoleInstance"
  to = azurerm_log_analytics_saved_search.res-37
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|TotalBytesReceivedByEachIISComputer"
  to = azurerm_log_analytics_saved_search.res-38
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|TotalBytesRespondedToClientsByClientIPAddress"
  to = azurerm_log_analytics_saved_search.res-39
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|TotalBytesRespondedToClientsByEachIISServerIPAddress"
  to = azurerm_log_analytics_saved_search.res-40
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|TotalBytesSentByClientIPAddress"
  to = azurerm_log_analytics_saved_search.res-41
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|WarningEvents"
  to = azurerm_log_analytics_saved_search.res-42
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|WindowsFireawallPolicySettingsChanged"
  to = azurerm_log_analytics_saved_search.res-43
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/savedSearches/LogManagement(law-iacx-p1x7q)_LogManagement|WindowsFireawallPolicySettingsChangedByMachines"
  to = azurerm_log_analytics_saved_search.res-44
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AACAudit"
  to = azurerm_log_analytics_workspace_table_custom_log.res-45
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AACHttpRequest"
  to = azurerm_log_analytics_workspace_table_custom_log.res-46
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADAgentRiskEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-47
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADB2CRequestLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-48
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADCustomSecurityAttributeAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-49
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADDomainServicesAccountLogon"
  to = azurerm_log_analytics_workspace_table_custom_log.res-50
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADDomainServicesAccountManagement"
  to = azurerm_log_analytics_workspace_table_custom_log.res-51
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADDomainServicesDNSAuditsDynamicUpdates"
  to = azurerm_log_analytics_workspace_table_custom_log.res-52
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADDomainServicesDNSAuditsGeneral"
  to = azurerm_log_analytics_workspace_table_custom_log.res-53
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADDomainServicesDirectoryServiceAccess"
  to = azurerm_log_analytics_workspace_table_custom_log.res-54
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADDomainServicesLogonLogoff"
  to = azurerm_log_analytics_workspace_table_custom_log.res-55
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADDomainServicesPolicyChange"
  to = azurerm_log_analytics_workspace_table_custom_log.res-56
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADDomainServicesPrivilegeUse"
  to = azurerm_log_analytics_workspace_table_custom_log.res-57
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADDomainServicesSystemSecurity"
  to = azurerm_log_analytics_workspace_table_custom_log.res-58
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADFirstPartyToFirstPartySignInLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-59
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADGraphActivityLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-60
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADManagedIdentitySignInLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-61
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADNonInteractiveUserSignInLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-62
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADProvisioningLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-63
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADRiskyAgents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-64
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADRiskyServicePrincipals"
  to = azurerm_log_analytics_workspace_table_custom_log.res-65
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADRiskyUsers"
  to = azurerm_log_analytics_workspace_table_custom_log.res-66
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADServicePrincipalRiskEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-67
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADServicePrincipalSignInLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-68
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AADUserRiskEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-69
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ABSBotRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-70
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACICollaborationAudit"
  to = azurerm_log_analytics_workspace_table_custom_log.res-71
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACLTransactionLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-72
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACLUserDefinedLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-73
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACRConnectedClientList"
  to = azurerm_log_analytics_workspace_table_custom_log.res-74
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACREntraAuthenticationAuditLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-75
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSAdvancedMessagingOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-76
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSAuthIncomingOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-77
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSBillingUsage"
  to = azurerm_log_analytics_workspace_table_custom_log.res-78
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSCallAutomationIncomingOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-79
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSCallAutomationMediaSummary"
  to = azurerm_log_analytics_workspace_table_custom_log.res-80
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSCallAutomationStreamingUsage"
  to = azurerm_log_analytics_workspace_table_custom_log.res-81
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSCallClientMediaStatsTimeSeries"
  to = azurerm_log_analytics_workspace_table_custom_log.res-82
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSCallClientOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-83
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSCallClientServiceRequestAndOutcome"
  to = azurerm_log_analytics_workspace_table_custom_log.res-84
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSCallClosedCaptionsSummary"
  to = azurerm_log_analytics_workspace_table_custom_log.res-85
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSCallDiagnostics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-86
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSCallDiagnosticsUpdates"
  to = azurerm_log_analytics_workspace_table_custom_log.res-87
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSCallRecordingIncomingOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-88
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSCallRecordingSummary"
  to = azurerm_log_analytics_workspace_table_custom_log.res-89
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSCallSummary"
  to = azurerm_log_analytics_workspace_table_custom_log.res-90
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSCallSummaryUpdates"
  to = azurerm_log_analytics_workspace_table_custom_log.res-91
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSCallSurvey"
  to = azurerm_log_analytics_workspace_table_custom_log.res-92
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSCallingMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-93
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSChatIncomingOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-94
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSEmailSendMailOperational"
  to = azurerm_log_analytics_workspace_table_custom_log.res-95
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSEmailStatusUpdateOperational"
  to = azurerm_log_analytics_workspace_table_custom_log.res-96
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSEmailUserEngagementOperational"
  to = azurerm_log_analytics_workspace_table_custom_log.res-97
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSJobRouterIncomingOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-98
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSOptOutManagementOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-99
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSRoomsIncomingOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-100
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ACSSMSIncomingOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-101
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-102
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADFActivityRun"
  to = azurerm_log_analytics_workspace_table_custom_log.res-103
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADFAirflowSchedulerLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-104
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADFAirflowTaskLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-105
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADFAirflowWebLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-106
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADFAirflowWorkerLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-107
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADFPipelineRun"
  to = azurerm_log_analytics_workspace_table_custom_log.res-108
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADFSSISIntegrationRuntimeLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-109
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADFSSISPackageEventMessageContext"
  to = azurerm_log_analytics_workspace_table_custom_log.res-110
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADFSSISPackageEventMessages"
  to = azurerm_log_analytics_workspace_table_custom_log.res-111
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADFSSISPackageExecutableStatistics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-112
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADFSSISPackageExecutionComponentPhases"
  to = azurerm_log_analytics_workspace_table_custom_log.res-113
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADFSSISPackageExecutionDataStatistics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-114
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADFSSignInLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-115
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADFSandboxActivityRun"
  to = azurerm_log_analytics_workspace_table_custom_log.res-116
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADFSandboxPipelineRun"
  to = azurerm_log_analytics_workspace_table_custom_log.res-117
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADFTriggerRun"
  to = azurerm_log_analytics_workspace_table_custom_log.res-118
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADGSyslogEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-119
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADReplicationResult"
  to = azurerm_log_analytics_workspace_table_custom_log.res-120
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADSecurityAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-121
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADTDataHistoryOperation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-122
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADTDigitalTwinsOperation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-123
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADTEventRoutesOperation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-124
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADTModelsOperation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-125
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADTQueryOperation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-126
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADXCommand"
  to = azurerm_log_analytics_workspace_table_custom_log.res-127
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADXDataOperation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-128
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADXIngestionBatching"
  to = azurerm_log_analytics_workspace_table_custom_log.res-129
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADXJournal"
  to = azurerm_log_analytics_workspace_table_custom_log.res-130
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADXQuery"
  to = azurerm_log_analytics_workspace_table_custom_log.res-131
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADXTableDetails"
  to = azurerm_log_analytics_workspace_table_custom_log.res-132
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ADXTableUsageStatistics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-133
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AEWAssignmentBlobLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-134
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AEWAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-135
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AEWComputePipelinesLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-136
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AEWExperimentAssignmentSummary"
  to = azurerm_log_analytics_workspace_table_custom_log.res-137
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AEWExperimentScorecardMetricPairs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-138
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AEWExperimentScorecards"
  to = azurerm_log_analytics_workspace_table_custom_log.res-139
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AFSAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-140
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AGCAccessLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-141
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AGCFirewallLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-142
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AGSGrafanaLoginEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-143
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AGSGrafanaUsageInsightsEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-144
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AGSUpdateEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-145
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AGWAccessLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-146
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AGWFirewallLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-147
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AGWPerformanceLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-148
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AHCIDiagnosticLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-149
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AHDSDeidAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-150
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AHDSDicomAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-151
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AHDSDicomDiagnosticLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-152
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AHDSMedTechDiagnosticLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-153
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AKSAudit"
  to = azurerm_log_analytics_workspace_table_custom_log.res-154
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AKSAuditAdmin"
  to = azurerm_log_analytics_workspace_table_custom_log.res-155
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AKSControlPlane"
  to = azurerm_log_analytics_workspace_table_custom_log.res-156
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ALBHealthEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-157
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AMAHealth"
  to = azurerm_log_analytics_workspace_table_custom_log.res-158
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AMSKeyDeliveryRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-159
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AMSLiveEventOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-160
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AMSMediaAccountHealth"
  to = azurerm_log_analytics_workspace_table_custom_log.res-161
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AMSStreamingEndpointRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-162
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AMWMetricsUsageDetails"
  to = azurerm_log_analytics_workspace_table_custom_log.res-163
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ANFFileAccess"
  to = azurerm_log_analytics_workspace_table_custom_log.res-164
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ANFTopClientReadIOPS"
  to = azurerm_log_analytics_workspace_table_custom_log.res-165
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ANFTopClientWriteIOPS"
  to = azurerm_log_analytics_workspace_table_custom_log.res-166
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ANFTopFileReadIOPS"
  to = azurerm_log_analytics_workspace_table_custom_log.res-167
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ANFTopFileWriteIOPS"
  to = azurerm_log_analytics_workspace_table_custom_log.res-168
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AOIDatabaseQuery"
  to = azurerm_log_analytics_workspace_table_custom_log.res-169
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AOIDigestion"
  to = azurerm_log_analytics_workspace_table_custom_log.res-170
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AOIStorage"
  to = azurerm_log_analytics_workspace_table_custom_log.res-171
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/APIMDevPortalAuditDiagnosticLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-172
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ASCAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-173
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ASCDeviceEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-174
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ASRJobs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-175
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ASRReplicatedItems"
  to = azurerm_log_analytics_workspace_table_custom_log.res-176
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ASRv2HealthEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-177
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ASRv2JobEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-178
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ASRv2ProtectedItems"
  to = azurerm_log_analytics_workspace_table_custom_log.res-179
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ASRv2ReplicationExtensions"
  to = azurerm_log_analytics_workspace_table_custom_log.res-180
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ASRv2ReplicationPolicies"
  to = azurerm_log_analytics_workspace_table_custom_log.res-181
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ASRv2ReplicationVaults"
  to = azurerm_log_analytics_workspace_table_custom_log.res-182
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ATCExpressRouteCircuitIpfix"
  to = azurerm_log_analytics_workspace_table_custom_log.res-183
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ATCMicrosoftPeeringMetadata"
  to = azurerm_log_analytics_workspace_table_custom_log.res-184
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ATCPrivatePeeringMetadata"
  to = azurerm_log_analytics_workspace_table_custom_log.res-185
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AVNMConnectivityConfigurationChange"
  to = azurerm_log_analytics_workspace_table_custom_log.res-186
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AVNMIPAMPoolAllocationChange"
  to = azurerm_log_analytics_workspace_table_custom_log.res-187
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AVNMNetworkGroupMembershipChange"
  to = azurerm_log_analytics_workspace_table_custom_log.res-188
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AVNMRuleCollectionChange"
  to = azurerm_log_analytics_workspace_table_custom_log.res-189
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AVSEsxiFirewallSyslog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-190
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AVSEsxiSyslog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-191
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AVSNsxEdgeSyslog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-192
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AVSNsxManagerSyslog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-193
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AVSSyslog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-194
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AVSVcSyslog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-195
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZFWApplicationRule"
  to = azurerm_log_analytics_workspace_table_custom_log.res-196
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZFWApplicationRuleAggregation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-197
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZFWDnsFlowTrace"
  to = azurerm_log_analytics_workspace_table_custom_log.res-198
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZFWDnsQuery"
  to = azurerm_log_analytics_workspace_table_custom_log.res-199
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZFWFatFlow"
  to = azurerm_log_analytics_workspace_table_custom_log.res-200
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZFWFlowTrace"
  to = azurerm_log_analytics_workspace_table_custom_log.res-201
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZFWIdpsSignature"
  to = azurerm_log_analytics_workspace_table_custom_log.res-202
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZFWInternalFqdnResolutionFailure"
  to = azurerm_log_analytics_workspace_table_custom_log.res-203
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZFWNatRule"
  to = azurerm_log_analytics_workspace_table_custom_log.res-204
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZFWNatRuleAggregation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-205
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZFWNetworkRule"
  to = azurerm_log_analytics_workspace_table_custom_log.res-206
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZFWNetworkRuleAggregation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-207
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZFWThreatIntel"
  to = azurerm_log_analytics_workspace_table_custom_log.res-208
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZKVAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-209
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZKVPolicyEvaluationDetailsLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-210
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZMSApplicationMetricLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-211
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZMSArchiveLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-212
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZMSAutoscaleLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-213
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZMSCustomerManagedKeyUserLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-214
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZMSDiagnosticErrorLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-215
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZMSHybridConnectionsEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-216
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZMSKafkaCoordinatorLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-217
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZMSKafkaUserErrorLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-218
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZMSOperationalLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-219
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZMSRunTimeAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-220
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AZMSVnetConnectionEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-221
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AddonAzureBackupAlerts"
  to = azurerm_log_analytics_workspace_table_custom_log.res-222
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AddonAzureBackupJobs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-223
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AddonAzureBackupPolicy"
  to = azurerm_log_analytics_workspace_table_custom_log.res-224
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AddonAzureBackupProtectedInstance"
  to = azurerm_log_analytics_workspace_table_custom_log.res-225
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AddonAzureBackupStorage"
  to = azurerm_log_analytics_workspace_table_custom_log.res-226
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AegDataPlaneRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-227
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AegDeliveryFailureLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-228
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AegPublishFailureLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-229
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AgriFoodApplicationAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-230
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AgriFoodFarmManagementLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-231
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AgriFoodFarmOperationLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-232
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AgriFoodInsightLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-233
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AgriFoodJobProcessedLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-234
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AgriFoodModelInferenceLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-235
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AgriFoodProviderAuthLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-236
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AgriFoodSatelliteLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-237
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AgriFoodSensorManagementLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-238
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AgriFoodWeatherLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-239
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AirflowDagProcessingLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-240
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/Alert"
  to = azurerm_log_analytics_workspace_table_custom_log.res-241
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AmlComputeClusterEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-242
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AmlComputeClusterNodeEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-243
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AmlComputeCpuGpuUtilization"
  to = azurerm_log_analytics_workspace_table_custom_log.res-244
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AmlComputeInstanceEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-245
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AmlComputeJobEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-246
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AmlDataLabelEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-247
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AmlDataSetEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-248
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AmlDataStoreEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-249
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AmlDeploymentEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-250
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AmlEnvironmentEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-251
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AmlInferencingEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-252
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AmlModelsEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-253
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AmlOnlineEndpointConsoleLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-254
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AmlOnlineEndpointEventLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-255
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AmlOnlineEndpointTrafficLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-256
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AmlPipelineEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-257
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AmlRegistryReadEventsLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-258
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AmlRegistryWriteEventsLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-259
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AmlRunEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-260
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AmlRunStatusChangedEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-261
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ApiManagementGatewayLlmLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-262
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ApiManagementGatewayLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-263
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ApiManagementGatewayMCPLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-264
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ApiManagementWebSocketConnectionLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-265
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppAvailabilityResults"
  to = azurerm_log_analytics_workspace_table_custom_log.res-266
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppBrowserTimings"
  to = azurerm_log_analytics_workspace_table_custom_log.res-267
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppCenterError"
  to = azurerm_log_analytics_workspace_table_custom_log.res-268
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppDependencies"
  to = azurerm_log_analytics_workspace_table_custom_log.res-269
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppEnvSessionConsoleLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-270
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppEnvSessionLifecycleLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-271
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppEnvSessionPoolEventLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-272
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppEnvSpringAppConsoleLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-273
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-274
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppExceptions"
  to = azurerm_log_analytics_workspace_table_custom_log.res-275
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppGenAIContent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-276
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-277
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppPageViews"
  to = azurerm_log_analytics_workspace_table_custom_log.res-278
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppPerformanceCounters"
  to = azurerm_log_analytics_workspace_table_custom_log.res-279
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppPlatformBuildLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-280
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppPlatformContainerEventLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-281
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppPlatformIngressLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-282
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppPlatformLogsforSpring"
  to = azurerm_log_analytics_workspace_table_custom_log.res-283
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppPlatformSystemLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-284
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-285
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppServiceAntivirusScanAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-286
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppServiceAppLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-287
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppServiceAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-288
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppServiceAuthenticationLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-289
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppServiceConsoleLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-290
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppServiceEnvironmentPlatformLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-291
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppServiceFileAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-292
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppServiceHTTPLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-293
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppServiceIPSecAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-294
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppServicePlatformLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-295
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppServiceServerlessSecurityPluginData"
  to = azurerm_log_analytics_workspace_table_custom_log.res-296
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppSystemEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-297
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AppTraces"
  to = azurerm_log_analytics_workspace_table_custom_log.res-298
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ArcK8sAudit"
  to = azurerm_log_analytics_workspace_table_custom_log.res-299
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ArcK8sAuditAdmin"
  to = azurerm_log_analytics_workspace_table_custom_log.res-300
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ArcK8sControlPlane"
  to = azurerm_log_analytics_workspace_table_custom_log.res-301
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-302
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AutoscaleEvaluationsLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-303
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AutoscaleScaleActionsLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-304
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AzureActivity"
  to = azurerm_log_analytics_workspace_table_custom_log.res-305
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AzureActivityV2"
  to = azurerm_log_analytics_workspace_table_custom_log.res-306
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AzureAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-307
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AzureAttestationDiagnostics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-308
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AzureBackupOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-309
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AzureDevOpsAuditing"
  to = azurerm_log_analytics_workspace_table_custom_log.res-310
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AzureLoadTestingOperation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-311
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AzureMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-312
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AzureMetricsV2"
  to = azurerm_log_analytics_workspace_table_custom_log.res-313
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AzureMonitorPipelineLogErrors"
  to = azurerm_log_analytics_workspace_table_custom_log.res-314
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AzureSQLAutomaticTuning"
  to = azurerm_log_analytics_workspace_table_custom_log.res-315
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AzureSQLBlocks"
  to = azurerm_log_analytics_workspace_table_custom_log.res-316
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AzureSQLDatabaseWaitStatistics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-317
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AzureSQLDeadlocks"
  to = azurerm_log_analytics_workspace_table_custom_log.res-318
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AzureSQLErrors"
  to = azurerm_log_analytics_workspace_table_custom_log.res-319
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AzureSQLQueryStoreRuntimeStatistics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-320
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AzureSQLQueryStoreWaitStatistics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-321
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AzureSQLResourceUsageStats"
  to = azurerm_log_analytics_workspace_table_custom_log.res-322
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/AzureSQLTimeouts"
  to = azurerm_log_analytics_workspace_table_custom_log.res-323
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/BehaviorEntities"
  to = azurerm_log_analytics_workspace_table_custom_log.res-324
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/BehaviorInfo"
  to = azurerm_log_analytics_workspace_table_custom_log.res-325
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/BlockchainApplicationLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-326
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/BlockchainProxyLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-327
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/CCFApplicationLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-328
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/CDBCassandraRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-329
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/CDBControlPlaneRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-330
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/CDBDataPlaneRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-331
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/CDBDataPlaneRequests15M"
  to = azurerm_log_analytics_workspace_table_custom_log.res-332
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/CDBDataPlaneRequests5M"
  to = azurerm_log_analytics_workspace_table_custom_log.res-333
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/CDBGremlinRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-334
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/CDBMongoRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-335
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/CDBPartitionKeyRUConsumption"
  to = azurerm_log_analytics_workspace_table_custom_log.res-336
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/CDBPartitionKeyStatistics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-337
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/CDBQueryRuntimeStatistics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-338
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/CDBTableApiRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-339
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/CHSMServiceOperationAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-340
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/CIEventsAudit"
  to = azurerm_log_analytics_workspace_table_custom_log.res-341
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/CIEventsOperational"
  to = azurerm_log_analytics_workspace_table_custom_log.res-342
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/CassandraAudit"
  to = azurerm_log_analytics_workspace_table_custom_log.res-343
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/CassandraLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-344
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ChaosStudioExperimentEventLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-345
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/CloudHsmHardwareOperationAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-346
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/CloudHsmServiceOperationAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-347
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ComputerGroup"
  to = azurerm_log_analytics_workspace_table_custom_log.res-348
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ContainerAppConsoleLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-349
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ContainerAppHTTPLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-350
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ContainerAppSystemLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-351
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ContainerEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-352
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ContainerImageInventory"
  to = azurerm_log_analytics_workspace_table_custom_log.res-353
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ContainerInstanceLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-354
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ContainerInventory"
  to = azurerm_log_analytics_workspace_table_custom_log.res-355
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ContainerLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-356
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ContainerLogV2"
  to = azurerm_log_analytics_workspace_table_custom_log.res-357
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ContainerNetworkLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-358
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ContainerNodeInventory"
  to = azurerm_log_analytics_workspace_table_custom_log.res-359
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ContainerRegistryLoginEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-360
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ContainerRegistryRepositoryEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-361
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ContainerServiceLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-362
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/CoreAzureBackup"
  to = azurerm_log_analytics_workspace_table_custom_log.res-363
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DCRLogErrors"
  to = azurerm_log_analytics_workspace_table_custom_log.res-364
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DCRLogTroubleshooting"
  to = azurerm_log_analytics_workspace_table_custom_log.res-365
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DNSQueryLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-366
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DSMAzureBlobStorageLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-367
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DSMDataClassificationLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-368
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DSMDataLabelingLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-369
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DataSetOutput"
  to = azurerm_log_analytics_workspace_table_custom_log.res-370
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DataSetRuns"
  to = azurerm_log_analytics_workspace_table_custom_log.res-371
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DataTransferOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-372
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksAccounts"
  to = azurerm_log_analytics_workspace_table_custom_log.res-373
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksApps"
  to = azurerm_log_analytics_workspace_table_custom_log.res-374
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksBrickStoreHttpGateway"
  to = azurerm_log_analytics_workspace_table_custom_log.res-375
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksBudgetPolicyCentral"
  to = azurerm_log_analytics_workspace_table_custom_log.res-376
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksCapsule8Dataplane"
  to = azurerm_log_analytics_workspace_table_custom_log.res-377
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksClamAVScan"
  to = azurerm_log_analytics_workspace_table_custom_log.res-378
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksCloudStorageMetadata"
  to = azurerm_log_analytics_workspace_table_custom_log.res-379
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksClusterLibraries"
  to = azurerm_log_analytics_workspace_table_custom_log.res-380
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksClusterPolicies"
  to = azurerm_log_analytics_workspace_table_custom_log.res-381
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksClusters"
  to = azurerm_log_analytics_workspace_table_custom_log.res-382
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksDBFS"
  to = azurerm_log_analytics_workspace_table_custom_log.res-383
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksDashboards"
  to = azurerm_log_analytics_workspace_table_custom_log.res-384
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksDataMonitoring"
  to = azurerm_log_analytics_workspace_table_custom_log.res-385
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksDataRooms"
  to = azurerm_log_analytics_workspace_table_custom_log.res-386
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksDatabricksSQL"
  to = azurerm_log_analytics_workspace_table_custom_log.res-387
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksDeltaPipelines"
  to = azurerm_log_analytics_workspace_table_custom_log.res-388
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksFeatureStore"
  to = azurerm_log_analytics_workspace_table_custom_log.res-389
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksFiles"
  to = azurerm_log_analytics_workspace_table_custom_log.res-390
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksFilesystem"
  to = azurerm_log_analytics_workspace_table_custom_log.res-391
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksGenie"
  to = azurerm_log_analytics_workspace_table_custom_log.res-392
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksGitCredentials"
  to = azurerm_log_analytics_workspace_table_custom_log.res-393
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksGlobalInitScripts"
  to = azurerm_log_analytics_workspace_table_custom_log.res-394
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksGroups"
  to = azurerm_log_analytics_workspace_table_custom_log.res-395
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksIAMRole"
  to = azurerm_log_analytics_workspace_table_custom_log.res-396
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksIngestion"
  to = azurerm_log_analytics_workspace_table_custom_log.res-397
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksInstancePools"
  to = azurerm_log_analytics_workspace_table_custom_log.res-398
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksJobs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-399
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksLakeviewConfig"
  to = azurerm_log_analytics_workspace_table_custom_log.res-400
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksLineageTracking"
  to = azurerm_log_analytics_workspace_table_custom_log.res-401
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksMLflowAcledArtifact"
  to = azurerm_log_analytics_workspace_table_custom_log.res-402
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksMLflowExperiment"
  to = azurerm_log_analytics_workspace_table_custom_log.res-403
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksMarketplaceConsumer"
  to = azurerm_log_analytics_workspace_table_custom_log.res-404
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksMarketplaceProvider"
  to = azurerm_log_analytics_workspace_table_custom_log.res-405
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksModelRegistry"
  to = azurerm_log_analytics_workspace_table_custom_log.res-406
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksNotebook"
  to = azurerm_log_analytics_workspace_table_custom_log.res-407
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksOnlineTables"
  to = azurerm_log_analytics_workspace_table_custom_log.res-408
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksPartnerHub"
  to = azurerm_log_analytics_workspace_table_custom_log.res-409
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksPredictiveOptimization"
  to = azurerm_log_analytics_workspace_table_custom_log.res-410
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksRBAC"
  to = azurerm_log_analytics_workspace_table_custom_log.res-411
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksRFA"
  to = azurerm_log_analytics_workspace_table_custom_log.res-412
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksRemoteHistoryService"
  to = azurerm_log_analytics_workspace_table_custom_log.res-413
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksRepos"
  to = azurerm_log_analytics_workspace_table_custom_log.res-414
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksSQL"
  to = azurerm_log_analytics_workspace_table_custom_log.res-415
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksSQLPermissions"
  to = azurerm_log_analytics_workspace_table_custom_log.res-416
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksSSH"
  to = azurerm_log_analytics_workspace_table_custom_log.res-417
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksSecrets"
  to = azurerm_log_analytics_workspace_table_custom_log.res-418
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksServerlessRealTimeInference"
  to = azurerm_log_analytics_workspace_table_custom_log.res-419
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksTables"
  to = azurerm_log_analytics_workspace_table_custom_log.res-420
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksUnityCatalog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-421
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksVectorSearch"
  to = azurerm_log_analytics_workspace_table_custom_log.res-422
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksWebTerminal"
  to = azurerm_log_analytics_workspace_table_custom_log.res-423
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksWebhookNotifications"
  to = azurerm_log_analytics_workspace_table_custom_log.res-424
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksWorkspace"
  to = azurerm_log_analytics_workspace_table_custom_log.res-425
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DatabricksWorkspaceFiles"
  to = azurerm_log_analytics_workspace_table_custom_log.res-426
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DevCenterAgentHealthLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-427
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DevCenterBillingEventLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-428
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DevCenterConnectionLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-429
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DevCenterDiagnosticLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-430
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DevCenterResourceOperationLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-431
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DevOpsOperationsAudit"
  to = azurerm_log_analytics_workspace_table_custom_log.res-432
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DeviceBehaviorEntities"
  to = azurerm_log_analytics_workspace_table_custom_log.res-433
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DeviceBehaviorInfo"
  to = azurerm_log_analytics_workspace_table_custom_log.res-434
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DeviceCustomFileEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-435
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DeviceCustomImageLoadEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-436
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DeviceCustomNetworkEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-437
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DeviceCustomProcessEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-438
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DeviceCustomRegistryEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-439
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DeviceCustomScriptEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-440
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DiscoveryBookshelfAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-441
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DiscoverySupercomputerAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-442
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DiscoveryWorkspaceAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-443
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/DurableTaskSchedulerLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-444
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/EGNFailedHttpDataPlaneOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-445
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/EGNFailedMqttConnections"
  to = azurerm_log_analytics_workspace_table_custom_log.res-446
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/EGNFailedMqttPublishedMessages"
  to = azurerm_log_analytics_workspace_table_custom_log.res-447
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/EGNFailedMqttSubscriptions"
  to = azurerm_log_analytics_workspace_table_custom_log.res-448
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/EGNMqttDisconnections"
  to = azurerm_log_analytics_workspace_table_custom_log.res-449
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/EGNSuccessfulHttpDataPlaneOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-450
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/EGNSuccessfulMqttConnections"
  to = azurerm_log_analytics_workspace_table_custom_log.res-451
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ETWEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-452
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/EdgeActionConsoleLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-453
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/EdgeActionServiceLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-454
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/EnrichedMicrosoft365AuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-455
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/Event"
  to = azurerm_log_analytics_workspace_table_custom_log.res-456
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ExchangeAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-457
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ExchangeOnlineAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-458
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/FailedIngestion"
  to = azurerm_log_analytics_workspace_table_custom_log.res-459
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/FunctionAppLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-460
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/GraphNotificationsActivityLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-461
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightAmbariClusterAlerts"
  to = azurerm_log_analytics_workspace_table_custom_log.res-462
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightAmbariSystemMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-463
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightGatewayAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-464
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightHBaseLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-465
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightHBaseMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-466
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightHadoopAndYarnLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-467
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightHadoopAndYarnMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-468
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightHiveAndLLAPLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-469
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightHiveAndLLAPMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-470
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightHiveQueryAppStats"
  to = azurerm_log_analytics_workspace_table_custom_log.res-471
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightHiveTezAppStats"
  to = azurerm_log_analytics_workspace_table_custom_log.res-472
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightJupyterNotebookEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-473
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightKafkaLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-474
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightKafkaMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-475
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightKafkaServerLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-476
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightOozieLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-477
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightRangerAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-478
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightSecurityLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-479
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightSparkApplicationEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-480
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightSparkBlockManagerEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-481
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightSparkEnvironmentEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-482
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightSparkExecutorEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-483
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightSparkExtraEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-484
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightSparkJobEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-485
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightSparkLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-486
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightSparkSQLExecutionEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-487
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightSparkStageEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-488
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightSparkStageTaskAccumulables"
  to = azurerm_log_analytics_workspace_table_custom_log.res-489
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightSparkTaskEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-490
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightStormLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-491
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightStormMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-492
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HDInsightStormTopologyMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-493
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/HealthStateChangeEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-494
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/Heartbeat"
  to = azurerm_log_analytics_workspace_table_custom_log.res-495
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/InsightsMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-496
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/IntuneAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-497
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/IntuneDeviceComplianceOrg"
  to = azurerm_log_analytics_workspace_table_custom_log.res-498
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/IntuneDevices"
  to = azurerm_log_analytics_workspace_table_custom_log.res-499
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/IntuneOperationalLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-500
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/KubeEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-501
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/KubeHealth"
  to = azurerm_log_analytics_workspace_table_custom_log.res-502
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/KubeMonAgentEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-503
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/KubeNodeInventory"
  to = azurerm_log_analytics_workspace_table_custom_log.res-504
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/KubePVInventory"
  to = azurerm_log_analytics_workspace_table_custom_log.res-505
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/KubePodInventory"
  to = azurerm_log_analytics_workspace_table_custom_log.res-506
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/KubeServices"
  to = azurerm_log_analytics_workspace_table_custom_log.res-507
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/LAJobLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-508
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/LAQueryLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-509
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/LASummaryLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-510
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/LIATrackingEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-511
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/LedgerTransactionLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-512
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/LedgerUserDefinedLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-513
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/LogicAppWorkflowRuntime"
  to = azurerm_log_analytics_workspace_table_custom_log.res-514
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MCCEventLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-515
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MCVPAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-516
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MCVPOperationLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-517
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MDCDetectionDNSEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-518
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MDCDetectionFimEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-519
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MDCDetectionGatingValidationEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-520
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MDCDetectionK8SApiEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-521
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MDCDetectionProcessV2Events"
  to = azurerm_log_analytics_workspace_table_custom_log.res-522
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MDCFileIntegrityMonitoringEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-523
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MDECustomCollectionDeviceFileEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-524
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MDPResourceLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-525
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MNFDeviceUpdates"
  to = azurerm_log_analytics_workspace_table_custom_log.res-526
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MNFSystemSessionHistoryUpdates"
  to = azurerm_log_analytics_workspace_table_custom_log.res-527
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MNFSystemStateMessageUpdates"
  to = azurerm_log_analytics_workspace_table_custom_log.res-528
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MPCAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-529
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MPCIngestionLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-530
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MeshControlPlane"
  to = azurerm_log_analytics_workspace_table_custom_log.res-531
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MicrosoftAzureBastionAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-532
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MicrosoftDataShareReceivedSnapshotLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-533
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MicrosoftDataShareSentSnapshotLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-534
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MicrosoftDataShareShareLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-535
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MicrosoftGraphActivityLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-536
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MicrosoftGraphPolicyLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-537
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MicrosoftHealthcareApisAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-538
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MicrosoftServicePrincipalSignInLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-539
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MySqlAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-540
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/MySqlSlowLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-541
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NCBMBreakGlassAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-542
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NCBMSecurityDefenderLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-543
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NCBMSecurityLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-544
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NCBMSystemLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-545
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NCCIDRACLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-546
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NCCKubernetesAPIAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-547
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NCCKubernetesLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-548
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NCCPlatformOperationsLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-549
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NCCVMOrchestrationLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-550
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NCMClusterOperationsLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-551
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NCSStorageAlerts"
  to = azurerm_log_analytics_workspace_table_custom_log.res-552
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NCSStorageAudits"
  to = azurerm_log_analytics_workspace_table_custom_log.res-553
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NCSStorageLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-554
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NGXOperationLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-555
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NGXSecurityLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-556
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NSPAccessLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-557
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NTAInsights"
  to = azurerm_log_analytics_workspace_table_custom_log.res-558
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NTAIpDetails"
  to = azurerm_log_analytics_workspace_table_custom_log.res-559
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NTANetAnalytics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-560
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NTANspRuleRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-561
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NTARuleRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-562
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NTATopologyDetails"
  to = azurerm_log_analytics_workspace_table_custom_log.res-563
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NWConnectionMonitorDNSResult"
  to = azurerm_log_analytics_workspace_table_custom_log.res-564
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NWConnectionMonitorDestinationListenerResult"
  to = azurerm_log_analytics_workspace_table_custom_log.res-565
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NWConnectionMonitorPathResult"
  to = azurerm_log_analytics_workspace_table_custom_log.res-566
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NWConnectionMonitorTestResult"
  to = azurerm_log_analytics_workspace_table_custom_log.res-567
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NatGatewayFlowlogsV1"
  to = azurerm_log_analytics_workspace_table_custom_log.res-568
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NetworkAccessAlerts"
  to = azurerm_log_analytics_workspace_table_custom_log.res-569
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NetworkAccessConnectionEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-570
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NetworkAccessGenerativeAIInsights"
  to = azurerm_log_analytics_workspace_table_custom_log.res-571
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NetworkAccessTraffic"
  to = azurerm_log_analytics_workspace_table_custom_log.res-572
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/NginxUpstreamUpdateLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-573
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/OEPAirFlowTask"
  to = azurerm_log_analytics_workspace_table_custom_log.res-574
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/OEPAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-575
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/OEPDataplaneLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-576
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/OEPElasticOperator"
  to = azurerm_log_analytics_workspace_table_custom_log.res-577
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/OEPElasticsearch"
  to = azurerm_log_analytics_workspace_table_custom_log.res-578
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/OEWAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-579
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/OEWExperimentAssignmentSummary"
  to = azurerm_log_analytics_workspace_table_custom_log.res-580
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/OEWExperimentScorecardMetricPairs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-581
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/OEWExperimentScorecards"
  to = azurerm_log_analytics_workspace_table_custom_log.res-582
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/OGOAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-583
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/OLPSupplyChainEntityOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-584
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/OLPSupplyChainEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-585
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/OTelEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-586
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/OTelLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-587
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/OTelResources"
  to = azurerm_log_analytics_workspace_table_custom_log.res-588
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/OTelSpans"
  to = azurerm_log_analytics_workspace_table_custom_log.res-589
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/OTelTraces"
  to = azurerm_log_analytics_workspace_table_custom_log.res-590
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/OTelTracesAgent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-591
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/Operation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-592
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/OracleCloudDatabase"
  to = azurerm_log_analytics_workspace_table_custom_log.res-593
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/PFTitleAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-594
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/PGSQLAutovacuumStats"
  to = azurerm_log_analytics_workspace_table_custom_log.res-595
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/PGSQLDbTransactionsStats"
  to = azurerm_log_analytics_workspace_table_custom_log.res-596
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/PGSQLPgBouncer"
  to = azurerm_log_analytics_workspace_table_custom_log.res-597
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/PGSQLPgStatActivitySessions"
  to = azurerm_log_analytics_workspace_table_custom_log.res-598
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/PGSQLQueryStoreQueryText"
  to = azurerm_log_analytics_workspace_table_custom_log.res-599
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/PGSQLQueryStoreRuntime"
  to = azurerm_log_analytics_workspace_table_custom_log.res-600
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/PGSQLQueryStoreWaits"
  to = azurerm_log_analytics_workspace_table_custom_log.res-601
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/PGSQLServerLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-602
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/Perf"
  to = azurerm_log_analytics_workspace_table_custom_log.res-603
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/PerfInsightsFindings"
  to = azurerm_log_analytics_workspace_table_custom_log.res-604
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/PerfInsightsImpactedResources"
  to = azurerm_log_analytics_workspace_table_custom_log.res-605
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/PerfInsightsRun"
  to = azurerm_log_analytics_workspace_table_custom_log.res-606
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/PowerBIDatasetsTenant"
  to = azurerm_log_analytics_workspace_table_custom_log.res-607
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/PowerBIDatasetsWorkspace"
  to = azurerm_log_analytics_workspace_table_custom_log.res-608
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/PreAuthenticationDiscoveryLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-609
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/PurviewDataSensitivityLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-610
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/PurviewScanStatusLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-611
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/PurviewSecurityLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-612
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/QuantumProviderAccountJobAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-613
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/QuantumProviderAccountQueueAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-614
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/QuantumProviderAccountTargetAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-615
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/QuantumWorkspaceJobAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-616
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/REDConnectionEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-617
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/RemoteNetworkHealthLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-618
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ResourceManagementPublicAccessLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-619
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/RetinaNetworkFlowLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-620
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SCCMAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-621
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SCGPoolExecutionLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-622
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SCGPoolRequestLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-623
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SCOMAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-624
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SPAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-625
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SQLAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-626
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SQLSecurityAuditEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-627
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SVMPoolExecutionLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-628
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SVMPoolRequestLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-629
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SecurityCaseEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-630
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ServiceFabricOperationalEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-631
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ServiceFabricReliableActorEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-632
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ServiceFabricReliableServiceEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-633
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SfBAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-634
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SfBOnlineAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-635
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SharePointOnlineAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-636
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SignalRServiceDiagnosticLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-637
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SigninLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-638
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/StorageAntimalwareScanResults"
  to = azurerm_log_analytics_workspace_table_custom_log.res-639
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/StorageBlobLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-640
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/StorageCacheOperationEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-641
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/StorageCacheUpgradeEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-642
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/StorageCacheWarningEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-643
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/StorageFileLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-644
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/StorageMalwareScanningResults"
  to = azurerm_log_analytics_workspace_table_custom_log.res-645
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/StorageMoverAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-646
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/StorageMoverCopyLogsFailed"
  to = azurerm_log_analytics_workspace_table_custom_log.res-647
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/StorageMoverCopyLogsTransferred"
  to = azurerm_log_analytics_workspace_table_custom_log.res-648
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/StorageMoverJobRunLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-649
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/StorageQueueLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-650
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/StorageTableLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-651
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SucceededIngestion"
  to = azurerm_log_analytics_workspace_table_custom_log.res-652
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseBigDataPoolApplicationsEnded"
  to = azurerm_log_analytics_workspace_table_custom_log.res-653
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseBuiltinSqlPoolRequestsEnded"
  to = azurerm_log_analytics_workspace_table_custom_log.res-654
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseDXCommand"
  to = azurerm_log_analytics_workspace_table_custom_log.res-655
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseDXFailedIngestion"
  to = azurerm_log_analytics_workspace_table_custom_log.res-656
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseDXIngestionBatching"
  to = azurerm_log_analytics_workspace_table_custom_log.res-657
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseDXQuery"
  to = azurerm_log_analytics_workspace_table_custom_log.res-658
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseDXSucceededIngestion"
  to = azurerm_log_analytics_workspace_table_custom_log.res-659
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseDXTableDetails"
  to = azurerm_log_analytics_workspace_table_custom_log.res-660
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseDXTableUsageStatistics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-661
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseGatewayApiRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-662
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseIntegrationActivityRuns"
  to = azurerm_log_analytics_workspace_table_custom_log.res-663
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseIntegrationPipelineRuns"
  to = azurerm_log_analytics_workspace_table_custom_log.res-664
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseIntegrationTriggerRuns"
  to = azurerm_log_analytics_workspace_table_custom_log.res-665
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseLinkEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-666
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseRbacOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-667
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseScopePoolScopeJobsEnded"
  to = azurerm_log_analytics_workspace_table_custom_log.res-668
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseScopePoolScopeJobsStateChange"
  to = azurerm_log_analytics_workspace_table_custom_log.res-669
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseSqlPoolDmsWorkers"
  to = azurerm_log_analytics_workspace_table_custom_log.res-670
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseSqlPoolExecRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-671
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseSqlPoolRequestSteps"
  to = azurerm_log_analytics_workspace_table_custom_log.res-672
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseSqlPoolSqlRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-673
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/SynapseSqlPoolWaits"
  to = azurerm_log_analytics_workspace_table_custom_log.res-674
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/Syslog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-675
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/TOUserAudits"
  to = azurerm_log_analytics_workspace_table_custom_log.res-676
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/TOUserDiagnostics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-677
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/TSIIngress"
  to = azurerm_log_analytics_workspace_table_custom_log.res-678
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/UCClient"
  to = azurerm_log_analytics_workspace_table_custom_log.res-679
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/UCClientReadinessStatus"
  to = azurerm_log_analytics_workspace_table_custom_log.res-680
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/UCClientUpdateStatus"
  to = azurerm_log_analytics_workspace_table_custom_log.res-681
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/UCDOAggregatedStatus"
  to = azurerm_log_analytics_workspace_table_custom_log.res-682
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/UCDOStatus"
  to = azurerm_log_analytics_workspace_table_custom_log.res-683
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/UCDeviceAlert"
  to = azurerm_log_analytics_workspace_table_custom_log.res-684
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/UCServiceUpdateStatus"
  to = azurerm_log_analytics_workspace_table_custom_log.res-685
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/UCUpdateAlert"
  to = azurerm_log_analytics_workspace_table_custom_log.res-686
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/Usage"
  to = azurerm_log_analytics_workspace_table_custom_log.res-687
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/VCoreMongoRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-688
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/VIAudit"
  to = azurerm_log_analytics_workspace_table_custom_log.res-689
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/VIIndexing"
  to = azurerm_log_analytics_workspace_table_custom_log.res-690
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/VMBoundPort"
  to = azurerm_log_analytics_workspace_table_custom_log.res-691
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/VMComputer"
  to = azurerm_log_analytics_workspace_table_custom_log.res-692
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/VMConnection"
  to = azurerm_log_analytics_workspace_table_custom_log.res-693
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/VMProcess"
  to = azurerm_log_analytics_workspace_table_custom_log.res-694
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/W3CIISLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-695
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/WOUserAudits"
  to = azurerm_log_analytics_workspace_table_custom_log.res-696
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/WOUserDiagnostics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-697
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/WVDAgentHealthStatus"
  to = azurerm_log_analytics_workspace_table_custom_log.res-698
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/WVDAutoscaleEvaluationPooled"
  to = azurerm_log_analytics_workspace_table_custom_log.res-699
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/WVDCheckpoints"
  to = azurerm_log_analytics_workspace_table_custom_log.res-700
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/WVDConnectionGraphicsDataPreview"
  to = azurerm_log_analytics_workspace_table_custom_log.res-701
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/WVDConnectionNetworkData"
  to = azurerm_log_analytics_workspace_table_custom_log.res-702
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/WVDConnections"
  to = azurerm_log_analytics_workspace_table_custom_log.res-703
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/WVDErrors"
  to = azurerm_log_analytics_workspace_table_custom_log.res-704
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/WVDFeeds"
  to = azurerm_log_analytics_workspace_table_custom_log.res-705
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/WVDHostRegistrations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-706
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/WVDManagement"
  to = azurerm_log_analytics_workspace_table_custom_log.res-707
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/WVDMultiLinkAdd"
  to = azurerm_log_analytics_workspace_table_custom_log.res-708
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/WVDSessionHostManagement"
  to = azurerm_log_analytics_workspace_table_custom_log.res-709
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/WebPubSubConnectivity"
  to = azurerm_log_analytics_workspace_table_custom_log.res-710
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/WebPubSubHttpRequest"
  to = azurerm_log_analytics_workspace_table_custom_log.res-711
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/WebPubSubMessaging"
  to = azurerm_log_analytics_workspace_table_custom_log.res-712
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/Windows365AuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-713
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/WindowsClientAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-714
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/WindowsServerAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-715
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/WorkloadDiagnosticLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-716
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ZTSGraph"
  to = azurerm_log_analytics_workspace_table_custom_log.res-717
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ZTSJobStatus"
  to = azurerm_log_analytics_workspace_table_custom_log.res-718
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ZTSMetadata"
  to = azurerm_log_analytics_workspace_table_custom_log.res-719
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.OperationalInsights/workspaces/law-iacx-p1x7q/tables/ZTSRequest"
  to = azurerm_log_analytics_workspace_table_custom_log.res-720
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.Storage/storageAccounts/stiacxp1x7q"
  to = azurerm_storage_account.res-721
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.Storage/storageAccounts/stiacxp1x7q/blobServices/default/containers/data"
  to = azurerm_storage_container.res-723
}
import {
  id = "/subscriptions/e4b62b3b-7634-4972-8bbe-5d7197159f26/resourceGroups/rg-iacexport-stema-20260722/providers/Microsoft.Storage/storageAccounts/stiacxp1x7q"
  to = azurerm_storage_account_queue_properties.res-725
}

