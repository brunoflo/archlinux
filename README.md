# Arch Linux Installation Process
Automation of the process described in the official Arch [wiki](https://wiki.archlinux.org/title/Installation_guide)


Load your language keymap, es for spanish keyboard

```
loadkeys es
```

Set a different font if desired
```
setfont ter-132b
```

Verify the boot mode, the scripts assume that it is '64-bit x64 UEFI' (so it should return 64)
```
cat /sys/firmware/efi/fw_platform_size
```

Connect to the internet
```
ip link
```

Download and execute script 'install_script.sh', after that you will be in the installed system.

Downlad and execute the second script 'install_script2.sh', after that the computer is configured and will be rebooted.