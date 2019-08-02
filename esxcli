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
