**Default Settings**
```
New-Item -Path "HKLM:\Software\Policies\VMware, Inc." -Name "VMware Blast" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\VMware, Inc.\VMware Blast" -Name "Config" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "UdpEnabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderH264Enabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "H264maxQP" -PropertyType DWORD -Value "36" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "H264minQP" -PropertyType DWORD -Value "10" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "JpegQualityLow" -PropertyType DWORD -Value "25" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "JpegQualityMid" -PropertyType DWORD -Value "35" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "JpegQualityHigh" -PropertyType DWORD -Value "90" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderMaxFPS" -PropertyType DWORD -Value "30" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MaxBandwidthKbps" -PropertyType DWORD -Value "2147483647" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MinBandwidthKbps" -PropertyType DWORD -Value "256" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MaxBandwidthKbpsPerMegaPixelSlope" -PropertyType DWORD -Value "6200" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderBuildToPNG" -PropertyType String -Value "0" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "BlankScreenEnabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
```
