# 🥤 **Healthy Beverage Sales Data Analysis with SQL**

## 📌 **Introduction**
This project focuses on **analyzing sales and customer data** of a healthy beverage company.  
The main objectives are:  
- Understand customer purchasing behavior.  
- Analyze revenue over time.  
- Analyze revenue by product categories and items.  
- Calculate sales probability of each category and product.  
- Identify potential customer groups.  
- Provide insights to support business decision-making.  

---

## 📂 **Data**
The project uses 2 main datasets:  
- `DataNotCleaned.xlsx`: raw data, not cleaned.  
- `DataCleanedCustomer,Sales(OrderTea).csv`: cleaned data ready for analysis.  

Selected columns for analysis:  
- **sales**: transaction details (OrderDate, OrderTime, Order ID, Quantity, TotalPrice).  
- **customers**: customer details (Customer ID, Name, Occupation, Age, Age Brackets).  
- **products**: product details (Category ID, Category, Product ID, Product).  

---

## 📂 Example Data Table  
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

---

## ⚙️ **Sample SQL Queries**


---

📊 **Customer Preference Queries**

```sql
-- PHÂN KHÚC KHÁCH HÀNG CÓ DOANH SỐ NHIỀU NHẤT THEO NHÓM TUỔI
SELECT Age_Brackets,
       SUM(TotalPrice) AS Total_Revenue
FROM OrderTea
GROUP BY Age_Brackets
ORDER BY SUM(TotalPrice) DESC;
```
**Results**   


📊 **Customer Segment with the Highest Sales by Age Group**

| Age Brackets | Total Revenue |
|--------------|---------------|
| Middle Age   | 2,030,573,000 |
| Adolescent   | 1,690,122,000 |
| Old          | 1,058,379,000 |


```sql
-- TOP 5 MẶT HÀNG ĐƯỢC MUA NHIỀU NHẤT BỞI NHÓM NGÀNH NGHỀ 'Student, New employee and Freelencer' VÀ Ở NHÓM TUỔI 'Young'
SELECT TOP 5 Occupation,
           Product,
           SUM(Quantity) AS Total_Quantity
FROM OrderTea
WHERE Occupation = 'Student, New employee and Freelencer'
  AND Age_Brackets = 'Young'
GROUP BY Occupation,
         Product
ORDER BY Total_Quantity DESC;
```
**Results**  


📊 **Top Products Purchased Most by the "Student, New Employee, and Freelancer" Group in the 'Young' Age Segment**


| Occupation                        | Product          | Total Quantity |
|-----------------------------------|------------------|----------------|
| Student, New employee and Freelancer | Bột cần tây      | 1866           |
| Student, New employee and Freelancer | Cam lát          | 1170           |
| Student, New employee and Freelancer | Trà gạo lứt 8 vị | 1025           |
| Student, New employee and Freelancer | Trà cam sả quế   | 760            |
| Student, New employee and Freelancer | Trà gừng         | 706            |

📊**Query on Sales by Product Category and Item**

```sql
-- DOANH SỐ BÁN HÀNG THEO MẶT HÀNG
SELECT Product_ID,
       Product,
       CONCAT(SUM(TotalPrice), ' ', N'Triệu Vnđ') AS Total_Price,
       CONCAT(SUM(Quantity), ' ', N'SKUs') AS Total_Quantity
FROM OrderTea
WHERE YEAR(OrderDate) = 2022
GROUP BY Product_ID,
         Product
ORDER BY SUM(TotalPrice) DESC;
```
**Result**  


📊 **Top Products by Revenue and Sales Volume (SKUs)**

| Product ID | Product                           | Revenue (VND)       | Quantity (SKUs) |
|------------|-----------------------------------|---------------------|-----------------|
| BOT01      | Bột cần tây                       | 626,000,000         | 15,650          |
| THO06      | Trà nhuỵ hoa nghệ tây             | 592,380,000         | 3,291           |
| TTC01      | Trà gừng                          | 432,900,000         | 14,430          |
| THO03      | Trà hoa cúc trắng                 | 421,440,000         | 5,268           |
| TTC02      | Cam lát                           | 367,380,000         | 8,164           |
| TMX01      | Trà dưỡng nhan                    | 317,170,000         | 9,062           |
| THO01      | Trà nụ hoa nhài trắng             | 290,030,000         | 4,462           |
| THO02      | Trà hoa đậu biếc                  | 279,140,000         | 4,105           |
| TMX02      | Trà cam sả quế                    | 249,888,000         | 6,576           |
| SET03      | Set 10 gói trà hoa cúc trắng      | 243,900,000         | 1,626           |
| SET02      | Set 10 gói trà hoa đậu biếc       | 158,712,000         | 1,167           |
| THO04      | Trà nụ hoa hồng Tây Tạng          | 150,315,000         | 2,733           |
| THO05      | Trà hoa Atiso                     | 144,200,000         | 2,884           |
| TMX03      | Trà gạo lứt 8 vị                  | 130,284,000         | 7,238           |
| SET01      | Set 10 gói trà nụ hoa nhài trắng  | 114,600,000         | 955             |
| SET05      | Set 10 gói trà dưỡng nhan         | 98,475,000          | 1,515           |
| SET04      | Set 10 gói trà gừng               | 80,000,000          | 1,600           |
| SET07      | Set 10 gói trà cam sả quế         | 50,410,000          | 710             |
| SET06      | Set 10 gói trà gạo lứt 8 vị       | 31,850,000          | 910             |

```sql
-- DOANH SỐ BÁN HÀNG TRUNG BÌNH THEO GIỜ
WITH Doanh_Số_Bán_Theo_Giờ AS
  (SELECT CAST(OrderDate AS DATE) AS Ngày,
          DATEPART(HOUR, OrderTime) AS ThờiGian,
          SUM(TotalPrice) AS Total_Price,
          SUM(Quantity) AS Total_Quantity
   FROM OrderTea
   GROUP BY CAST(OrderDate AS DATE),
            DATEPART(HOUR, OrderTime))
SELECT CASE ThờiGian
           WHEN 8  THEN '08:00-08:59'
           WHEN 9  THEN '09:00-09:59'
           WHEN 10 THEN '10:00-10:59'
           WHEN 11 THEN '11:00-11:59'
           WHEN 12 THEN '12:00-12:59'
           WHEN 13 THEN '13:00-13:59'
           WHEN 14 THEN '14:00-14:59'
           WHEN 15 THEN '15:00-15:59'
           WHEN 16 THEN '16:00-16:59'
           WHEN 17 THEN '17:00-17:59'
           WHEN 18 THEN '18:00-18:59'
           WHEN 19 THEN '19:00-19:59'
           WHEN 20 THEN '20:00-20:59'
           WHEN 21 THEN '21:00-21:59'
           WHEN 22 THEN '22:00-22:59'
           WHEN 23 THEN '23:00-23:59'
       END AS Hour_Range,
       CONCAT(AVG(Total_Price), N' Triệu VNĐ') AS AVG_Price,
       CONCAT(AVG(Total_Quantity), N' SKUs') AS AVG_Quantity
FROM Doanh_Số_Bán_Theo_Giờ
GROUP BY ThờiGian
ORDER BY Hour_Range ASC;
```
**Result**  


📊 **Average Sales by Hour**

| hour_range |  AVG_Price | SKUs |
|-------------|------------------------|------|
| 08:00-08:59 | 772113                | 15   |
| 09:00-09:59 | 746271                | 14   |
| 10:00-10:59 | 780685                | 15   |
| 11:00-11:59 | 795058                | 15   |
| 12:00-12:59 | 877765                | 16   |
| 13:00-13:59 | 779430                | 14   |
| 14:00-14:59 | 753569                | 14   |
| 15:00-15:59 | 764575                | 14   |
| 16:00-16:59 | 814176                | 15   |
| 17:00-17:59 | 824085                | 15   |
| 18:00-18:59 | 895953                | 17   |
| 19:00-19:59 | 890041                | 17   |
| 20:00-20:59 | 882650                | 16   |
| 21:00-21:59 | 892939                | 17   |
| 22:00-22:59 | 858159                | 16   |
| 23:00-23:59 | 856225                | 16   |




## 📈 Expected Results
- Revenue by beverage type.  
- Customer segmentation by age and occupation.  
- Revenue growth trends over time.  
- Best-selling products and potential customer groups.  

## 🚀 Technologies Used
- **SQL** (MySQL / PostgreSQL / SQLite)  
- **Excel** (data preprocessing)  

## ✅ Conclusion
The analysis of healthy beverage sales data helps to:  
- Identify which products are most popular.  
- Determine target customer groups.  
- Make more accurate and effective business decisions.  


