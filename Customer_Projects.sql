-- SỬ DỤNG DATABASE
USE Project_Sql1;

-- SỬ DỤNG TABLE
SELECT * FROM OrderTea;

-- PHÂN KHÚC KHÁCH HÀNG CÓ DOANH SỐ NHIỀU NHẤT THEO NGÀNH NGHỀ
SELECT Occupation,
       SUM(TotalPrice) AS Total_Revenue
FROM OrderTea
GROUP BY Occupation
ORDER BY SUM(TotalPrice) DESC;


-- PHÂN KHÚC KHÁCH HÀNG CÓ DOANH SỐ NHIỀU NHẤT THEO ĐỘ TUỔI
SELECT Age,
       SUM(TotalPrice) AS Total_Revenue
FROM OrderTea
GROUP BY Age
ORDER BY SUM(TotalPrice) DESC;


-- PHÂN KHÚC KHÁCH HÀNG CÓ DOANH SỐ NHIỀU NHẤT THEO NHÓM TUỔI
SELECT Age_Brackets,
       SUM(TotalPrice) AS Total_Revenue
FROM OrderTea
GROUP BY Age_Brackets
ORDER BY SUM(TotalPrice) DESC;


-- NHỮNG KHÁCH HÀNG CÓ DOANH SỐ VÀ SỐ LƯỢNG MUA HÀNG CAO NHẤT
SELECT name,
       SUM(Quantity) AS Total_Quantity,
       SUM(TotalPrice) AS Total_Price
FROM OrderTea
GROUP BY Name
ORDER BY Total_Price DESC;


-- NHỮNG KHÁCH HÀNG CÓ LƯỢT MUA LÀ 50 ĐƠN HÀNG ĐẦU TIÊN
WITH Order_Tea AS (
SELECT Name,OrderDate,COUNT(DISTINCT(Order_ID)) AS Order_ID FROM OrderTea -- Đếm từng đơn hàng
GROUP BY Name,OrderDate
)
SELECT name, MIN(Orderdate) AS Target_reached,MAX(Total_Order) AS Total_Order FROM
(SELECT *,SUM(Order_ID) OVER(PARTITION BY Name ORDER BY OrderDate) AS Total_Order FROM Order_Tea) AS subquery -- Sử dụng truy vấn lồng để cộng dồn đơn hàng theo từng khách hàng
WHERE Total_Order >= 50 AND Name != 'Null' AND Name != N'Thành viên mới'
GROUP BY name;

-- NHỮNG KHÁCH HÀNG ĐẦU TIÊN ĐẠT NGƯỠNG CHI TIÊU 1 TRIỆU VNĐ CHO CỬA HÀNG
SELECT Name,MIN(OrderDate) AS OrderDate,MAX(Total_Price1) AS Total_Price FROM
(SELECT *,SUM(TotalPrice) OVER(PARTITION BY name ORDER BY OrderDate) AS Total_Price1 FROM OrderTea) AS subquery
WHERE Total_Price1 >= 5000000
GROUP BY Name
ORDER BY Total_Price DESC;


-- TOP 5 MẶT HÀNG ĐƯỢC MUA NHIỀU NHẤT BỞI NHÓM NGÀNH NGHỀ 'OFFICE WORKER AND BUSINESS OWNER' VÀ Ở NHÓM TUỔI 'Middle Age' 
SELECT TOP 5 Occupation,
           Product,
           SUM(Quantity) AS Total_Quantity
FROM OrderTea
WHERE Occupation = 'Office worker and Business owner'
  AND Age_Brackets = 'Middle Age'
GROUP BY Occupation,
         Product
ORDER BY Total_Quantity DESC;


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

-- PHÂN PHỐI LƯỢT MUA HÀNG CỦA KHÁCH HÀNG
WITH Distinct_Order AS
  (SELECT Customer_ID,
          Name,
          COUNT(DISTINCT(Order_ID)) AS Total_Order
   FROM OrderTea
   GROUP BY Customer_ID,
            Name)
SELECT Total_Order AS Repeat_Purchase_Count,
       COUNT(*) AS Total_Customers
FROM Distinct_Order
GROUP BY Total_Order;


-- TỶ LỆ KHÁCH HÀNG MUA 1 LẦN, MUA 2 LẦN, .... 
WITH Distinct_Order AS
  (SELECT Customer_ID,
          Name,
          COUNT(DISTINCT(Order_ID)) AS Total_Order
   FROM OrderTea
   GROUP BY Customer_ID,
            Name)
SELECT Total_Order AS Repeat_Purchase_Count,
       CONCAT(CAST(COUNT(*) AS FLOAT) / CAST((SELECT COUNT(DISTINCT(Customer_ID)) FROM OrderTea) AS FLOAT) * 100, '%') AS Repeat_Purchase_Rate
FROM Distinct_Order
GROUP BY Total_Order;


-- PHÂN PHỐI MỨC CHI TRẢ CỦA KHÁCH HÀNG
WITH Distinct_TotalPrice AS
  (SELECT Customer_ID,
          SUM(TotalPrice) AS Total_Price
   FROM OrderTea
   GROUP BY Customer_ID)
SELECT CASE
           WHEN Total_Price BETWEEN 0 AND 3950000 THEN N'Đã chi tiêu từ ' + CAST((Total_Price/50000)*50000 AS NVARCHAR) + N' đến ' + CAST(((Total_Price/50000)*50000 + 50000) AS NVARCHAR)
           ELSE N'Trên 3,95 triệu'
       END AS SpendingRange,
       COUNT(*) AS TotalCustomers
FROM Distinct_TotalPrice
GROUP BY CASE
             WHEN Total_Price BETWEEN 0 AND 3950000 THEN N'Đã chi tiêu từ ' + CAST((Total_Price/50000)*50000 AS NVARCHAR) + N' đến ' + CAST(((Total_Price/50000)*50000 + 50000) AS NVARCHAR)
             ELSE N'Trên 3,95 triệu' -- Spendingrange
         END
ORDER BY MIN((Total_Price/50000)*50000) -- Sắp xếp theo thứ tự



