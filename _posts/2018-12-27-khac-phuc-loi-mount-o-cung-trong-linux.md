---
layout: post
title:  "Khắc phục lỗi mount ổ cứng trong Linux"
date:   2018-12-27 16:51:00 +0700
category: linux
tags: [mount,ntfsfix, linux]
---

Error:
```
The disk contains an unclean file system (0, 0).
Metadata kept in Windows cache, refused to mount.
Falling back to read-only mount because the NTFS partition is in an
unsafe state. Please resume and shutdown Windows fully (no hibernation
or fast restarting.)
```
If you can't access the drive, execute the following command:  
```terminal
$ sudo ntfsfix /dev/sda5
```
```terminal
Mounting volume... The disk contains an unclean file system (0, 0).
Metadata kept in Windows cache, refused to mount.
FAILED
Attempting to correct errors...
Processing $MFT and $MFTMirr...
Reading $MFT... OK
Reading $MFTMirr... OK
Comparing $MFTMirr to $MFT... OK
Processing of $MFT and $MFTMirr completed successfully.
Setting required flags on partition... OK
Going to empty the journal ($LogFile)... OK
Checking the alternate boot sector... OK
NTFS volume version is 3.1.
NTFS partition /dev/sda5 was processed successfully.
```

Then, mount with:  

```terminal
$ sudo mount -o rw /dev/sda5 /media/loimai/Data
```
You can disable fast startup by following these steps under "Power Options"  
Go to **Control Panel** > **Hardware and Sound** > **Power Options** > **System Setting** > Choose what the power buttons do and uncheck the Turn on fast startup box.  
![Turn off fast startup][off-fast-startup]

[off-fast-startup]: /assets/img/12-2018/turn-off-fast-starup.png
