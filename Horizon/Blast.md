**Source:** https://docs.vmware.com/en/VMware-Horizon-7/7.5/horizon-remote-desktop-features/GUID-8AA01007-091F-4E44-B7C6-A48748631947.html

**Based on 7.5 defaults and bandwidth profiles**

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

```

**High-speed LAN**
```
New-Item -Path "HKLM:\Software\Policies\VMware, Inc." -Name "VMware Blast" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\VMware, Inc.\VMware Blast" -Name "Config" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "UdpEnabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderH264Enabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "H264maxQP" -PropertyType DWORD -Value "100" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "H264minQP" -PropertyType DWORD -Value "50" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderMaxFPS" -PropertyType DWORD -Value "60" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MaxBandwidthKbps" -PropertyType DWORD -Value "900000" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MinBandwidthKbps" -PropertyType DWORD -Value "64" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MaxBandwidthKbpsPerMegaPixelSlope" -PropertyType DWORD -Value "6200" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderBuildToPNG" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "BlankScreenEnabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
```

**LAN**
```
New-Item -Path "HKLM:\Software\Policies\VMware, Inc." -Name "VMware Blast" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\VMware, Inc.\VMware Blast" -Name "Config" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "UdpEnabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderH264Enabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "H264maxQP" -PropertyType DWORD -Value "90" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "H264minQP" -PropertyType DWORD -Value "50" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderMaxFPS" -PropertyType DWORD -Value "30" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MaxBandwidthKbps" -PropertyType DWORD -Value "900000" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MinBandwidthKbps" -PropertyType DWORD -Value "64" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MaxBandwidthKbpsPerMegaPixelSlope" -PropertyType DWORD -Value "6200" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderBuildToPNG" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "BlankScreenEnabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
```

**Dedicated WAN**
```
New-Item -Path "HKLM:\Software\Policies\VMware, Inc." -Name "VMware Blast" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\VMware, Inc.\VMware Blast" -Name "Config" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "UdpEnabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderH264Enabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "H264maxQP" -PropertyType DWORD -Value "80" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "H264minQP" -PropertyType DWORD -Value "40" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderMaxFPS" -PropertyType DWORD -Value "30" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MaxBandwidthKbps" -PropertyType DWORD -Value "900000" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MinBandwidthKbps" -PropertyType DWORD -Value "64" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MaxBandwidthKbpsPerMegaPixelSlope" -PropertyType DWORD -Value "6200" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderBuildToPNG" -PropertyType String -Value "0" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "BlankScreenEnabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
```

**Broadband WAN**
```
New-Item -Path "HKLM:\Software\Policies\VMware, Inc." -Name "VMware Blast" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\VMware, Inc.\VMware Blast" -Name "Config" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "UdpEnabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderH264Enabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "H264maxQP" -PropertyType DWORD -Value "70" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "H264minQP" -PropertyType DWORD -Value "40" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderMaxFPS" -PropertyType DWORD -Value "20" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MaxBandwidthKbps" -PropertyType DWORD -Value "5000" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MinBandwidthKbps" -PropertyType DWORD -Value "64" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MaxBandwidthKbpsPerMegaPixelSlope" -PropertyType DWORD -Value "6200" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderBuildToPNG" -PropertyType String -Value "0" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "BlankScreenEnabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
```

**Low-speed WAN**
```
New-Item -Path "HKLM:\Software\Policies\VMware, Inc." -Name "VMware Blast" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\VMware, Inc.\VMware Blast" -Name "Config" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "UdpEnabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderH264Enabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "H264maxQP" -PropertyType DWORD -Value "70" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "H264minQP" -PropertyType DWORD -Value "30" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderMaxFPS" -PropertyType DWORD -Value "15" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MaxBandwidthKbps" -PropertyType DWORD -Value "2000" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MinBandwidthKbps" -PropertyType DWORD -Value "64" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MaxBandwidthKbpsPerMegaPixelSlope" -PropertyType DWORD -Value "6200" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderBuildToPNG" -PropertyType String -Value "0" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "BlankScreenEnabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
```

**Extremely low-speed connection**
```
New-Item -Path "HKLM:\Software\Policies\VMware, Inc." -Name "VMware Blast" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\VMware, Inc.\VMware Blast" -Name "Config" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "UdpEnabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderH264Enabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "H264maxQP" -PropertyType DWORD -Value "70" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "H264minQP" -PropertyType DWORD -Value "30" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderMaxFPS" -PropertyType DWORD -Value "10" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MaxBandwidthKbps" -PropertyType DWORD -Value "1000" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MinBandwidthKbps" -PropertyType DWORD -Value "64" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "MaxBandwidthKbpsPerMegaPixelSlope" -PropertyType DWORD -Value "6200" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "EncoderBuildToPNG" -PropertyType String -Value "0" -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\VMware, Inc.\VMware Blast\Config" -Name "BlankScreenEnabled" -PropertyType String -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
```
