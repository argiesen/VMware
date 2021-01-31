


Write-Host "Optimize PCoIP or Blast Extreme?"
Write-Host
Write-Host "1: PCoIP"
Write-Host "2: Blast Extreme"
Write-Host
$input = Read-Host "Please make a selection"
switch ($input){
	'1' {
		Write-Host 'You chose option #1 - PCoIP'
		Write-Host
		Write-Host "1: Profile A - Bandwidth: Highest (LAN)`t`tUser experience: Best`t`tUses Cases: Artists/Designers/Scientists/Engineers"
		Write-Host "2: Profile B - Bandwidth: High (LAN/WAN)`tUser experience: Great`t`tUses Cases: Artists/Designers/Scientists/Engineers"
		Write-Host "3: Profile C - Bandwidth: Optimized`t`tUser experience: Good`t`tUses Cases: Knowledge Workers"
		Write-Host "4: Profile D - Bandwidth: Constrained`t`tUser experience: Good`t`tUses Cases: Knowledge Workers/Task Workers"
		Write-Host "5: Profile E - Bandwidth: Lowest`t`tUser experience: Limited`tUses Cases: Task Workers"
	} '2' {
		Write-Host 'You chose option #2 - Blast Extreme'
		Write-Host
		Write-Host "1: High-speed LAN`t`t`t- Max Session BW: 900Mbps`tMin Session BW: 64Kbps`tBuild-to-Loss: Yes`tMax Initial Image Quality: 100`tMin Image Quality: 50`t Max FPS: 60"
		Write-Host "2: LAN`t`t`t`t`t- Max Session BW: 900Mbps`tMin Session BW: 64Kbps`tBuild-to-Loss: Yes`tMax Initial Image Quality: 90`tMin Image Quality: 50`t Max FPS: 30"
		Write-Host "3: Dedicated WAN`t`t`t- Max Session BW: 900Mbps`tMin Session BW: 64Kbps`tBuild-to-Loss: No`tMax Initial Image Quality: 80`tMin Image Quality: 40`t Max FPS: 30"
		Write-Host "4: Broadband WAN`t`t`t- Max Session BW: 5Mbps`tMin Session BW: 64Kbps`tBuild-to-Loss: No`tMax Initial Image Quality: 70`tMin Image Quality: 40`t Max FPS: 20"
		Write-Host "5: Low-speed WAN`t`t`t- Max Session BW: 2Mbps`tMin Session BW: 64Kbps`tBuild-to-Loss: No`tMax Initial Image Quality: 70`tMin Image Quality: 30`t Max FPS: 15"
		Write-Host "6: Extremely low-speed connection`t- Max Session BW: 1Mbps`tMin Session BW: 64Kbps`tBuild-to-Loss: No`tMax Initial Image Quality: 70`tMin Image Quality: 30`t Max FPS: 10"
	} 'q' {
		return
	}
}

