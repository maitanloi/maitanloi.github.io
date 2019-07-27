---
layout: post
title:  "Fix lỗi Could not get lock"
date:   2019-07-27 14:39:00 +0700
category: linux
tags: [linux,update,kali]
---
### Lỗi khi update
```sh
E: Could not get lock /var/lib/dpkg/lock-frontend - open (11: Resource temporarily unavailable)
E: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), is another process using it?
```
![Could not get lock][dpkg-lock]


```sh
ps aux | grep -i apt
kill <id>
```


[dpkg-lock]: /assets/img/07-2019/dpkg-lock.png
