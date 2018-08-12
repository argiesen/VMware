**Source:** https://www.teradici.com/web-help/TER1105004/Sess-Plan_Admn-Gd.pdf

| Worker Type | Bandwidth | User Experience | Use Cases |
|-------------|-----------|-----------------|-----------|
| Profile A | Highest (LAN) | Best | Artists/Designers/Scientists/Engineers |
| Profile B | High (LAN/WAN) | Great | Artists/Designers/Scientists/Engineers |
| Profile C | Optimized | Good | Knowledge Workers |
| Profile D | Constrained | Good | Knowledge Workers/Task Workers |
| Profile E | Lowest | Limited | Task Workers |


#### Profile A - represents the best graphics experience, default for PCoIP Remote Workstation Cards.
```
New-Item -Path "HKLM:\Software\Policies" -Name "Teradici" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\Teradici" -Name "PCoIP" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\Teradici\PCoIP" -Name "pcoip_admin_defaults" -Force | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.max_link_rate" -PropertyType DWORD -Value "900000" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.audio_bandwidth_limit" -PropertyType DWORD -Value "256" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.minimum_image_quality" -PropertyType DWORD -Value "50" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.maximum_initial_image_quality" -PropertyType DWORD -Value "90" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.maximum_frame_rate" -PropertyType DWORD -Value "60" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.enable_build_to_lossless" -PropertyType DWORD -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
```

#### Profile B - represents a standard experience, default for PCoIP Standard and Graphics Agents.
```
New-Item -Path "HKLM:\Software\Policies" -Name "Teradici" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\Teradici" -Name "PCoIP" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\Teradici\PCoIP" -Name "pcoip_admin_defaults" -Force | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.max_link_rate" -PropertyType DWORD -Value "900000" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.audio_bandwidth_limit" -PropertyType DWORD -Value "256" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.minimum_image_quality" -PropertyType DWORD -Value "40" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.maximum_initial_image_quality" -PropertyType DWORD -Value "80" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.maximum_frame_rate" -PropertyType DWORD -Value "30" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.enable_build_to_lossless" -PropertyType DWORD -Value "0" -Force -ErrorAction SilentlyContinue | Out-Null
```

#### Profile C - represents bandwidth-optimized experience for knowledge workers operating in constrained network scenarios.
```
New-Item -Path "HKLM:\Software\Policies" -Name "Teradici" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\Teradici" -Name "PCoIP" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\Teradici\PCoIP" -Name "pcoip_admin_defaults" -Force | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.max_link_rate" -PropertyType DWORD -Value "4000" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.audio_bandwidth_limit" -PropertyType DWORD -Value "50" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.minimum_image_quality" -PropertyType DWORD -Value "40" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.maximum_initial_image_quality" -PropertyType DWORD -Value "70" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.maximum_frame_rate" -PropertyType DWORD -Value "15" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.enable_build_to_lossless" -PropertyType DWORD -Value "0" -Force -ErrorAction SilentlyContinue | Out-Null
```

#### Profile D - represents bandwidth-constrained experience for task workers operating in constrained network scenarios.
```
New-Item -Path "HKLM:\Software\Policies" -Name "Teradici" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\Teradici" -Name "PCoIP" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\Teradici\PCoIP" -Name "pcoip_admin_defaults" -Force | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.max_link_rate" -PropertyType DWORD -Value "1200" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.audio_bandwidth_limit" -PropertyType DWORD -Value "50" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.minimum_image_quality" -PropertyType DWORD -Value "30" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.maximum_initial_image_quality" -PropertyType DWORD -Value "70" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.maximum_frame_rate" -PropertyType DWORD -Value "8" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.enable_build_to_lossless" -PropertyType DWORD -Value "0" -Force -ErrorAction SilentlyContinue | Out-Null
```

#### Profile E - represents maximum bandwidth-constrained experience suitable for task workers only - for example 10 small screen users sharing a T1 link.
```
New-Item -Path "HKLM:\Software\Policies" -Name "Teradici" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\Teradici" -Name "PCoIP" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\Teradici\PCoIP" -Name "pcoip_admin_defaults" -Force | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.max_link_rate" -PropertyType DWORD -Value "300" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.audio_bandwidth_limit" -PropertyType DWORD -Value "0" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.minimum_image_quality" -PropertyType DWORD -Value "30" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.maximum_initial_image_quality" -PropertyType DWORD -Value "70" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.maximum_frame_rate" -PropertyType DWORD -Value "4" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.enable_build_to_lossless" -PropertyType DWORD -Value "0" -Force -ErrorAction SilentlyContinue | Out-Null
```
