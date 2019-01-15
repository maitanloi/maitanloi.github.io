---
layout: post
title:  "Tạo mật khẩu MD5 bằng Python"
date:   2018-12-30 11:26:00 +0700
category: python
tags: [md5,hash,salt,python]
---
### MD5 Passwords
```python
import hashlib
password = "maitanloi"
hash = hashlib.md5 (password).hexdigest()
print (hash)
```

### Salting  
```python
import hashlib
password = "maitanloi"
salt = "L0iM@i"
hash = hashlib.md5 (password + salt).hexdigest()
print (hash)
```
