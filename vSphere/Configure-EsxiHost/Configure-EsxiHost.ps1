<#
    .SYNOPSIS
	  This script automates the configuration of ESXi hosts.
	  
	.DESCRIPTION
	  
	  
	.PARAMETER HostIP
	  Specifies ESXi management IP address.
	.PARAMETER Hostname
	  Specifies hostname.
	  
	  Default: localhost
	.PARAMETER DnsServer
	  Specifies DNS server IP address(es).
	.PARAMETER DomainName
	  Specifies domain name.
	.PARAMETER SearchDomain
	  Specifies DNS search domain(s).
	.PARAMETER NtpServer
	  Specifies NTP server IP address(es).
	.PARAMETER RootPassword
	  Specifies root user password to connect to ESXi.
	  
	  WARNING: This password is stored in cleartext. It is recommended to use HostCredential instead.
	.PARAMETER HostCredential
	  Specifies credentials to connect to ESXi.
	.PARAMETER StorageTarget
	  Specifies iSCSI storage target for the software iSCSI initiator.
	.PARAMETER StorageIP
	  Specifies IP address(es) to create VMkernel interfaces for IP based storage. For each IP address there must be a corresponding VLAN ID specified in StorageVLAN. If JumboFrames is set to True the VMkernel interfaces are created with a MTU of 9000.
	.PARAMETER StorageVLAN
	  Specifies VLAN ID for IP based storage VMkernel port group. For each VLAN there must be a corresponding IP address specified in StorageIP.
	  
	  0 = untagged. 4095 = trunked.
	.PARAMETER StorageIPMask
	  Specifies single subnet mask applied to all storage VMkernel interfaces.
	.PARAMETER vMotionIP
	  Specifies IP address(es) to create VMkernel interfaces for vMotion. For each IP address there must be a corresponding VLAN ID specified in vMotionVLAN. If JumboFrames is set to True the VMkernel interfaces are created with a MTU of 9000.
	.PARAMETER vMotionVLAN
	  Specifies VLAN ID for vMotion VMkernel port group. For each VLAN there must be a corresponding IP address specified in vMotionIP.
	  
	  0 = untagged. 4095 = trunked.
	.PARAMETER vMotionIPMask
	  Specifies single subnet mask applied to all vMotion VMkernel interfaces.
	.PARAMETER PortGroupName
	  Specifies virtual machine port group name. For each port group name there must be a corresponding VLAN ID specified in PortGroupVLAN and vSwitch specified in PortGroupSwitch.
	.PARAMETER PortGroupVLAN
	  Specifies virtual machine port group VLAN ID. For each port group VLAN ID there must be a corresponding port group name specified in PortGroupName and vSwitch specified in PortGroupSwitch.
	  
	  0 = untagged. 4095 = trunked.
	.PARAMETER PortGroupSwitch
	  Specifies virtual machine port group vSwitch. For each port group name there must be a corresponding port group name specified in PortGroupName and VLAN ID specified in PortGroupVLAN.
	.PARAMETER MgmtNic
	  Specifies unique physical NIC(s) to associate with vSwitch0. Example: vmnic0, vmnic1
	.PARAMETER StorageNic
	  Specifies unique physical NIC(s) to associate with a storage vSwitch. This will trigger a new vSwitch to be created and storage VMkernel interfaces to be associated with it. Example: vmnic2, vmnic3
	.PARAMETER vMotionNic
	  Specifies unique physical NIC(s) to associate with a vMotion vSwitch. This will trigger a new vSwitch to be created and vMotion VMkernel interfaces to be associated with it. Example: vmnic4, vmnic5
	.PARAMETER VmNic1
	  Specifies unique physical NIC(s) to associate with a virutal machine vSwitch. This will trigger a new vSwitch to be created. Example: vmnic6, vmnic7
	.PARAMETER VmNic2
	  Specifies unique physical NIC(s) to associate with a virutal machine vSwitch. This will trigger a new vSwitch to be created. Example: vmnic8
	.PARAMETER VmNic3
	  Specifies unique physical NIC(s) to associate with a virutal machine vSwitch. This will trigger a new vSwitch to be created. Example: vmnic9
	.PARAMETER vCenterServer
	  Specifies the vCenter server FQDN or IP address to join the host to.
	.PARAMETER vCenterUser
	  Specifies a vCenter server administrative user.
	.PARAMETER vCenterPassword
	  Specifies a vCenter server administrative user password.
	  
	  WARNING: This password is stored in cleartext. It is recommended to use vCenterCredential instead.
	.PARAMETER vCenterCredential
	  Specifies credentials to connect to vCenter.
	.PARAMETER Datacenter
	  Specifies vCenter Datacenter to place host into.
	.PARAMETER Cluster
	  Specifies host cluster to place host into.
	.PARAMETER JumboFrames
	  Specifies whether jumbo frames (MTU 9000) should be configured for IP storage and vMotion interfaces and vSwitches.

	.EXAMPLE
	  $HostCredential = Get-Credential
	  .\Configure-ESXiHost.ps1 -HostIP 192.168.1.10 -HostCredential $HostCredential -Hostname server1 -DomainName domain.local -DnsServer 192.168.1.101,192.168.1.102 -NtpServer 192.168.1.101
	  
	  A single standalone host without shared storage or vMotion and not joined to vCenter.
	.EXAMPLE
	  $HostCredential = Get-Credential
	  $servers = Import-Csv .\Servers.csv
	  foreach ($server in $servers){ $server | .\Configure-ESXiHost.ps1 -HostCredential $HostCredential }
	  
	  Multiple standalone hosts from a CSV without shared storage or vMotion and not joined to vCenter.
	.EXAMPLE
	  $HostCredential = Get-Credential
	  $vCenterCredential = Get-Credential
	  $HostConfig = @{
		   HostIP = 192.168.1.10
		   HostCredential = $HostCredential
		   Hostname = server1
		   DomainName = domain.local
		   DnsServer = 192.168.1.101,192.168.1.102
		   NtpServer = 192.168.1.101
		   StorageIP = 10.0.0.10
		   StorageVLAN = 100
		   StorageIPMask = 255.255.255.0
		   StorageTarget = 10.0.0.101,10.0.0.102
		   vMotionIP = 10.1.0.10
		   vMotionVLAN = 10
		   vMotionIPMask = 255.255.255.0
		   MgmtNic = vmnic0,vmnic1
		   StorageNic = vmnic2,vmnic3
		   vMotionNic = vmnic4,vmnic5
		   VmNic1 = vmnic6,vmnic7
		   PortGroupName = LAN-VLAN10,DMZ
		   PortGroupVLAN = 10,0
		   PortGroupSwitch = vSwitch3,vSwitch4
		   vCenterServer = vcenter.domain.local
		   vCenterCredential = $vCenterCredential
		   Datacenter = Site1
		   JumboFrames = $true
	  }
	  .\Configure-ESXiHost.ps1 @HostConfig
	  
	  A single clustered host with shared IP storage and vMotion using splatting.
#>

[cmdletbinding()]
param (
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[string]$HostIP,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[string]$Hostname = 'localhost',
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[array]$DnsServer,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[string]$DomainName,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[string]$SearchDomain,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[array]$NtpServer,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[string]$RootPassword,
	[PSCredential]$HostCredential,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[array]$StorageTarget,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[array]$StorageIP,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[array]$StorageVLAN,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[string]$StorageIPMask,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[array]$vMotionIP,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[array]$vMotionVLAN,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[string]$vMotionIPMask,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[array]$PortGroupName,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[array]$PortGroupVLAN,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[array]$PortGroupSwitch,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[array]$MgmtNic,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[array]$StorageNic,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[array]$vMotionNic,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[array]$VmNic1,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[array]$VmNic2,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[array]$VmNic3,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[string]$vCenterServer,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[string]$vCenterUser,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[string]$vCenterPassword,
	[PSCredential]$vCenterCredential,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[string]$Datacenter,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	[string]$Cluster,
	[parameter(ValueFromPipelineByPropertyName=$true)]
	$JumboFrames = $true
)

function Write-Log {
	param(
		[string]$Message,
		[ValidateSet("File", "Screen", "FileAndScreen")]
		[string]$OutTo = "FileAndScreen",
		[ValidateSet("Info", "Warn", "Error", "Verb", "Debug")]
		[string]$Level = "Info",
		[ValidateSet("Black", "DarkMagenta", "DarkRed", "DarkBlue", "DarkGreen", "DarkCyan", "DarkYellow", "Red", "Blue", "Green", "Cyan", "Magenta", "Yellow", "DarkGray", "Gray", "White")]
		[String]$ForegroundColor = "White",
		[ValidateRange(1,30)]
		[int]$Indent = 0,
		[switch]$Clobber,
		[switch]$NoNewLine
	)
	
	if (!($LogPath)){
		$LogPath = "$($env:ComputerName)-$(Get-Date -f yyyyMMdd).log"
	}
	
	$msg = "{0} : {1} : {2}{3}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Level.ToUpper(), ("  " * $Indent), $Message
	if ($OutTo -match "File"){
		if (($Level -ne "Verb") -or ($VerbosePreference -eq "Continue")){
			if ($Clobber){
				$msg | Out-File $LogPath -Force
			}else{
				$msg | Out-File $LogPath -Append
			}
		}
	}
	
	$msg = "{0}{1}" -f ("  " * $Indent), $Message
	if ($OutTo -match "Screen"){
		switch ($Level){
			"Info" {
				if ($NoNewLine){
					Write-Host $msg -ForegroundColor $ForegroundColor -NoNewLine
				}else{
					Write-Host $msg -ForegroundColor $ForegroundColor
				}
			}
			"Warn" {Write-Warning $msg}
			"Error" {$host.ui.WriteErrorLine($msg)}
			"Verb" {Write-Verbose $msg}
			"Debug" {Write-Debug $msg}
		}
	}
}

$LogPath = "$(Get-Date -f "yyyyMMdd").log"
$LogOutTo = "Screen"
$Indent = 1

Write-Log -OutTo $LogOutTo
Write-Log -OutTo $LogOutTo
Write-Log "=========== Starting $HostIP ===========" -OutTo $LogOutTo
Write-Log -OutTo $LogOutTo
Write-Log -OutTo $LogOutTo

#Form and sanitize arrays
if ($DnsServer){		$DnsServer			= (($DnsServer 			| Foreach-Object {$_.split(",")}) -replace '"|''','').Trim()}
if ($NtpServer){		$NtpServer			= (($NtpServer 			| Foreach-Object {$_.split(",")}) -replace '"|''','').Trim()}
if ($StorageIP){		$StorageIP			= (($StorageIP 			| Foreach-Object {$_.split(",")}) -replace '"|''','').Trim()}
if ($StorageVLAN){		$StorageVLAN		= (($StorageVLAN 		| Foreach-Object {$_.split(",")}) -replace '"|''','').Trim()}
if ($vMotionIP){		$vMotionIP			= (($vMotionIP 			| Foreach-Object {$_.split(",")}) -replace '"|''','').Trim()}
if ($vMotionVLAN){		$vMotionVLAN		= (($vMotionVLAN 		| Foreach-Object {$_.split(",")}) -replace '"|''','').Trim()}
if ($MgmtNic){			$MgmtNic			= (($MgmtNic 			| Foreach-Object {$_.split(",")}) -replace '"|''','').Trim()}
if ($StorageNic){		$StorageNic			= (($StorageNic 		| Foreach-Object {$_.split(",")}) -replace '"|''','').Trim()}
if ($vMotionNic){		$vMotionNic			= (($vMotionNic 		| Foreach-Object {$_.split(",")}) -replace '"|''','').Trim()}
if ($VmNic1){			$VmNic1				= (($VmNic1 			| Foreach-Object {$_.split(",")}) -replace '"|''','').Trim()}
if ($VmNic2){			$VmNic2				= (($VmNic2 			| Foreach-Object {$_.split(",")}) -replace '"|''','').Trim()}
if ($VmNic3){			$VmNic3				= (($VmNic3 			| Foreach-Object {$_.split(",")}) -replace '"|''','').Trim()}
if ($PortGroupName){	$PortGroupName		= (($PortGroupName 		| Foreach-Object {$_.split(",")}) -replace '"|''','').Trim()}
if ($PortGroupVLAN){	$PortGroupVLAN		= (($PortGroupVLAN 		| Foreach-Object {$_.split(",")}) -replace '"|''','').Trim()}
if ($PortGroupSwitch){	$PortGroupSwitch	= (($PortGroupSwitch 	| Foreach-Object {$_.split(",")}) -replace '"|''','').Trim()}
if ($StorageTarget){	$StorageTarget		= (($StorageTarget 		| Foreach-Object {$_.split(",")}) -replace '"|''','').Trim()}

#Input validation
if (($StorageIP.Count,$StorageVLAN.Count | Measure-Object -Average).Average -ne $StorageIP.Count){
	Write-Log "StorageIP and StorageVLAN must have the same number of values" -Level "Error" -OutTo $LogOutTo
	return
}
if (($vMotionIP.Count,$vMotionVLAN.Count | Measure-Object -Average).Average -ne $vMotionIP.Count){
	Write-Log "vMotionIP and vMotionVLAN must have the same number of values" -Level "Error" -OutTo $LogOutTo
	return
}
if (($PortGroupName.Count,$PortGroupSwitch.Count,$PortGroupVLAN.Count | Measure-Object -Average).Average -ne $PortGroupName.Count){
	Write-Log "PortGroupName, PortGroupSwitch, and PortGroupVLAN must have the same number of values" -Level "Error" -OutTo $LogOutTo
	return
}

#Determine host FQDN from hostname and domain name
if (($Hostname -ne "localhost") -and $DomainName){
	$HostFqdn = "$Hostname.$DomainName"
}

if ($HostFqdn){
	if (Resolve-DnsName -Name $HostFqdn -Type A -DnsOnly -ErrorAction SilentlyContinue){
		Write-Log "$HostFqdn resolved in DNS" -OutTo $LogOutTo
	}else{
		Write-Log "$HostFqdn does not resolve in DNS, using IP address" -Level "Warn" -OutTo $LogOutTo
		$HostFqdn = $HostIP
	}
}else{
	Write-Log "FQDN not defined, using IP address" -OutTo $LogOutTo
	$HostFqdn = $HostIP
}

#Set MTU
if ($JumboFrames){
	$Mtu = 9000
}else{
	$Mtu = 1500
}

Disconnect-VIServer -Confirm:$false -ErrorAction SilentlyContinue | Out-Null

#Connect to host
if (!($HostCredential)){
	$securePassword = ConvertTo-SecureString $RootPassword -AsPlainText -Force
	$HostCredential = New-Object -TypeName System.Management.Automation.PSCredential("root",$securePassword)
}

Write-Log "Connecting to host at $HostFqdn" -OutTo $LogOutTo
$Error.Clear()
Connect-VIServer $HostFqdn -Credential $HostCredential -ErrorAction SilentlyContinue | Out-Null
if ($Error){
	Write-Log "Failed to connect to host at $HostFqdn" -Level "Error" -OutTo $LogOutTo
	Write-Log $error.Exception.Message -Level "Error" -OutTo $LogOutTo
	return
}
Write-Log -OutTo $LogOutTo

#Data collection
$vmHost = Get-VMHost
$vmHardware = Get-VMHostHardware
Write-Log "Name:             $($vmHost.Name)" -OutTo $LogOutTo
Write-Log "Manufacturer:     $($vmHardware.Manufacturer)" -OutTo $LogOutTo
Write-Log "Model:            $($vmHardware.Model)" -OutTo $LogOutTo
Write-Log "Serial Number:    $($vmHardware.SerialNumber)" -OutTo $LogOutTo
Write-Log "BIOS:             $($vmHardware.BiosVersion)" -OutTo $LogOutTo
Write-Log "Processor:        $($vmHardware.CpuModel)" -OutTo $LogOutTo
Write-Log "Sockets:          $($vmHardware.CpuCount)" -OutTo $LogOutTo
Write-Log "Cores:            $($vmHardware.CpuCoreCountTotal)" -OutTo $LogOutTo
Write-Log "Hyper-threading:  $($vmHost.HyperthreadingActive)" -OutTo $LogOutTo
Write-Log "Memory:           $([math]::Round($vmHost.MemoryTotalGB))GB" -OutTo $LogOutTo
Write-Log "Storage:          $((Get-Datastore | Measure-Object -Property CapacityGB -Sum).Sum)GB" -OutTo $LogOutTo
Write-Log "NICs:             $($vmHardware.NicCount)" -OutTo $LogOutTo
Write-Log "Version:          $($vmHost.Version) $($vmHost.Build)" -OutTo $LogOutTo
Write-Log -OutTo $LogOutTo

#Set host in maintenance mode
Write-Log "Entering maintenance mode" -OutTo $LogOutTo
$vmHost | Set-VMHost -State Maintenance | Out-Null

#Set host network information
$vmHostNetworkInfo = Get-VmHostNetwork
if ($Hostname -ne 'localhost'){
	Write-Log "Setting hostname: $Hostname" -OutTo $LogOutTo
	Set-VMHostNetwork -Network $vmHostNetworkInfo -Hostname $Hostname | Out-Null
}
if ($DnsServer){
	Write-Log "Setting DNS servers: $DnsServer" -OutTo $LogOutTo
	Set-VMHostNetwork -Network $vmHostNetworkInfo -DnsAddress $DnsServer | Out-Null
}
if ($DomainName){
	Write-Log "Setting domain name: $DomainName" -OutTo $LogOutTo
	Set-VMHostNetwork -Network $vmHostNetworkInfo -DomainName $DomainName | Out-Null
}
if ($SearchDomain){
	Write-Log "Setting DNS search domains: $SearchDomain" -OutTo $LogOutTo
	Set-VMHostNetwork -Network $vmHostNetworkInfo -SearchDomain $SearchDomain | Out-Null
}

#Configure NTP servers and start service
if ($NtpServer){
	Write-Log "Setting NTP servers: $NtpServer" -OutTo $LogOutTo
	Add-VmHostNtpServer -NtpServer $NtpServer | Out-Null
	Write-Log "Setting NTP service to automatic" -OutTo $LogOutTo
	Set-VMHostService -HostService (Get-VMHostService | Where-Object {$_.key -eq "ntpd"}) -Policy "Automatic" | Out-Null
	$ntpd = Get-VMHostService | where {$_.key -eq "ntpd"}
	Restart-VMHostService $ntpd -Confirm:$false | Out-Null
}

#Create vSwitches
Write-Log "Creating vSwitches" -OutTo $LogOutTo
$i = 0
foreach ($nic in $MgmtNic){
	Get-VirtualSwitch -Name vSwitch0 | Add-VirtualSwitchPhysicalNetworkAdapter -VMHostPhysicalNic (Get-VMHostNetworkAdapter -Physical -Name $nic) -Confirm:$false | Out-Null
}
if ($StorageNic -and ($StorageNic -ne $MgmtNic)){
	$i++
	Write-Log "Creating vSwitch$i with MTU $Mtu" -Indent $Indent -OutTo $LogOutTo
	Write-log "Attaching $StorageNic" -Indent 2 -OutTo $LogOutTo
	New-VirtualSwitch -Name "vSwitch$i" -Nic $StorageNic -Mtu $Mtu | Out-Null
}
if ($vMotionNic -and ($vMotionNic -ne $MgmtNic) -and ($vMotionNic -ne $StorageNic)){
	$i++
	Write-Log "Creating vSwitch$i with MTU $Mtu" -Indent $Indent -OutTo $LogOutTo
	Write-log "Attaching $vMotionNic" -Indent 2 -OutTo $LogOutTo
	New-VirtualSwitch -Name "vSwitch$i" -Nic $vMotionNic -Mtu $Mtu | Out-Null
}
if ($VmNic1 -and ($VmNic1 -ne $MgmtNic)){
	$i++
	Write-Log "Creating vSwitch$i" -Indent $Indent -OutTo $LogOutTo
	Write-log "Attaching $VmNic1" -Indent 2 -OutTo $LogOutTo
	New-VirtualSwitch -Name "vSwitch$i" -Nic $VmNic1 | Out-Null
}
if ($VmNic2 -and ($VmNic2 -ne $VmNic1)){
	$i++
	Write-Log "Creating vSwitch$i" -Indent $Indent -OutTo $LogOutTo
	Write-log "Attaching $VmNic2" -Indent 2 -OutTo $LogOutTo
	New-VirtualSwitch -Name "vSwitch$i" -Nic $VmNic2 | Out-Null
}
if ($VmNic3 -and ($VmNic3 -ne $VmNic1)){
	$i++
	Write-Log "Creating vSwitch$i" -Indent $Indent -OutTo $LogOutTo
	Write-log "Attaching $VmNic3" -Indent 2 -OutTo $LogOutTo
	New-VirtualSwitch -Name "vSwitch$i" -Nic $VmNic3 | Out-Null
}

#Remove default port group
Get-VirtualPortGroup -Name "VM Network" | Remove-VirtualPortGroup -Confirm:$false

#Create port groups
if ($PortGroupName){
	Write-Log "Creating port groups" -OutTo $LogOutTo
	$i = 0
	foreach ($pg in $PortGroupName){
		Write-Log "Creating port group: $pg" -Indent $Indent -OutTo $LogOutTo
		New-VirtualPortGroup -Name $pg -VirtualSwitch $PortGroupSwitch[$i] -VLanId $PortGroupVLAN[$i] | Out-Null
		$i++
	}
}

#Create storage vmkernel interfaces
if ($StorageIP){
	Write-Log "Creating IP storage VMkernel interfaces" -OutTo $LogOutTo
	$i = 0
	foreach ($ip in $StorageIP){
		Write-Log "Creating interface: Storage$($i+1)" -Indent $Indent -OutTo $LogOutTo
		$switch = Get-VirtualSwitch | Where-Object {$_.Nic -eq $StorageNic[0]}
		New-VirtualPortGroup -Name "Storage$($i+1)" -VirtualSwitch $switch.Name -VLanId $StorageVLAN[$i] | Out-Null
		New-VMHostNetworkAdapter -PortGroup "Storage$($i+1)" -VirtualSwitch $switch.Name -IP $ip -SubnetMask $StorageIPMask -Mtu $Mtu | Out-Null
		Get-VirtualPortGroup -Name "Storage$($i+1)" | Get-NicTeamingPolicy | Set-NicTeamingPolicy -MakeNicActive $StorageNic[$i] -MakeNicUnused ($StorageNic | Where-Object {$_ -ne $StorageNic[$i]}) | Out-Null
		$i++
	}
}

#Create vmotion vmkernel interfaces
if ($vMotionIP){
	Write-Log "Creating vMotion VMkernel interfaces" -OutTo $LogOutTo
	$i = 0
	foreach ($ip in $vMotionIP){
		Write-Log "Creating interface: vMotion$($i+1)" -Indent $Indent -OutTo $LogOutTo
		$switch = Get-VirtualSwitch | Where-Object {$_.Nic -eq $vMotionNic[0]}
		New-VirtualPortGroup -Name "vMotion$($i+1)" -VirtualSwitch $switch.Name -VLanId $vMotionVLAN[$i] | Out-Null
		New-VMHostNetworkAdapter -PortGroup "vMotion$($i+1)" -VirtualSwitch $switch.Name -IP $ip -SubnetMask $vMotionIPMask -Mtu $Mtu -VMotionEnabled $true | Out-Null
		Get-VirtualPortGroup -Name "vMotion$($i+1)" | Get-NicTeamingPolicy | Set-NicTeamingPolicy -MakeNicActive $vMotionNic[$i] -MakeNicStandby ($vMotionNic | Where-Object {$_ -ne $vMotionNic[$i]}) | Out-Null
		$i++
	}
}

#Rename default datastore to include hostname if joining to vCenter
if ($vCenterServer){
	Write-Log "Renaming default datastore: $($Hostname):datastore1" -OutTo $LogOutTo
	Set-Datastore -Datastore datastore1 -Name "$($Hostname):datastore1" | Out-Null
}

#Configure iSCSI storage
if ($StorageTarget){
	#$hba = Get-VMHostHba -VMHost $HostName -Type iSCSI | %{$_.Device}
	#$hba = Get-VMHostHba -Type iSCSI | Foreach-Object {$_.Device}
	#$hba = $vmHost | Get-VMHostHba -Type iScsi | Where-Object {$_.Model -eq "iSCSI Software Adapter"}
	
	<# $esxcli = Get-EsxCli
	$esxcli.swiscsi.nic.add($hba,$vmk1number)
	$esxcli.swiscsi.nic.add($hba,$vmk2number) #>
	
	Write-Log "Enabling software iSCSI initiator" -OutTo $LogOutTo
	Get-VMHostStorage | Set-VMHostStorage -SoftwareIScsiEnabled $true | Out-Null
	
	Write-Log "Configuring software iSCSI initiator" -OutTo $LogOutTo
	foreach ($ip in $StorageTarget){
		Write-Log "Adding $ip" -Indent $Indent -OutTo $LogOutTo
		$vmHost | Get-VMHostHba -Type iScsi | Where-Object {$_.Model -eq "iSCSI Software Adapter"} | New-IScsiHbaTarget -Address $ip | Out-Null
	}
}

#Exit maintenance mode if not being joined to vCenter
if (!($vCenterServer)){
	Write-Log "Exiting maintenance mode" -OutTo $LogOutTo
	$vmHost | Set-VMHost -State Connected | Out-Null
}

#Disconnect from host
Write-Log "Disconnecting from $HostFqdn" -OutTo $LogOutTo
Disconnect-VIServer $HostFqdn -Confirm:$false
Write-Log -OutTo $LogOutTo

#Join to vCenter
if ($vCenterServer){
	#Connect to vCenter
	Write-Log "Connecting to vCenter at $vCenterServer" -OutTo $LogOutTo
	Connect-VIServer $vCenterServer -User $vCenterUser -Password $vCenterPassword
	
	#Join to vCenter
	Write-Log "Joining $HostFqdn to $vCenterServer in $Datacenter" -OutTo $LogOutTo
	Add-VMHost $HostFqdn -Location (Get-Datacenter $Datacenter) -user root -password $RootPassword -Force
	
	#Move to cluster
	if ($Cluster){
		Write-Log "Move $HostFqdn into cluster $Cluster" -OutTo $LogOutTo
		Move-VMHost $HostFqdn -Location $Cluster
	}
	
	#Disconnect from vCenter
	Write-Log "Disconnecting from $vCenterServer" -OutTo $LogOutTo
	Disconnect-VIServer $vCenterServer -Confirm:$false
	Write-Log -OutTo $LogOutTo
}