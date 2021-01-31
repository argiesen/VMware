### Data Collection
https://kb.vmware.com/s/article/1027206

```
# vmware -v
VMware ESXi 6.5.0 build-8294253

# esxcfg-info | less -I
|----Product Name.............................................PowerEdge R630
|----Vendor Name..............................................Dell Inc.
|----BIOS Version.............................................2.6.0

# esxcli network nic list

Name    PCI Device    Driver  Admin Status  Link Status  Speed  Duplex  MAC Address         MTU  Description
------  ------------  ------  ------------  -----------  -----  ------  -----------------  ----  -------------------------------------------------
vmnic0  0000:01:00.0  ixgbe   Up            Up           10000  Full    24:6e:96:2f:69:80  1500  Intel(R) Ethernet Controller X540-AT2
vmnic1  0000:01:00.1  ixgbe   Up            Up           10000  Full    24:6e:96:2f:69:82  9000  Intel(R) Ethernet Controller X540-AT2
vmnic2  0000:06:00.0  igbn    Up            Up            1000  Full    24:6e:96:2f:69:84  9000  Intel Corporation I350 Gigabit Network Connection
vmnic3  0000:06:00.1  igbn    Up            Up            1000  Full    24:6e:96:2f:69:85  1500  Intel Corporation I350 Gigabit Network Connection
vmnic4  0000:04:00.0  ixgbe   Up            Up           10000  Full    a0:36:9f:b6:81:20  1500  Intel(R) Ethernet Controller 10G X550T
vmnic5  0000:04:00.1  ixgbe   Up            Down             0  Half    a0:36:9f:b6:81:22  1500  Intel(R) Ethernet Controller 10G X550T

# esxcli network nic get -n vmnic0
   Driver Info:
         Bus Info: 0000:01:00.0
         Driver: ixgbe
         Firmware Version: 0x800005a0, 18.3.6
         Version: 4.5.1-iov

# vmkchdev -l | grep vmnic0
0000:01:00.0 8086:1528 1028:1f61 vmkernel vmnic0

# esxcfg-scsidevs -a
vmhba0  lsi_mr3           link-n/a  sas.51866da0803a3b00                    (0000:02:00.0) Avago (LSI) PERC H730 Mini
vmhba1  vmw_ahci          link-n/a  sata.vmhba1                             (0000:00:11.4) Intel Corporation Wellsburg AHCI Controller
vmhba2  vmw_ahci          link-n/a  sata.vmhba2                             (0000:00:1f.2) Intel Corporation Wellsburg AHCI Controller
vmhba32 vmkusb            link-n/a  usb.vmhba32                             () USB

# vmkload_mod -s lsi_mr3 | grep -i version
Version: 7.703.18.00-1OEM.650.0.0.4598673

# vmkload_mod -s vmw_ahci | grep -i version
Version: 1.1.1-1vmw.650.2.50.8294253

# vmkchdev -l | grep vmhba0
0000:02:00.0 1000:005d 1028:1f49 vmkernel vmhba0

# vmkchdev -l | grep vmhba1
0000:00:11.4 8086:8d62 1028:0601 vmkernel vmhba1

```

### Patching
```
  1. Download patch from patch portal
  2. Upload patch to datastore
  3. vim-cmd hostsvc/maintenance_mode_enter
  4. esxcli software vib install -d /vmfs/volumes/datastore1/patch-directory/ESXi600-201608001.zip
  5. esxcli system shutdown reboot -r "Patching"
  6. vim-cmd hostsvc/maintenance_mode_exit
```

### Upgrades
```
  1. Download offline bundle or patch from patch portal
  2. Upload to data store
  3. vim-cmd hostsvc/maintenance_mode_enter
  4. esxcli software sources profile list -d /vmfs/volumes/datastore1/update-from-esxi6.0-6.0_update02.zip
  5. esxcli software profile update -d /vmfs/volumes/datastore1/update-from-esxi6.0-6.0_update02.zip -p ESXi-6.0.0-20170702001-standard
  6. esxcli system shutdown reboot -r "Upgrade"
  7. vim-cmd hostsvc/maintenance_mode_exit
```
