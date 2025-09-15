🥤 **Phân Tích Dữ Liệu Đồ Uống Sức Khỏe Bằng SQL**

## 📌 **Giới thiệu**
Dự án này tập trung vào việc **phân tích dữ liệu bán hàng và khách hàng** của một công ty đồ uống sức khỏe.  
Mục tiêu chính:
- Hiểu rõ hành vi mua hàng của khách hàng.  
- Phân tích doanh thu theo thời gian.
- Phân tích doanh thu theo từng nhóm hàng, mặt hàng.
- Xác xuất bán của từng nhóm hàng, mặt hàng.  
- Xác định nhóm khách hàng tiềm năng.  
- Đưa ra insight để hỗ trợ quyết định kinh doanh.  

---

## 📂 **Dữ liệu**
Dự án sử dụng 2 tệp dữ liệu chính:  
- `DataNotCleaned.xlsx`: dữ liệu gốc, chưa được làm sạch.  
- `DataCleaned.xlsx`: dữ liệu sau khi làm sạch.  

Các cột dữ liệu cần chọn để phân tích:  
- **sales**: thông tin giao dịch (OrderDate, OrderTime, Order ID, Quantity,TotalPrice).  
- **customers**: thông tin khách hàng (Customer ID, Name, Occupation, Age, Age Brackets).  
- **products**: thông tin sản phẩm (Category ID, Category, Product ID, Product).
## 📂 Ví dụ bảng dữ liệu 

| Order ID   | Customer ID | Name          | CustomerSegmentCode | Occupation                 | Age   | Age Brackets | Category ID | Category                | Product ID | Product                     | CostPrice | Quantity | Price | TotalPrice | OrderDate   | OrderTime |
|------------|-------------|---------------|---------------------|----------------------------|-------|--------------|-------------|--------------------------|------------|------------------------------|-----------|----------|-------|------------|-------------|-----------|
| ORD000001  | CUZ00001    | Lê Vũ Tâm     | A1                  | Office worker and Business owner | 36-45 | Middle Age   | BOT         | Bột                      | BOT01      | Bột cần tây                  | 21800     | 2        | 1     | 40000      | 2022-01-01  | 08:01:09  |
| ORD000001  | CUZ00001    | Lê Vũ Tâm     | A1                  | Office worker and Business owner | 36-45 | Middle Age   | SET         | Set trà                  | SET03      | Set 10 gói trà hoa cúc trắng | 87600     | 1        | 1     | 150000     | 2022-01-01  | 08:01:09  |
| ORD000001  | CUZ00001    | Lê Vũ Tâm     | A1                  | Office worker and Business owner | 36-45 | Middle Age   | THO         | Trà hoa                  | THO05      | Trà hoa Atiso                | 19800     | 2        | 1     | 50000      | 2022-01-01  | 08:01:09  |
| ORD000002  | CUZ00002    | Phạm Công Bình| A2                  | Office worker and Freelancer in north | 25-35 | Adolescent | BOT         | Bột                      | BOT01      | Bột cần tây                  | 21800     | 2        | 1     | 40000      | 2022-01-01  | 08:18:12  |
| ORD000002  | CUZ00002    | Phạm Công Bình| A2                  | Office worker and Freelancer in north | 25-35 | Adolescent | SET         | Set trà                  | SET03      | Set 10 gói trà hoa cúc trắng | 87600     | 2        | 1     | 150000     | 2022-01-01  | 08:18:12  |
| ORD000003  | CUZ00003    | Phạm Văn Linh | C3                  | No Occupation              | 45+   | Old          | TMX         | Tea mix                  | TMX01      | Trà dưỡng nhan              | 17450     | 2        | 1     | 35000      | 2022-01-01  | 08:25:07  |
| ORD000003  | CUZ00003    | Phạm Văn Linh | C3                  | No Occupation              | 45+   | Old          | TTC         | Trà củ, quả sấy          | TTC01      | Trà gừng                    | 11800     | 3        | 1     | 30000      | 2022-01-01  | 08:25:07  |
| ORD000003  | CUZ00003    | Phạm Văn Linh | C3                  | No Occupation              | 45+   | Old          | TTC         | Trà củ, quả sấy          | TTC02      | Cam lát                     | 25800     | 1        | 1     | 45000      | 2022-01-01  | 08:25:07  |



