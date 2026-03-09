---
title: "Ứng dụng Python cho giải quyết công việc hàng ngày"
date: 2026-03-09
tags: ["python", "automation", "productivity"]
categories: ["blog"]
draft: false
---

Python là một trong những ngôn ngữ lập trình phổ biến nhất hiện nay, không chỉ dành cho lập trình viên mà còn cho bất kỳ ai muốn tự động hóa công việc hàng ngày. Bài viết này giới thiệu một số ứng dụng thực tế của Python trong công việc.

## 1. Tự động hóa xử lý file

Thay vì đổi tên hàng trăm file thủ công, Python giúp bạn làm điều đó trong vài giây:

```python
import os

folder = "/path/to/files"
for i, filename in enumerate(os.listdir(folder)):
    ext = os.path.splitext(filename)[1]
    new_name = f"document_{i+1:03d}{ext}"
    os.rename(
        os.path.join(folder, filename),
        os.path.join(folder, new_name)
    )
```

## 2. Xử lý dữ liệu Excel

Đọc, lọc và tổng hợp dữ liệu từ file Excel mà không cần mở Excel:

```python
import pandas as pd

df = pd.read_excel("bao-cao-thang.xlsx")

# Lọc dữ liệu theo điều kiện
df_filtered = df[df["doanh_thu"] > 1000000]

# Tổng hợp theo phòng ban
summary = df.groupby("phong_ban")["doanh_thu"].sum()
summary.to_excel("tong-hop.xlsx")
```

## 3. Gửi email tự động

Gửi báo cáo định kỳ cho sếp mà không cần nhớ:

```python
import smtplib
from email.mime.text import MIMEText

msg = MIMEText("Báo cáo doanh thu tháng 3 đã sẵn sàng.")
msg["Subject"] = "Báo cáo tháng 3/2026"
msg["From"] = "you@company.com"
msg["To"] = "boss@company.com"

with smtplib.SMTP("smtp.company.com", 587) as server:
    server.starttls()
    server.login("you@company.com", "app_password")
    server.send_message(msg)
```

## 4. Thu thập dữ liệu từ web

Lấy thông tin giá cả, tin tức, hoặc dữ liệu từ website:

```python
import requests
from bs4 import BeautifulSoup

response = requests.get("https://example.com/gia-vang")
soup = BeautifulSoup(response.text, "html.parser")

prices = soup.select(".price-item")
for item in prices:
    print(item.text.strip())
```

## 5. Tạo báo cáo PDF

Tự động tạo báo cáo với biểu đồ từ dữ liệu:

```python
import matplotlib.pyplot as plt

months = ["T1", "T2", "T3", "T4", "T5", "T6"]
revenue = [120, 135, 148, 162, 155, 170]

plt.figure(figsize=(8, 4))
plt.bar(months, revenue, color="#2196F3")
plt.title("Doanh thu 6 tháng đầu năm (triệu VNĐ)")
plt.savefig("bao-cao.pdf")
```

## Bắt đầu từ đâu?

1. **Cài Python**: Tải từ [python.org](https://www.python.org/) hoặc dùng `brew install python` trên macOS
2. **Học cơ bản**: Biến, vòng lặp, hàm — chỉ cần 1-2 tuần
3. **Chọn một vấn đề thực tế**: Bắt đầu với công việc lặp đi lặp lại mà bạn đang làm thủ công
4. **Cài thư viện cần thiết**: `pip install pandas openpyxl requests beautifulsoup4 matplotlib`

## Kết luận

Python không yêu cầu bạn phải là lập trình viên chuyên nghiệp. Chỉ cần vài dòng code, bạn có thể tiết kiệm hàng giờ làm việc mỗi tuần. Hãy bắt đầu với một task nhỏ và mở rộng dần — bạn sẽ ngạc nhiên với những gì Python có thể làm được.
