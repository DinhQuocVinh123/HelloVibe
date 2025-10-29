# 🧠 Vibe Workflow Log – HelloVibe Project

## Prompt #1 & 2: Tạo LWC đổi màu khi click

**Thời gian thực hiện:** 29/10/2025  
**Người thực hiện:** Vinh

### 🔹 Prompt đã dùng:

### 🔹 Kết quả sinh code:

- Tự động tạo folder `lwc/colorToggleButton`
- Sinh 3 file: `.html`, `.js`, `.js-meta.xml`
- Deploy thành công lên Org `binkkboi737@agentforce.com`

### 🔹 Thời gian:

- Generate: ~10 giây
- Deploy: ~15 giây
- Test: hoạt động đúng trên Lightning App Page “TestColorToggle”

### 🔹 Đánh giá code:

| Tiêu chí     | Đánh giá            | Ghi chú                                 |
| ------------ | ------------------- | --------------------------------------- |
| Cấu trúc LWC | ✅ Tốt              | Đúng chuẩn base template                |
| Logic JS     | ✅ Tốt              | Đổi màu đúng theo random()              |
| UI/UX        | ⚠️ Có thể cải thiện | Nên thêm CSS class thay vì inline style |
| Tên biến     | ✅ Chuẩn            | Tên dễ hiểu, PascalCase chuẩn LWC       |

### 🔹 Kết luận:

> ✅ Prompt chạy ổn định, code sạch, deploy thành công.  
> Lưu lại prompt này làm **mẫu chuẩn** để huấn luyện team viết prompt LWC cơ bản.

### Prompt 3 Review Summary

# 🧾 Review Generated Code – Day 3: Todo App (CRUD + Unit Test)

**📅 Ngày:** 30/10/2025  
**👤 Reviewer:** Vinh  
**🧠 Project:** HelloVibe  
**📦 Components:** `TodoController.cls`, `TodoListCmp`, `TodoControllerTest.cls`

---

## 🔹 1. Tổng quan

Agentforce Vibe đã generate đầy đủ logic CRUD cho object `Todo__c`, bao gồm:

- **Apex Controller:** xử lý Create, Read, Update, Delete
- **LWC Component:** hiển thị danh sách và thao tác người dùng
- **Test Class:** kiểm thử cơ bản cho controller

Kết quả deploy thành công và hoạt động ổn trên Org ✅  
Tuy nhiên, vẫn có vài điểm có thể cải thiện để tăng hiệu quả và UX.

---

## 🔹 2. Đánh giá chi tiết

### 🧩 A. Cấu trúc & logic tổng thể

| Tiêu chí                                 | Nhận xét                                    | Đánh giá |
| ---------------------------------------- | ------------------------------------------- | -------- |
| 📁 Phân tách file hợp lý (Apex/LWC/Test) | Cấu trúc chuẩn Salesforce.                  | ✅ Tốt   |
| 🧠 Tên class & component                 | Đặt tên đúng chuẩn PascalCase, dễ hiểu.     | ✅ Tốt   |
| ⚙️ Hàm CRUD trong Apex                   | Đầy đủ 4 hàm CRUD, có @AuraEnabled.         | ✅ Tốt   |
| 🔄 ToggleComplete logic                  | Hoạt động ổn, nhưng có thể giảm 1 truy vấn. | ✅ Tốt   |

---

### 💻 B. Giao diện (LWC)

| Tiêu chí           | Nhận xét                                             | Đánh giá |
| ------------------ | ---------------------------------------------------- | -------- |
| 🧱 HTML Template   | Rõ ràng, dễ hiểu, có label đầy đủ.                   | ✅ Tốt   |
| 🧠 Logic JS        | Có đầy đủ hàm handleAdd, handleDelete, handleToggle. | ✅ Tốt   |
| 🔄 Refresh dữ liệu | Có                                                   | ✅ Tốt   |
| 🔔 UX Feedback     | Chưa có thông báo khi thêm/xóa thành công.           | ✅ Tốt   |

---

### 🧪 C. Test Class

| Tiêu chí            | Nhận xét                                    | Đánh giá |
| ------------------- | ------------------------------------------- | -------- |
| 🧩 Test CRUD cơ bản | Đã test đầy đủ create, get, toggle, delete. | ✅ Tốt   |
| 📈 Coverage         | ~90% coverage.                              | ✅ Tốt   |

## 🔹 3. Tóm tắt điểm mạnh & điểm yếu

| ✅ Điểm mạnh                                  | ⚠️ Điểm cần cải thiện                        |
| --------------------------------------------- | -------------------------------------------- |
| Cấu trúc dự án rõ ràng, tách biệt Apex & LWC. | Giao diện còn đơn giản, thiếu Toast & CSS.   |
| Test class đạt coverage cao.                  | Chưa có negative test case.                  |
| Prompt sinh code nhanh, logic chính xác.      | Cần hướng dẫn prompt chi tiết hơn cho UI/UX. |

---

## 🔹 4. Gợi ý cải thiện prompt

> Dựa trên kết quả hôm nay, prompt ngày 3 có thể cải tiến để sinh ra code tốt hơn.
