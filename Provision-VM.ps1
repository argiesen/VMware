

function Rename-VMGuest {
	[cmdletbinding()]
	param (
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$VMName,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$NewName,
		[bool]$Restart = $true,
		[PSCredential]$GuestCredential
	)
	
	Invoke-VMScript -VM $VMName -ScriptType PowerShell -ScriptText "Rename-Computer -NewName $NewName" -GuestCredential $GuestCredential -Verbose
	
	if ($Restart){
		Write-Host "Restarting VM $VMName"
		Restart-VMGuest $VMName
	}
}

function Set-VMGuestIPAddress {
	[cmdletbinding()]
	param (
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$VMName,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$IPAddress,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$SubnetMask,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$DefaultGateway,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[alias("DnsServer")]
		[string]$DnsServer1,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[string]$DnsServer2,
		[PSCredential]$GuestCredential
	)
	
	if ($DnsServer2){
		[string]$DnsServers = "(`"$DnsServer1`",`"$DnsServer2`")"
	}elseif ($DnsServer1){
		[string]$DnsServers = "(`"$DnsServer1`")"
	}else{
		[string]$DnsServers = $null
	}
	
	$netsh = "c:\windows\system32\netsh.exe interface ip set address ""Ethernet0"" static $IPAddress $SubnetMask $DefaultGateway 1"
	Invoke-VMScript -VM $VMName -ScriptType bat -ScriptText $netsh -GuestCredential $GuestCredential -Verbose
	
	if ($DnsServers){
		Invoke-VMScript -VM $VMName -ScriptType PowerShell -ScriptText "Set-DnsClientServerAddress -InterfaceAlias Ethernet0 -ServerAddresses $DnsServers" -GuestCredential $GuestCredential -Verbose
	}
}

function Add-VMDomain {
	[cmdletbinding()]
	param (
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$VMName,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$DomainName,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[alias("OU")]
		[string]$OUPath,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[string]$NewName,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$DomainUsername,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$DomainPassword,
		[bool]$Restart = $true,
		[PSCredential]$GuestCredential
	)
	
	$joinDomain = '$ADJoinUsername = "ADDomain\ADUsername";
				   $ADJoinPassword = ConvertTo-SecureString -String "ADPassword" -AsPlainText -Force;
				   $ADJoinCredential = New-Object System.Management.Automation.PSCredential($ADJoinUsername,$ADJoinPassword);
				   Add-Computer -DomainName ADDomain -NewName NewGuestName -OUPath "ADOUPath" -Credential $ADJoinCredential -Force'
			
	$joinDomain = $joinDomain -replace 'ADUsername',$DomainUsername
	$joinDomain = $joinDomain -replace 'ADPassword',$DomainPassword
	$joinDomain = $joinDomain -replace 'ADDomain',$DomainName
	if ($NewName){
		$joinDomain = $joinDomain -replace 'NewGuestName',$NewName
	}else{
		$joinDomain = $joinDomain -replace ' -NewName NewGuestName',""
	}
	if ($OUPath){
		$joinDomain = $joinDomain -replace 'ADOUPath',$OUPath
	}else{
		$joinDomain = $joinDomain -replace ' -OUPath "ADOUPath"',""
	}
	
	Invoke-VMScript -VM $VMName -ScriptType PowerShell -ScriptText $joinDomain -GuestCredential $GuestCredential -Verbose
	
	if ($Restart){
		Write-Host "Restarting VM $VMName"
		Restart-VMGuest $VMName
	}
}

function Provision-VM {
	[cmdletbinding()]
	param (
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$VMName,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$NewName,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$IPAddress,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$SubnetMask,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$DefaultGateway,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[alias("DnsServer")]
		[string]$DnsServer1,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[string]$DnsServer2,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$DomainName,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[alias("OU")]
		[string]$OUPath,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$DomainUsername,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$DomainPassword,
		[bool]$Restart = $true,
		[PSCredential]$GuestCredential
	)
	
	#Set IP address
	if ($IPAddress){
		Write-Host "Updating guest IP address"
		Set-VMGuestIPAddress -VMName $VMName -IPAddress $IPAddress -SubnetMask $SubnetMask -DefaultGateway $DefaultGateway -DnsServer1 $DnsServer1 -DnsServer2 $DnsServer2 -GuestCredential $GuestCredential
	}
	
	#if joining domain, rename as domain joined; else rename
	if ($DomainName){
		Write-Host "Joining guest to domain"
		Add-VMDomain -VMName $VMName -NewName $NewName -DomainName $DomainName -OU $OUPath -DomainUsername $DomainUsername -DomainPassword $DomainPassword -Restart $false -GuestCredential $GuestCredential
	}elseif ($NewName){
		Write-Host "Renaming guest hostname"
		Rename-VMGuest -VMName $VMName -NewName $NewName -Restart $false -GuestCredential $GuestCredential
	}
	
	if ($Restart){
		Write-Host "Restarting VM"
		Restart-VMGuest $VMName
	}
}



Provision-VM -VMName arg-hcs1 -NewName hcs1 -IPAddress 172.19.247.231 -SubnetMask 255.255.255.0 -DefaultGateway 172.19.247.1 -DnsServer1 172.19.247.20 -DnsServer2 172.19.247.21 -DomainName LabSpk.local -OUPath "OU=Servers,OU=LabSpk,DC=LabSpk,DC=local" -DomainUsername agiesen -DomainPassword "Cnet2020!@#" -GuestCredential $templateCred
Provision-VM -VMName arg-hav1 -NewName hav1 -IPAddress 172.19.247.233 -SubnetMask 255.255.255.0 -DefaultGateway 172.19.247.1 -DnsServer1 172.19.247.20 -DnsServer2 172.19.247.21 -DomainName LabSpk.local -OUPath "OU=Servers,OU=LabSpk,DC=LabSpk,DC=local" -DomainUsername agiesen -DomainPassword "Cnet2020!@#" -GuestCredential $templateCred

