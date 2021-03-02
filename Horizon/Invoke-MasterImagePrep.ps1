[cmdletbinding()]
param (
	[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
	[string]$HorizonAgentPath,
	[bool]$FeaturePerformanceTracker = $false,
	[bool]$FeatureUSBRedirection = $false,
	[bool]$FeatureScannerRedirection = $false,
	[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
	[string]$DEMAgentPath,
	[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
	[string]$DEMLicensePath,
	[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
	[string]$AppVolumesAgentPath,
	[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
	[string]$FSLogixAgentPath,
	[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
	[string]$RootCertificatePath,
	[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
	[string]$VMwareOSOTPath,
	[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
	[string]$VMwareOSOTSelectionPath,
	[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
	[string]$OneDrivePath,
	[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
	[string]$MSTeamsPath,
	[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
	[string]$AppVolumesManagerFQDN,
	[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
	[int]$AppVolumesManagerPort = 443,
	[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
	[bool]$AppVolumesManagerWritableVolumes = $false,
	[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
	[bool]$SkipWindowsActivation = $false,
	[bool]$AllowMAKActivation = $false
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

function Install-Software {
	[CmdletBinding(SupportsShouldProcess = $true, SupportsPaging = $true)]
	param (
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true, HelpMessage = "No installation file specified")]
		[ValidateNotNullOrEmpty()]
		[string]$File,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[array]$Switches,
		[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[string]$Title,
		[parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true)]
		[string]$WaitForProcessName,
		[parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern("^HKLM:|^HKCU:|^\D:\\|^\\\\\w")]
		[string]$ConfirmPath,
		[parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true)]
		[string]$ConfirmName,
		[parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true)]
		[string]$ConfirmHotfix,
		[parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true)]
		[array]$IgnoreExitCodes,
		[parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true)]
		[switch]$DontWait,
		[parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true)]
		[ValidateSet("Continue", "Stop")]
		[string]$ErrorHandling = "Continue"
	)

	if ($Title){
		Write-Log "Installing $Title"
	}

	if ($ConfirmPath){
		if (Test-Path $ConfirmPath){
			Write-Log "Already installed." -Indent $Indent -OutTo $LogOutTo
			return
		}
	}elseif ($ConfirmName){
		$name64 = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.DisplayName -match $ConfirmName}
		$name32 = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.DisplayName -match $ConfirmName}
		if ($name64 -or $name32){
			Write-Log "Already installed." -Indent $Indent -OutTo $LogOutTo
			return
		}
	}elseif ($ConfirmHotfix){
		if (Get-Hotfix $ConfirmHotfix -ErrorAction SilentlyContinue){
			Write-Log "Already installed." -Indent $Indent -OutTo $LogOutTo
			return
		}
	}
	
	if ((Split-Path $File) -eq ""){
		if (Test-Path "$(Get-Location)\$File"){
			$File = "$(Get-Location)\$File"
		}elseif (Test-Path "C:\Windows\System32\$File"){
			$File = "C:\Windows\System32\$File"
		}else{
			Write-Log "Installation failed: Unable to resolve File." -Level "Error" -Indent $Indent -OutTo $LogOutTo
			if ($ErrorHandling -eq "Continue"){
				return
			}elseif ($ErrorHandling -eq "Stop"){
				exit
			}
		}
	}
	
	$error.clear()
	if (Test-Path $File){
		Write-Log "Install string: $File $Switches" -Indent $Indent -OutTo $LogOutTo
		
		Push-Location
		Set-Location (Split-Path $File)
		if ($Switches){
			if ($DontWait){
				$process = Start-Process -FilePath (Split-Path $File -Leaf) -Verb RunAs -ArgumentList $Switches -Passthru
			}else{
				$process = Start-Process -FilePath (Split-Path $File -Leaf) -Verb RunAs -ArgumentList $Switches -Wait -Passthru
			}
		}else{
			if ($DontWait){
				$process = Start-Process -FilePath (Split-Path $File -Leaf) -Verb RunAs -Passthru
			}else{
				$process = Start-Process -FilePath (Split-Path $File -Leaf) -Verb RunAs -Wait -Passthru
			}
		}
		Pop-Location
		if (!($DontWait)){
			if ($IgnoreExitCodes){
				foreach ($errcode in $IgnoreExitCodes){
					if ($process.ExitCode -eq $errcode){
						$ignoreExitCode = $true
					}
				}
			}
			if ($ignoreExitCode){
				Write-Log "Installation returned error code that was ignored: $($process.ExitCode)" -Level "Warn" -Indent $Indent -OutTo $LogOutTo
			}elseif ($process.ExitCode -ne 0 -and $process.ExitCode -ne 3010){
				Write-Log "Installation returned error code: $($process.ExitCode)" -Level "Error" -Indent $Indent -OutTo $LogOutTo
				if ($ErrorHandling -eq "Continue"){
					return
				}elseif ($ErrorHandling -eq "Stop"){
					exit
				}
			}
		}

		if ($WaitForProcessName){
			Start-Sleep -s 1
			Write-Log "Waiting for process `"$WaitForProcessName`" to finish running" -Indent $Indent -OutTo $LogOutTo
			Wait-Process -Name $WaitForProcessName -ErrorAction SilentlyContinue -ErrorVariable wait
			if ($wait){
				$error.clear()
			}
		}
	}else{
		Write-Log "$File does not exist." -Level "Error" -Indent $Indent -OutTo $LogOutTo
		if ($ErrorHandling -eq "Continue"){
			return
		}elseif ($ErrorHandling -eq "Stop"){
			exit
		}
	}
	
	if ($error){
		Write-Log "Installation failed: An error has occurred." -Level "Error" -Indent $Indent -OutTo $LogOutTo
		Write-Log $error.Exception -Level "Error" -Indent $Indent -OutTo $LogOutTo
		if ($ErrorHandling -eq "Continue"){
			return
		}elseif ($ErrorHandling -eq "Stop"){
			exit
		}
	}elseif ($ConfirmPath){
		if (Test-Path $ConfirmPath){
			Write-Log "Installation successful" -Indent $Indent -OutTo $LogOutTo
		}else{
			Write-Log "Installation failed: Could not verify path." -Level "Error" -Indent $Indent -OutTo $LogOutTo
			Write-Log $ConfirmPath -Level "Error" -Indent $Indent -OutTo $LogOutTo
			if ($ErrorHandling -eq "Continue"){
				return
			}elseif ($ErrorHandling -eq "Stop"){
				exit
			}
		}
	}elseif ($ConfirmName){
		$name64 = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.DisplayName -match $ConfirmName}
		$name32 = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.DisplayName -match $ConfirmName}
		if ($name64 -or $name32){
			Write-Log "Installation successful" -Indent $Indent -OutTo $LogOutTo
		}else{
			Write-Log "Installation failed: Could not verify name." -Level "Error" -Indent $Indent -OutTo $LogOutTo
			Write-Log $ConfirmName -Level "Error" -Indent $Indent -OutTo $LogOutTo
			if ($ErrorHandling -eq "Continue"){
				return
			}elseif ($ErrorHandling -eq "Stop"){
				exit
			}
		}
	}elseif ($ConfirmHotfix){
		if (Get-Hotfix $ConfirmHotfix -ErrorAction SilentlyContinue){
			Write-Log "Installation successful" -Indent $Indent -OutTo $LogOutTo
		}else{
			Write-Log "Installation failed: Could not verify hotfix." -Level "Error" -Indent $Indent -OutTo $LogOutTo
			Write-Log $ConfirmHotfix -Level "Error" -Indent $Indent -OutTo $LogOutTo
			if ($ErrorHandling -eq "Continue"){
				return
			}elseif ($ErrorHandling -eq "Stop"){
				exit
			}
		}
	}else{
		Write-Log "Installation successful" -Indent $Indent -OutTo $LogOutTo
	}
} # end function Install-Software

$LogPath = "HorizonBaseImage.log"
$LogOutTo = "FileAndScreen"
$Indent = 1

Write-Log "Starting script ($(Get-Date -f "MM/dd/yy HH:mm:ss"))"
Write-Log

if ($RootCertificatePath){
	Write-Log "Importing root certificate"
	Import-Certificate -FilePath $RootCertificatePath -CertStoreLocation Cert:\LocalMachine\Root | Out-Null
}

if ($HorizonAgentPath){
	#Horizon Agent Features
	#https://docs.vmware.com/en/VMware-Horizon/2012/virtual-desktops/GUID-3096DA8B-034B-435B-877E-5D2B18672A95.html
	$HorizonAgentFeatures = "ADDLOCAL=BlastUDP,Core,HelpDesk,NGVC,PrintRedir,ClientDriveRedirection,RTAV,RDP,TSMMR,V4V,VmwVaudio,VmwVdisplay,VmwVidd"
	
	if ($FeatureUSBRedirection){
		$HorizonAgentFeatures = $HorizonAgentFeatures + ",USB"
	}
	if ($FeatureScannerRedirection){
		$HorizonAgentFeatures = $HorizonAgentFeatures + ",ScannerRedirection"
	}
	if ($FeaturePerformanceTracker){
		$HorizonAgentFeatures = $HorizonAgentFeatures + ",PerfTracker"
	}
	
	$args = "/s","/v","/qn","VDM_VC_MANAGED_AGENT=1","RDP_CHOICE=1","INSTALL_VDISPLAY_DRIVER=1",$HorizonAgentFeatures,"REBOOT=ReallySuppress"
	Install-Software -Title "VMware Horizon Agent" -File $HorizonAgentPath -Switches $args -ErrorHandling "Stop"
	
	Write-Log "Setting Logon Monitor service to automatic"
	Set-Service vmlm -StartupType Automatic
}

if ($SkipWindowsActivation){
	#Windows 7
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\vmware-viewcomposer-ga" -Name "SkipLicenseActivation" -PropertyType DWORD -Value "0x00000001" -Force -ErrorAction SilentlyContinue | Out-Null
	#Windows 10
	New-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Services\vmware-viewcomposer-ga" -Name "SkipLicenseActivation" -PropertyType DWORD -Value "0x00000001" -Force -ErrorAction SilentlyContinue | Out-Null
}

if ($AllowMAKActivation){
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\vmware-viewcomposer-ga" -Name "AllowActivateMAKLicense" -PropertyType DWORD -Value "0x00000001" -Force -ErrorAction SilentlyContinue | Out-Null
}

if ($DEMAgentPath){
	$args = "/i","`"$DEMAgentPath`"","/qn","ADDLOCAL=FlexEngine","LICENSEFILE=`"$DEMLicensePath`""
	Install-Software -Title "VMware DEM Agent" -File "msiexec.exe" -Switches $args -ErrorHandling "Stop"
}

if ($FSLogixAgentPath){
	Install-Software -Title "FSLogix Agent" -File $FSLogixAgentPath -Switches "/install","/quiet","/norestart" -ErrorHandling "Stop"
}

if ($OneDrivePath){
	Install-Software -Title "OneDrive (Machine Installer)" -File $OneDrivePath -Switches "/allusers" -ErrorHandling "Stop"
	
	Write-Log "Disabling OneDrive update scheduled task"
	Get-ScheduledTask -TaskName "OneDrive Per-Machine Standalone Update Task" | Disable-ScheduledTask | Out-Null
}

if ($MSTeamsPath){
	$args = "/i","`"$MSTeamsPath`"","ALLUSER=1","ALLUSERS=1"
	Install-Software -Title "Microsoft Teams (Machine Installer)" -File "msiexec.exe" -Switches $args -ErrorHandling "Stop"
	
	#Exclusions for FSLogix or App Volumes?
}

# CLEAN UP TASKS
# DELETE DESKTOP SHORTCUTS
Write-Log "Removing desktop shortcuts"
Get-ChildItem -Path "C:\Users\Public\Desktop" -Filter *.lnk | Remove-Item -Force -Confirm:$false

if ($AppVolumesAgentPath){
	$args = "/i","`"$AppVolumesAgentPath`"","/qn","MANAGER_ADDR=$AppVolumesManagerFQDN","MANAGER_PORT=$AppVolumesManagerPort","REBOOT=ReallySuppress"
	Install-Software -Title "VMware App Volumes Agent" -File "msiexec.exe" -Switches $args -ErrorHandling "Stop"
	
	if ($AppVolumesManagerWritableVolumes){
		#https://kb.vmware.com/s/article/2128266
		New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\svdriver\parameters" -Name "DriveLetterSettings" -PropertyType DWORD -Value "6" -Force -ErrorAction SilentlyContinue | Out-Null
	}
}

if ($VMwareOSOTPath){
	Write-Log "Running OSOT optimization"
	if ($VMwareOSOTSelectionPath){
		. $VMwareOSOTPath -optimize -v -applyoptimization $VMwareOSOTSelectionPath
	}else{
		. $VMwareOSOTPath -optimize -v
	}
	
	Write-Log "Running OSOT generalization..."
	. $VMwareOSOTPath -generalize -reboot -v
	
	Write-Log "Reboot after OSOT generalization"
}
