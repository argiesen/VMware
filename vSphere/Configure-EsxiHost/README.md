# Configure-EsxiHost
This script automates the configuration of ESXi hosts, including:
 - Hostname
 - Domain name
 - DNS servers
 - NTP servers
 - vSwitches
 - Port groups
 - VMkernels
 - vMotion
 - iSCSI storage
 - Join to vCenter
 - Add to cluster

## EXAMPLE
    A single standalone host without shared storage or vMotion and not joined to vCenter:

    $HostCredential = Get-Credential
    .\Configure-ESXiHost.ps1 -HostIP 192.168.1.10 -HostCredential $HostCredential -Hostname server1 -DomainName domain.local -DnsServer 192.168.1.101,192.168.1.102 -NtpServer 192.168.1.101

## EXAMPLE
    Multiple standalone hosts from a CSV without shared storage or vMotion and not joined to vCenter:

    $HostCredential = Get-Credential
    $servers = Import-Csv .\Servers.csv
    foreach ($server in $servers){ $server | .\Configure-ESXiHost.ps1 -HostCredential $HostCredential }

## EXAMPLE
    A single clustered host with shared IP storage and vMotion using splatting:

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
