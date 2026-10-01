-----VALIDATION-----


--Actual Procurement Spend

SELECT FORMAT(SUM(Actual_Unit_Price_INR * Received)/1000000.0,'N2')+'M' FROM Silver.Silver_Procurement       --945945566

-------------------------------------------------------------------------------------------

--Total Logistic Cost

SELECT FORMAT(SUM(Freight_Cost_INR),'#,#') AS TotalFreightCost
FROM Silver.Silver_Logistic_Shipments                                    --24,130,359

----------------------------------------------------------------------------

--Supplier & Category which actual price is more than the contracted one

SELECT su.Supplier_Name,pr.Category,SUM(fa.Contract_Unit_Price_INR - fa.Actual_Unit_Price_INR)  AS Diff
FROM Silver.Silver_Procurement fa
JOIN Silver.[Silver_Product_Master csv] pr
ON fa.Product_ID = pr.Product_ID
JOIN Silver.Silver_Supplier_Master su
ON fa.Supplier_ID = su.Supplier_ID
WHERE fa.Contract_Unit_Price_INR - fa.Actual_Unit_Price_INR < 0 
GROUP BY su.Supplier_Name,pr.Category
ORDER BY Diff ASC


----------------------------------------------

--OnTime delivery (Y/N) & Delayed delivery by supplier,transport mode , region & carrier


;WITH onTime AS (
SELECT 
fa.PO_Line_ID,
        fa.Supplier_ID,
        log.Transport_Mode,
        wa.Region,
        log.Carrier_ID,
        fa.Promised_Date,
        log.Actual_Delivery_Date
FROM Silver.Silver_Procurement fa
JOIN Silver.Silver_Logistic_Shipments log
ON  fa.PO_Line_ID = log.PO_Line_ID
JOIN Silver.Silver_Warehouse_Master wa
ON fa.Warehouse_ID = wa.Warehouse_ID
JOIN Silver.Silver_Supplier_Master sa
ON fa.Supplier_ID = sa.Supplier_ID
)   SELECT DATEDIFF(day, Actual_Delivery_Date, Promised_Date) AS DATEDIf,
    CASE WHEN DATEDIFF(day,Actual_Delivery_Date, Promised_Date) < 0 THEN 'Late'           --in Datediff 1st argument gets substracted by 2nd argument (day,4,7)
         WHEN DATEDIFF(day,Actual_Delivery_Date, Promised_Date) >= 0 THEN 'OnTime'        --result wil be 7-4 =3
    END AS Reached,Supplier_ID,Transport_Mode,Region,Carrier_ID
    FROM onTime
    WHERE Actual_Delivery_Date > Promised_Date


---------------------------------------------------------------------------------------------------------------------------------------

--Supplier Quality Score & rejected Quantities

SELECT COUNT(fa.PO_Line_ID) AS TotalOrders,fa.Supplier_ID,su.Quality_Score,SUM(fa.Rejected) AS Rej,SUM(fa.Ordered) AS TotalQTY
FROM Silver.Silver_Procurement fa
JOIN Silver.Silver_Supplier_Master su
ON fa.Supplier_ID = su.Supplier_ID
GROUP BY fa.Supplier_ID,su.Quality_Score
ORDER BY fa.Supplier_ID


--------------------------------------------------------------------------------------------

--Logistic Cost Pressure

SELECT fa.Supplier_ID,lo.Carrier_ID,CAST(lo.Freight_Cost_INR AS DECIMAl (10,2)) AS Cost ,lo.Shipment_Status
FROM Silver.Silver_Procurement fa
JOIN Silver.Silver_Logistic_Shipments lo
ON fa.PO_Line_ID = lo.PO_Line_ID
WHERE lo.Shipment_Status NOT LIKE '%Cancel%'

---------------------------------------------------------------------------------------------------

--Actual Spend vs Target In Month April

SELECT tr.Product_Category ,FORMAT(tr.Apr,'#.0') AS AprilTarget,CAST(SUM(fa.Actual_Unit_Price_INR) AS DECIMAL(10,2)) AS TotalActualPriceInApril
 ,DATENAME(MM,fa.Order_Date) as Month, MONTH(fa.Order_Date) AS Mon
FROM Silver.Silver_Procurement fa
JOIN Silver.[Silver_Product_Master csv] po
ON fa.Product_ID = po.Product_ID
JOIN Silver.Silver_Procurement_Targets tr
ON po.Category = tr.Product_Category
WHERE  MONTH(fa.Order_Date) = '4'
GROUP BY tr.Product_Category ,DATENAME(MM,fa.Order_Date) , MONTH(fa.Order_Date) , tr.Apr

---------------------------------------------------------------------------------------------------------

--Speend Varaince By Category


SELECT FORMAT(SUM(fa.Contract_Unit_Price_INR),'#.0') as ContarctedPrice, FORMAT(SUM(fa.Actual_Unit_Price_INR),'#.0') AS ActualPrice,
FORMAT(SUM((((fa.Actual_Unit_Price_INR - fa.Contract_Unit_Price_INR)/fa.Contract_Unit_Price_INR)*100.0)),'#0.0')+'%' AS PriceVariance,po.Category
FROM Silver.Silver_Procurement fa
JOIN Silver.[Silver_Product_Master csv] po
ON fa.Product_ID = po.Product_ID
GROUP BY po.Category
ORDER BY PriceVariance DESC


----------------------------------------------------------------------------------------------------------

--PO Status and Supplier Risk

SELECT COUNT(DISTINCT fa.PO_ID) AS TOTAL_PO , su.Supplier_Name, su.Risk_Level, su.Supplier_Rating  FROM
Silver.Silver_Procurement fa
JOIN Silver.Silver_Supplier_Master su
ON fa.Supplier_ID = su.Supplier_ID
WHERE su.Risk_Level IN ('High','Medium')
GROUP BY  su.Supplier_Name, su.Risk_Level, su.Supplier_Rating

-------------------------------------------------------------------------------------------------------------
--OTD % (on Time Delivery Percentage)


SELECT COUNT(*) AS TotalDeliveries,SUM
(CASE WHEN  DATEDIFF(day,fa.Promised_Date,lo.Actual_Delivery_Date) <= 0 THEN 1
ELSE 0
END) AS "OnTime/Delay",
FORMAT(SUM (CASE WHEN  DATEDIFF(day,fa.Promised_Date,lo.Actual_Delivery_Date) <= 0 THEN 1 ELSE 0 END)*1.0/COUNT(*),'#.0%') AS OTD
FROM Silver.Silver_Procurement fa
JOIN Silver.Silver_Logistic_Shipments lo
ON fa.PO_Line_ID = lo.PO_Line_ID
WHERE lo.Shipment_Status NOT LIKE '%C%' 
AND
lo.Shipment_Status  NOT LIKE'%In%'                                                      --OTD 63.7%

------------------------------------------------------------------------------------------------------------
 
--SLA GAP


WITH SLA AS (
SELECT COUNT(*) AS TotalDeliveries,ca.Carrier_ID,
ca.SLA_On_Time_Target AS CarrieTarget,
--SUM(CASE WHEN  DATEDIFF(day,fa.Promised_Date,lo.Actual_Delivery_Date) <= 0 THEN 1 ELSE 0 END) AS "OnTime/Delay",
SUM (CASE WHEN  DATEDIFF(day,fa.Promised_Date,lo.Actual_Delivery_Date) <= 0 THEN 1 ELSE 0 END)*1.0/COUNT(*) AS OTD
FROM Silver.Silver_Procurement fa
JOIN Silver.Silver_Logistic_Shipments lo
ON fa.PO_Line_ID = lo.PO_Line_ID
JOIN Silver.[Silver_Carrier-Master] ca
ON lo.Carrier_ID = ca.Carrier_ID
WHERE lo.Shipment_Status NOT LIKE '%C%' 
AND
lo.Shipment_Status  NOT LIKE'%In%'  
GROUP BY ca.Carrier_ID,ca.SLA_On_Time_Target)
SELECT Carrier_ID,FORMAT((OTD -CarrieTarget),'#0.0%') AS SLA_GAP
FROM SLA


SELECT 
    ca.Carrier_ID,
    FORMAT(ca.SLA_On_Time_Target, 'P1') AS CarrierTarget,
    FORMAT(
        SUM(CASE WHEN DATEDIFF(day, fa.Promised_Date, lo.Actual_Delivery_Date) <= 0 THEN 1.0 ELSE 0.0 END) / COUNT(*), 
        'P1'
    ) AS OTD,
    FORMAT(
        (SUM(CASE WHEN DATEDIFF(day, fa.Promised_Date, lo.Actual_Delivery_Date) <= 0 THEN 1.0 ELSE 0.0 END) / COUNT(*)) - ca.SLA_On_Time_Target, 
        'P1'
    ) AS SLA_GAP
FROM Silver.Silver_Procurement fa
JOIN Silver.Silver_Logistic_Shipments lo
    ON fa.PO_Line_ID = lo.PO_Line_ID
JOIN Silver.[Silver_Carrier-Master] ca
    ON lo.Carrier_ID = ca.Carrier_ID
WHERE lo.Shipment_Status NOT LIKE '%C%' 
  AND lo.Shipment_Status NOT LIKE '%In%'
GROUP BY ca.Carrier_ID, ca.SLA_On_Time_Target;


----------------------------------------------------------------------------------------------

--DateTable Creation

SELECT * FROM gold.Fact_Procu_Targets

DECLARE @StartDate DATE = SELECT MIN([Date]) FROM gold.Fact_Procu_Targets
DECLARE @EndDate DATE = SELECT MAX(Actual_Delivery_Date) FROM gold.Fact_Procurement



WITH DateSequence AS (
    SELECT CAST(@StartDate AS DATE) AS DateValue
    UNION ALL
    SELECT DATEADD(day, 1, DateValue)
    FROM DateSequence
    WHERE DateValue < @EndDate
)
SELECT 
    CAST(FORMAT(DateValue, 'yyyyMMdd') AS INT) AS Date_Key,
    DateValue AS Date,
    YEAR(DateValue) AS Year,
    MONTH(DateValue) AS Month_Number,
    FORMAT(DateValue, 'MMMM') AS Month_Name,
    FORMAT(DateValue, 'MMM') AS Month_Short,
    DATEPART(quarter, DateValue) AS Quarter,
    CONCAT('Q', DATEPART(quarter, DateValue)) AS Quarter_Name,
    DATEPART(weekday, DateValue) AS Weekday_Number,
    FORMAT(DateValue, 'dddd') AS Weekday_Name,
    DATEPART(week, DateValue) AS Week_Number
FROM DateSequence
OPTION (MAXRECURSION 32767);


----------------------------------------------------------------------------------------------------
--Distinct order

SELECT COUNT(DISTINCT( PO_ID)) as Order1,MONTH(Order_Date) as M
FROM Silver.Silver_Procurement
GROUP BY MONTH(Order_Date)
ORDER BY M





















