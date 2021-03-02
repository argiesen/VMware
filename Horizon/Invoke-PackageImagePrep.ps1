[cmdletbinding()]
param (
	[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
	[string]$AppVolumesAgentPath,
	[parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
	[string]$ComputerName
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
		[switch]$Uninstall,
		[parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true)]
		[ValidateSet("Continue", "Stop")]
		[string]$ErrorHandling = "Continue"
	)
	
	if ($Uninstall){
		$TitleText = "Uninstalling"
		$LogText = "Uninstallation"
		$StringText = "Uninstall"
	}else{
		$TitleText = "Installing"
		$LogText = "Installation"
		$StringText = "Install"
	}

	if ($Title){
		Write-Log "$TitleText $Title"
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
			Write-Log "$LogText failed: Unable to resolve File." -Level "Error" -Indent $Indent -OutTo $LogOutTo
			if ($ErrorHandling -eq "Continue"){
				return
			}elseif ($ErrorHandling -eq "Stop"){
				exit
			}
		}
	}
	
	$error.clear()
	if (Test-Path $File){
		Write-Log "$StringText string: $File $Switches" -Indent $Indent -OutTo $LogOutTo
		
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
				Write-Log "$LogText returned error code that was ignored: $($process.ExitCode)" -Level "Warn" -Indent $Indent -OutTo $LogOutTo
			}elseif ($process.ExitCode -ne 0 -and $process.ExitCode -ne 3010){
				Write-Log "$LogText returned error code: $($process.ExitCode)" -Level "Error" -Indent $Indent -OutTo $LogOutTo
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
		Write-Log "$LogText failed: An error has occurred." -Level "Error" -Indent $Indent -OutTo $LogOutTo
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
		Write-Log "$LogText successful" -Indent $Indent -OutTo $LogOutTo
	}
} # end function Install-Software

$LogPath = "HorizonPackageImage.log"
$LogOutTo = "FileAndScreen"
$Indent = 1

$AppVolumesAgentPath = (Get-Item $AppVolumesAgentPath).FullName

Write-Log "Starting script ($(Get-Date -f "MM/dd/yy HH:mm:ss"))"
Write-Log

if ($ComputerName){
	Write-Log "Renaming computer"
	Rename-Computer -NewName $ComputerName
}

Write-Log "Storing App Volumes Agent configuration"
$AppVolumesManagerFQDN = Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\CloudVolumes\Agent" -Name "Manager_Address"
$AppVolumesManagerPort = Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\CloudVolumes\Agent" -Name "Manager_Port"

$args = "/uninstall","/passive","/norestart"
Install-Software -Title "FSLogix Agent" -File "C:\ProgramData\Package Cache\{0e0d4c15-5669-4ee6-b2b3-bba2bb066ca2}\FSLogixAppsSetup.exe" -Switches $args -ErrorHandling "Stop" -Uninstall

$uninstallApps = "VMware Dynamic Environment Manager Enterprise",
	"VMware App Volumes Agent",
	"VMware Horizon Agent"

$installedApps = Get-WmiObject -Class Win32_Product

foreach ($app in $uninstallApps){
	$installedApps | Where-Object {$_.Name -match $app} | foreach-object -Process {
		$args = "/uninstall","`"$($_.IdentifyingNumber)`"","/passive","/norestart"
		Install-Software -Title "$app" -File "msiexec.exe" -Switches $args -ErrorHandling "Stop" -Uninstall
	}
}

$args = "/i","`"$AppVolumesAgentPath`"","/qn","MANAGER_ADDR=$($AppVolumesManagerFQDN.Manager_Address)","MANAGER_PORT=$($AppVolumesManagerPort.Manager_Port)","REBOOT=ReallySuppress"
Install-Software -Title "VMware App Volumes Agent" -File "msiexec.exe" -Switches $args -ErrorHandling "Stop"

Write-Log "Reboot machine (prompt)"
Restart-Computer -Confirm:$true