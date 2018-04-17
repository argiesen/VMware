# VMScripts

### Get vCenter version
```
Connect-VIServer server.domain.local -Credential (Get-Credential)
$global:DefaultVIServer | select Name,Version,Build
```

### Get object counts
```
"" | select @{l='DatacenterCount';e={(Get-Datacenter).Count}},@{l='ClusterCount';e={(Get-Cluster).Count}},@{l='HostCount';e={(Get-VMHost).Count}},@{l='VMCount';e={(Get-VM).Count}}
```

### List Clusters
```
Get-Cluster | select Name,@{l='Datacenter';e={$_ | Get-Datacenter}},vSanEnabled,HAEnabled,HAFailoverLevel,HAAdmissionControlEnabled,DrsEnabled,DrsMode,DrsAutomationLevel,EVCMode
```

### List Hosts
```
Get-VMHost | select Name,@{l='Datacenter';e={$_ | Get-Datacenter}},@{l='Cluster';e={$_.Parent}},Manufacturer,Model,@{l='IPAddress';e={($_ | Get-VMHostNetworkAdapter | where ManagementTrafficEnabled -eq $true).IP}},Version,Build,IsStandalone
```

