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
Get-VMHost | select Name,@{l='Datacenter';e={$_ | Get-Datacenter}},@{l='Cluster';e={$_.Parent}},Manufacturer,Model,@{l='IPAddress';e={($_ | Get-VMHostNetworkAdapter | where ManagementTrafficEnabled -eq $true).IP}},@{l='NumberOfVM';e={($_ | Get-VM).Count}},Version,Build,MaxEVCMode,IsStandalone
```

### List VMs
```
New-VIProperty -Name ToolsVersion -ObjectType VirtualMachine -ValueFromExtensionProperty 'Config.tools.ToolsVersion' -Force
New-VIProperty -Name ToolsVersionStatus -ObjectType VirtualMachine -ValueFromExtensionProperty 'Guest.ToolsVersionStatus' -Force

Get-VM | select Name,VMHost,Guest,PowerState,NumCpu,MemoryMB,Version,ToolsVersion,ToolsVersionStatus,@{N='SyncTimeWithHost';E={($_ | Get-View).Config.Tools.syncTimeWithHost}},@{N='ToolsUpgradePolicy';E={($_ | Get-View).Config.Tools.ToolsUpgradePolicy}},Notes
```

### Get NTP configuration
```
Get-VMHost | select Name,@{l='NTPServer';e={$_ | Get-VMHostNtpServer}},@{l='Policy';e={($_ | Get-VMHostService | Where {$_.Key -eq "ntpd"}).Policy}},@{l='Running';e={($_ | Get-VMHostService | Where {$_.Key -eq "ntpd"}).Running}}
```

### Get SSO Site Name
https://www.virtuallyghetto.com/2015/04/vcenter-server-6-0-tidbits-part-2-what-is-my-sso-domain-name-site-name.html

### Check HCL
https://labs.vmware.com/flings/esxi-compatibility-checker

### Enable VMware Tools upgrade at power cycle
```
foreach ($v in (Get-VM)) {
	$vm = $v | Get-View
	$vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
	$vmConfigSpec.Tools = New-Object VMware.Vim.ToolsConfigInfo
	$vmConfigSpec.Tools.ToolsUpgradePolicy = "UpgradeAtPowerCycle"
	$vm.ReconfigVM($vmConfigSpec)
}
```

### Disable time sync with host
```
foreach ($v in (Get-VM)) {
	$vm = $v | Get-View
	$vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
	$vmConfigSpec.Tools = New-Object VMware.Vim.ToolsConfigInfo
	$vmConfigSpec.Tools.syncTimeWithHost = $false
	$vm.ReconfigVM($vmConfigSpec)
}
```
