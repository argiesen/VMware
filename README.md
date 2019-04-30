# VMScripts

### Get vCenter version
```
Connect-VIServer server.domain.local -Credential (Get-Credential)
$global:DefaultVIServer | select Name,Version,Build
```

### List license summary
```
$licenseTable = @()
$LicenseManager = Get-View LicenseManager
$licenses = $LicenseManager.Licenses | select Name -Unique
foreach ($license in $licenses){
	$licenseOut = "" | select Name,Used,Total
	$licenseOut.Name = $license.Name
	$licenseOut.Used = ($LicenseManager.Licenses | where Name -eq $license.Name | Measure-Object -Property Used -Sum).Sum
	$licenseOut.Total = ($LicenseManager.Licenses | where Name -eq $license.Name | Measure-Object -Property Total -Sum).Sum
	$licenseTable += $licenseOut
}

$licenseTable | Sort-Object -Property Name | ft -AutoSize
```

### List license details
```
$LicenseManager = Get-View LicenseManager
$LicenseAssignmentManager = Get-View $LicenseManager.LicenseAssignmentManager

Get-View -ViewType HostSystem | select Name,
@{N='Cluster';E={$parent = Get-View -Id $_.Parent -Property Name,Parent
	While ($parent -isnot [VMware.Vim.ClusterComputeResource] -and $parent.Parent){
		$parent = Get-View -Id $parent.Parent -Property Name,Parent
	}
	if($parent -is [VMware.Vim.ClusterComputeResource]){$parent.Name}}
},
@{N='Product';E={$_.Config.Product.FullName}},
@{N='LicenseType';E={$script:licInfo = $LicenseAssignmentManager.GetType().GetMethod("QueryAssignedLicenses").Invoke($LicenseAssignmentManager,@($_.MoRef.Value))
$Script:licInfo.AssignedLicense.Name}}
```

### Get object counts
```
"" | select @{l='DatacenterCount';e={(Get-Datacenter).Count}},@{l='ClusterCount';e={(Get-Cluster).Count}},@{l='HostCount';e={(Get-VMHost).Count}},@{l='VMCount';e={(Get-VM).Count}}
```

### List cluster features
```
Get-Cluster | select Name,@{l='Datacenter';e={$_ | Get-Datacenter}},@{l='Hosts';e={($_ | Get-VMHost).Count}},vSanEnabled,HAEnabled,HAFailoverLevel,HAAdmissionControlEnabled,DrsEnabled,DrsAutomationLevel,EVCMode
```

### List cluster resources
```
$ClusterResources = @()
$Clusters = Get-Cluster
foreach ($Cluster in $Clusters){
	$Hosts = Get-Cluster $Cluster | Get-VMHost
	$ClusterResources += "" | select @{l='Name';e={$Cluster.Name}},@{l='NumHosts';e={$Hosts.Count}},@{l='NumCpu';e={($Hosts | Measure-Object -Property NumCpu -Sum).Sum}},@{l='CpuUsageMhz';e={($Hosts | Measure-Object -Property CpuUsageMhz -Sum).Sum}},@{l='CpuTotalMhz';e={($Hosts | Measure-Object -Property CpuTotalMhz -Sum).Sum}},@{l='MemoryUsageGB';e={($Hosts | Measure-Object -Property MemoryUsageGB -Sum).Sum}},@{l='MemoryTotalGB';e={($Hosts | Measure-Object -Property MemoryTotalGB -Sum).Sum}}
}
$ClusterResources
```

### List cluster resources with VM consumption
```
$ClusterResources = @()
$Clusters = Get-Cluster
$VMs = Get-VM | select Name,VMHost,@{l='Cluster';e={Get-VMHost $_.VMHost | Get-Cluster}},Guest,PowerState,NumCpu,MemoryMB,UsedSpaceGB,ProvisionedSpaceGB
foreach ($Cluster in $Clusters){
	$Hosts = Get-Cluster $Cluster | Get-VMHost
	$ClusterResources += "" | select @{l='Name';e={$Cluster.Name}},@{l='NumHost';e={$Hosts.Count}},@{l='NumVm';e={($VMs | where Cluster -match $Cluster.Name).Count}},@{l='NumCpu';e={($Hosts | Measure-Object -Property NumCpu -Sum).Sum}},@{l='CpuUsageMhz';e={($Hosts | Measure-Object -Property CpuUsageMhz -Sum).Sum}},@{l='CpuTotalMhz';e={($Hosts | Measure-Object -Property CpuTotalMhz -Sum).Sum}},@{l='MemoryUsageGB';e={($Hosts | Measure-Object -Property MemoryUsageGB -Sum).Sum}},@{l='MemoryTotalGB';e={($Hosts | Measure-Object -Property MemoryTotalGB -Sum).Sum}},@{l='ProvisionedVcpu';e={($VMs | where PowerState -eq "PoweredOn" | where Cluster -match $Cluster.Name | Measure-Object -Property NumCpu -Sum).Sum}},@{l='ProvisionedMemoryMB';e={($VMs | where PowerState -eq "PoweredOn" | where Cluster -match $Cluster.Name | Measure-Object -Property MemoryMB -Sum).Sum}},@{l='ProvisionedSpaceGB';e={($VMs | where Cluster -match $Cluster.Name | Measure-Object -Property ProvisionedSpaceGB -Sum).Sum}}
}
$ClusterResources
```

### List hosts
```
Get-VMHost | select Name,@{l='Datacenter';e={$_ | Get-Datacenter}},@{l='Cluster';e={$_.Parent}},Manufacturer,Model,@{l='SerialNumber';e={($_ | Get-VMHostHardware).SerialNumber}},@{l='BiosVersion';e={($_ | Get-VMHostHardware).BiosVersion}},@{l='CpuModel';e={($_ | Get-VMHostHardware).CpuModel}},@{l='CpuSocket';e={($_ | Get-VMHostHardware).CpuCount}},@{l='CpuCore';e={($_ | Get-VMHostHardware).CpuCoreCountTotal}},HyperthreadingActive,CpuUsageMhz,CpuTotalMhz,MemoryUsageGB,MemoryTotalGB,@{l='PsuCount';e={($_ | Get-VMHostHardware).PowerSupplies.Count}},@{l='NicCount';e={($_ | Get-VMHostHardware).NicCount}},@{l='IPAddress';e={($_ | Get-VMHostNetworkAdapter | where ManagementTrafficEnabled -eq $true).IP}},@{l='NumberOfVM';e={($_ | Get-VM).Count}},Version,Build,MaxEVCMode,IsStandalone,@{l='SSH';e={($_ | Get-VMHostService | where {$_.Key -eq "TSM-SSH"}).Running}},@{Name="HostTime";Expression={(Get-View $_.ExtensionData.configManager.DateTimeSystem).QueryDateTime()}}
```

### List VMs
```
New-VIProperty -Name ToolsVersion -ObjectType VirtualMachine -ValueFromExtensionProperty 'Config.tools.ToolsVersion' -Force | Out-Null
New-VIProperty -Name ToolsVersionStatus -ObjectType VirtualMachine -ValueFromExtensionProperty 'Guest.ToolsVersionStatus' -Force | Out-Null

Get-VM | select Name,VMHost,@{l='Cluster';e={Get-VMHost $_.VMHost | Get-Cluster}},Guest,@{N="IPAddress";E={@($_.Guest.IPAddress | where {$_ -notmatch ":"})}},PowerState,NumCpu,MemoryMB,UsedSpaceGB,ProvisionedSpaceGB,HardwareVersion,ToolsVersion,ToolsVersionStatus,@{l='SyncTimeWithHost';e={($_ | Get-View).Config.Tools.syncTimeWithHost}},@{l='ToolsUpgradePolicy';e={($_ | Get-View).Config.Tools.ToolsUpgradePolicy}},Notes | sort Cluster,Name
```

### Evaluate VM resources
```
#Count VMs by vCPUs
"" | select @{l='8+';e={(Get-VM | where NumCpu -gt 8).Count}},@{l='4-8';e={(Get-VM | where {$_.NumCpu -le 8 -and $_.NumCpu -ge 4}).Count}},@{l='3';e={(Get-VM | where NumCpu -eq 3).Count}},@{l='2';e={(Get-VM | where NumCpu -eq 2).Count}},@{l='1';e={(Get-VM | where NumCpu -eq 1).Count}}

#Find VMs with more vCPU than cores on socket
Get-VM | where {$_.NumCpu -gt (($_ | Get-VMHost).NumCpu/($_ | Get-VMHost | Get-View).Hardware.CpuInfo.NumCpuPackages)}
```

### List datastores summary
```
Get-Datastore | select Name,Datacenter,Type,State,FreeSpaceMB,CapacityGB,FileSystemVersion
```

### List datastores with multiple hosts
```
Get-Datastore | where {$_.ExtensionData.Host.Count -gt 1} | select Name,CapacityGB,FreeSpaceGB,@{l='HostCount';e={$_.ExtensionData.Host.Count}}
```

### List vSAN clusters
```
Get-VsanClusterConfiguration | where VsanEnabled -eq $true | select Name,WitnessHost,SpaceEfficiencyEnabled,StretchedClusterEnabled,IscsiTargetServiceEnabled,EncryptionEnabled,PerformanceServiceEnabled,HealthCheckEnabled,TimeOfHclUpdate
```

### List snapshots over 7 days old
```
Get-VM | Get-Snapshot | where {$_.Created -lt (Get-Date).AddDays(-7)} | Select-Object VM,Name,Created,SizeMB,@{l='Datastore';e={(Get-VM $_.VM | Get-Datastore).Name}}
```

### Get NTP configuration and host time
```
Get-VMHost | select Name,@{l='NTPServer';e={$_ | Get-VMHostNtpServer}},@{l='Policy';e={($_ | Get-VMHostService | where {$_.Key -eq "ntpd"}).Policy}},@{l='Running';e={($_ | Get-VMHostService | where {$_.Key -eq "ntpd"}).Running}}

Get-VMHost | select Name,@{l='Time';e={(Get-View $_.ExtensionData.configManager.DateTimeSystem).QueryDateTime()}}
```

### Set host time to match local machine
```
Get-VMHost | foreach {(Get-View $_.ExtensionData.configManager.DateTimeSystem).UpdateDateTime((Get-Date -format u))}
```

### CDP network info
```
$result = @()
Get-VMHost | Where-Object {$_.ConnectionState -eq "Connected"} |
	%{Get-View $_.ID} |
	%{$esxname = $_.Name; Get-View $_.ConfigManager.NetworkSystem} |
	%{foreach($physnic in $_.NetworkInfo.Pnic){
		$pnicInfo = $_.QueryNetworkHint($physnic.Device)
		foreach($hint in $pnicInfo){
			if($hint.ConnectedSwitchPort){
				$output = $hint.ConnectedSwitchPort | select Host,Pnic,DevId,Address,HardwarePlatform,PortId,SoftwareVersion,Location
				$output.Host = $esxname
				$output.Pnic = $physnic.Device
			}else{
				$output = "" | select Host,Pnic,DevId,Address,HardwarePlatform,PortId,SoftwareVersion,Location
				$output.Host = $esxname
				$output.Pnic = $physnic.Device
				$output.DevId = "No CDP"
			}
			$result += $output
		}
	}
}

$result | ft -AutoSize
```

### Get SSO site name
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
