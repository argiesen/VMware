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
Get-Cluster | select Name,@{l='Datacenter';e={$_ | Get-Datacenter}},@{l='Hosts';e={($_ | Get-VMHost).Count}},vSanEnabled,HAEnabled,HAFailoverLevel,HAAdmissionControlEnabled,DrsEnabled,DrsMode,DrsAutomationLevel,EVCMode
```

### List Hosts
```
Get-VMHost | select Name,@{l='Datacenter';e={$_ | Get-Datacenter}},@{l='Cluster';e={$_.Parent}},Manufacturer,Model,@{l='IPAddress';e={($_ | Get-VMHostNetworkAdapter | where ManagementTrafficEnabled -eq $true).IP}},Version,Build,MaxEVCMode,IsStandalone
```

### List VMs
```
Get-VM | select Name,VMHost,Guest,PowerState,NumCpu,MemoryMB,Version,Notes
```

### Get NTP configuration
```
Get-VMHost | select Name,@{l='NTPServer';e={$_ | Get-VMHostNtpServer}},@{l='Policy';e={($_ | Get-VMHostService | Where {$_.Key -eq "ntpd"}).Policy}},@{l='Running';e={($_ | Get-VMHostService | Where {$_.Key -eq "ntpd"}).Running}}
```

### Get SSO Site Name
https://www.virtuallyghetto.com/2015/04/vcenter-server-6-0-tidbits-part-2-what-is-my-sso-domain-name-site-name.html
