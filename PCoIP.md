### Profile C
```
New-Item -Path "HKLM:\Software\Policies" -Name "Teradici" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\Teradici" -Name "PCoIP" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\Teradici\PCoIP" -Name "pcoip_admin_defaults" -Force | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.max_link_rate" -PropertyType DWORD -Value "4000000" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.audio_bandwidth_limit" -PropertyType DWORD -Value "48" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.minimum_image_quality" -PropertyType DWORD -Value "40" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "maximum_initial_image_quality" -PropertyType DWORD -Value "70" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "maximum_frame_rate" -PropertyType DWORD -Value "16" -Force -ErrorAction SilentlyContinue | Out-Null
```

### Profile D
```
New-Item -Path "HKLM:\Software\Policies" -Name "Teradici" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\Teradici" -Name "PCoIP" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\Teradici\PCoIP" -Name "pcoip_admin_defaults" -Force | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.max_link_rate" -PropertyType DWORD -Value "1200000" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.audio_bandwidth_limit" -PropertyType DWORD -Value "48" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "pcoip.minimum_image_quality" -PropertyType DWORD -Value "30" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "maximum_initial_image_quality" -PropertyType DWORD -Value "70" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Teradici\PCoIP\pcoip_admin_defaults" -Name "maximum_frame_rate" -PropertyType DWORD -Value "8" -Force -ErrorAction SilentlyContinue | Out-Null
```
