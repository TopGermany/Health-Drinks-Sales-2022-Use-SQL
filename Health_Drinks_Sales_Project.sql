-- THỐNG KÊ DOANH THU VÀ SỐ LƯỢNG CỦA CÁC MẶT HÀNG CỦA CỬA HÀNG BÁN CÁC LOẠI NƯỚC TRONG NĂM 2022

-- TẠO DATABASE
CREATE DATABASE Project_Sql1

-- SỬ DỤNG DATABASE
USE Project_Sql1


-- XEM BẢNG DỮ LIỆU
SELECT * FROM dbo.OrderTea

-- DOANH SỐ BÁN HÀNG THEO NHÓM HÀNG
SELECT Category_ID,
       Category,
       CONCAT(SUM(TotalPrice), ' ', N'Triệu Vnđ') AS Total_Price,
       CONCAT(SUM(Quantity), ' ', N'SKUs') AS Total_Quantity
FROM OrderTea
WHERE YEAR(OrderDate) = 2022
GROUP BY Category_ID,
         Category
ORDER BY SUM(TotalPrice) DESC


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


-- DOANH SỐ BÁN HÀNG THEO THÁNG 
SELECT CONCAT(N'Tháng', ' ', MONTH(ORDERDATE)) AS Month_In_Year,
       CONCAT(SUM(TotalPrice), ' ', N'Triệu Vnđ') AS Total_Price,
       CONCAT(SUM(Quantity), ' ', N'SKUs') AS Total_Quantity
FROM OrderTea
WHERE YEAR(OrderDate) = 2022
GROUP BY MONTH(OrderDate)
ORDER BY MONTH(OrderDate);


-- DOANH SỐ BÁN HÀNG THEO NGÀY TRONG TUẦN 
SELECT CASE
           WHEN DATEPART(WEEKDAY, OrderDate) = 2 THEN N'Thứ 2'
           WHEN DATEPART(WEEKDAY, OrderDate) = 3 THEN N'Thứ 3'
           WHEN DATEPART(WEEKDAY, OrderDate) = 4 THEN N'Thứ 4'
           WHEN DATEPART(WEEKDAY, OrderDate) = 5 THEN N'Thứ 5'
           WHEN DATEPART(WEEKDAY, OrderDate) = 6 THEN N'Thứ 6'
           WHEN DATEPART(WEEKDAY, OrderDate) = 7 THEN N'Thứ 7'
           WHEN DATEPART(WEEKDAY, OrderDate) = 1 THEN N'Chủ nhật'
       END AS Week_Day,
       CONCAT(SUM(TotalPrice), ' ', N'Triệu Vnđ') AS Total_Price
FROM OrderTea
GROUP BY DATEPART(WEEKDAY, OrderDate)
ORDER BY CASE
             WHEN DATEPART(WEEKDAY, OrderDate) = 1 THEN 7
             ELSE DATEPART(WEEKDAY, OrderDate)
         END;


-- DOANH SỐ BÁN HÀNG TRUNG BÌNH THEO THÁNG
WITH Count_Distint_OrderDate AS
  (SELECT DATEPART(MONTH, OrderDate) AS Month_Order,
          COUNT(DISTINCT(OrderDate)) AS Count_OrderDate
   FROM OrderTea
   WHERE Order_ID IS NOT NULL
   GROUP BY DATEPART(MONTH, OrderDate)),
     Total_Price AS
  (SELECT DATEPART(MONTH, OrderDate) AS Month_Order,
          SUM(TotalPrice) Sum_TotalPrice
   FROM OrderTea
   WHERE Order_ID IS NOT NULL
   GROUP BY DATEPART(MONTH, OrderDate))
SELECT CONCAT('Tháng ', CDOD.Month_Order) AS Month_Order,
       TP.Sum_TotalPrice/Count_OrderDate AS AVG_Revenue
FROM Count_Distint_OrderDate AS CDOD
INNER JOIN Total_Price AS TP ON CDOD.Month_Order = TP.Month_Order
ORDER BY CDOD.Month_Order ASC;


-- DOANH SỐ BÁN HÀNG TB THEO NGÀY TRONG TUẦN
WITH Doanh_Số_bán AS
  (SELECT CAST(Orderdate AS date) AS Ngày_Cụ_Thể, 
DATEPART(WEEKDAY, OrderDate) Week_Day, 
SUM(TotalPrice) AS Total_Price, 
SUM(Quantity) AS Total_Quantity 
FROM OrderTea
   GROUP BY CAST(Orderdate AS date),
            DATEPART(WEEKDAY, OrderDate))
SELECT CASE Week_Day
           WHEN 1 THEN N'Chủ Nhât'
           WHEN 2 THEN N'Thứ 2'
           WHEN 3 THEN N'Thứ 3'
           WHEN 4 THEN N'Thứ 4'
           WHEN 5 THEN N'Thứ 5'
           WHEN 6 THEN N'Thứ 6'
           WHEN 7 THEN N'Thứ 7'
       END AS Weekday,
       COUNT(*) AS Total_WeekDay,
       CONCAT(AVG(Total_Price), N' Triệu VNĐ') AS AVG_Price, 
CONCAT(AVG(Total_Quantity), N' SKUs') AS AVG_Quantity
FROM Doanh_Số_bán
GROUP BY Week_Day
ORDER BY CASE
             WHEN DATEPART(WEEKDAY, Week_Day) = 1 THEN 7
             ELSE DATEPART(WEEKDAY, Week_Day)
         END; 


-- DOANH SỐ BÁN TRUNG BÌNH THEO NGÀY TRONG THÁNG
WITH Doanh_Số_bán AS
  (SELECT CAST(OrderDate AS DATE) AS Ngày,
          DATEPART(DAY, OrderDate) AS Ngày_Trong_Tháng,
SUM(TotalPrice) AS Total_Price,
SUM(Quantity) AS Total_Quantity
   FROM OrderTea
   GROUP BY CAST(OrderDate AS DATE),
            DATEPART(DAY, OrderDate))
SELECT CONCAT(N'Ngày ', Ngày_Trong_Tháng) AS DAY,
       COUNT(*) AS Total_Day,
       CONCAT(AVG(Total_Price), N' Triệu VNĐ') AS AVG_Price,
CONCAT(AVG(Total_Quantity), N' SKUs') AS AVG_Quantity
FROM Doanh_Số_bán
GROUP BY Ngày_Trong_Tháng
ORDER BY Ngày_Trong_Tháng ASC;


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


-- XÁC SUẤT BÁN HÀNG THEO NHÓM HÀNG (CÔNG THỨC: TỔNG ĐƠN HÀNG THEO TỪNG NHÓM ORDER / TỔNG ĐƠN HÀNG CỦA ORDER)
-- Nhóm các đơn hàng, category_ID,Category
WITH DistinctOrder AS
  (SELECT Order_ID,
          Category_ID,
          Category
   FROM OrderTea
   GROUP BY Order_ID,
            Category_ID,
            Category), 
CategoryCount AS
  (SELECT Category_ID,
          Category,
          COUNT(DISTINCT(Order_ID)) AS Distinct_Order
   FROM DistinctOrder
   GROUP BY Category_ID,
            Category),
TotalOrder AS
  (SELECT COUNT(DISTINCT(Order_ID)) AS Total_Order
   FROM OrderTea)
SELECT CT.Category_ID,
       CT.Category,
       CT.Distinct_Order AS Quantity_Order,
       CONCAT(CAST(CT.Distinct_Order * 1.0/TOR.Total_Order AS DECIMAL(5, 2)) * 100, '%') AS Probability 
FROM CategoryCount AS CT
CROSS JOIN TotalOrder AS TOR
ORDER BY Probability DESC;


-- XÁC SUẤT BÁN HÀNG CỦA NHÓM HÀNG THEO TỪNG THÁNG (SỐ ĐƠN HÀNG CỦA NHÓM ORDER THEO THÁNG/ TỔNG ĐƠN HÀNG CỦA ORDER THEO THÁNG) 
--Chọn Đơn hàng, Nhóm hàng, Tháng
WITH DistinctOrder AS
  (SELECT Order_ID,
          DATEPART(MONTH, OrderDate) AS MONTH,
          Category_ID,
          Category
   FROM OrderTea
   GROUP BY Order_ID,
            DATEPART(MONTH, OrderDate),
            Category_ID,
            Category),
     CountOrderMonth AS
  (SELECT MONTH,
          Category_ID,
          Category,
          COUNT(DISTINCT(Order_ID)) AS Distinct_Order 
FROM DistinctOrder
   GROUP BY MONTH,
            Category_ID,
            Category),
     TotalOrderMonth AS
  (SELECT DATEPART(MONTH, OrderDate) AS MONTH,
          COUNT(DISTINCT(Order_ID)) AS Total_Order
   FROM OrderTea 
GROUP BY DATEPART(MONTH, OrderDate))
SELECT COM.Month,
       COM.Category_ID,
       COM.Category,
       COM.Distinct_Order AS Quantity_Order,
       CONCAT(CAST(COM.Distinct_Order*100.0/TOM.Total_Order AS DECIMAL(10, 0)), '%') AS Probability
FROM CountOrderMonth AS COM
INNER JOIN TotalOrderMonth AS TOM ON COM.Month = TOM.Month
ORDER BY MONTH,
         Probability ASC;


-- XÁC SUẤT BÁN HÀNG CỦA MẶT HÀNG THEO TỪNG NHÓM HÀNG (SỐ LƯỢNG ĐƠN HÀNG BÁN CỦA MẶT HÀNG THEO NHÓM/TỔNG SỐ LƯỢNG ĐƠN HÀNG CỦA NHÓM HÀNG)
WITH DistinctOrder AS
  (SELECT Order_ID,
          Category_ID,
          Category,
          Product_ID,
          Product
   FROM OrderTea
   GROUP BY Order_ID,
            Category_ID,
            Category,
            Product_ID,
            Product),
     CountOrderProductCategory AS
  (SELECT Category_ID,
          Category,
          Product_ID,
          Product,
          COUNT(DISTINCT Order_ID) AS Distinct_Order
   FROM DistinctOrder
   GROUP BY Category_ID,
            Category,
            Product_ID,
            Product),
     TotalOrderCategory AS
  (SELECT Category_ID,
          Category,
          COUNT(DISTINCT Order_ID) AS Total_Order
   FROM OrderTea
   GROUP BY Category_ID,
            Category)
SELECT TOC.Category_ID,
       TOC.Category,
       COPC.Product_ID,
       COPC.Product,
       COPC.Distinct_Order AS Order_Quantity,
       CONCAT(CAST(COPC.Distinct_Order * 100.0/Total_Order AS DECIMAL(10, 2)), '%') AS Probability
FROM TotalOrderCategory AS TOC
INNER JOIN CountOrderProductCategory COPC ON TOC.Category_ID = COPC.Category_ID
ORDER BY TOC.Category_ID ASC;


-- XÁC SUẤT BÁN HÀNG  CỦA MẶT HÀNG THEO NHÓM HÀNG TRONG TỪNG THÁNG (TỔNG SỐ ĐƠN CỦA MẶT HÀNG THEO NHÓM HÀNG TRONG TỪNG THÁNG/ TỔNG SỐ ĐƠN  NHÓM HÀNG TRONG TỪNG THÁNG)
WITH DistinctOrder AS
  (SELECT Order_ID,
          DATEPART(MONTH, OrderDate) AS MONTH,
          Category_ID,
          Category,
          Product_ID,
          Product
   FROM OrderTea
   GROUP BY Order_ID,
            DATEPART(MONTH, OrderDate),
            Category_ID,
            Category,
            Product_ID,
            Product),
     CountOrderMonth AS
  (SELECT MONTH,
          Category_ID,
          Category,
          Product_ID,
          Product,
          COUNT(DISTINCT Order_ID) AS Distinct_Order
   FROM DistinctOrder
   GROUP BY MONTH,
            Category_ID,
            Category,
            Product_ID,
            Product),
     CountTotalOrder AS
  (SELECT DATEPART(MONTH, OrderDate) AS MONTH,
          Category_ID,
          Category,
          COUNT(DISTINCT Order_ID) AS Total_Order
   FROM OrderTea
   GROUP BY DATEPART(MONTH, OrderDate),
            Category_ID,
            Category)
SELECT COD.MONTH,
       COD.Category_ID,
       COD.Category,
       COM.Product_ID,
       COM.Product,
       COM.Distinct_Order AS Order_Quantity,
       CONCAT(CAST(COM.Distinct_Order * 100.0/COD.Total_Order AS DECIMAL(10, 2)), '%') AS Probability
FROM CountTotalOrder COD
INNER JOIN CountOrderMonth AS COM ON COD.Category_ID = COM.Category_ID
AND COD.Month = COM.Month
ORDER BY COD.MONTH,
         Category_ID ASC;













