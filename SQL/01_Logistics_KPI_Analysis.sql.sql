/*
PROJECT: European Logistics Supply Chain Analysis

ROLE TARGET:
Operations & Supply Chain Data Analyst

OBJECTIVE:
Analyze shipment performance, carrier reliability,
warehouse efficiency, and route delays to identify
operational bottlenecks and service improvement opportunities.

TOOLS USED:
Excel, SQL Server, Power BI
*/

-- =========================
-- DATA VALIDATION CHECKS
-- =========================
-- Purpose:
-- Ensure all tables loaded correctly before analysis.
-- This step confirms dataset completeness and integrity.

SELECT COUNT(*) FROM Customers;
SELECT COUNT(*) FROM Products;
SELECT COUNT(*) FROM Warehouses;
SELECT COUNT(*) FROM Carriers;
SELECT COUNT(*) FROM Routes;
SELECT COUNT(*) FROM Orders;
SELECT COUNT(*) FROM Order_Items;
SELECT COUNT(*) FROM Shipments;



-- =========================
-- KPI 1: Delivery Performance Overview
-- =========================
-- Business Question:
-- What percentage of shipments are delivered on time versus delayed?

-- Business Value:
-- Measures overall service reliability and SLA performance.
-- Helps management track customer satisfaction levels and
-- identify if delay trends are increasing.

SELECT
Delivery_Status,
COUNT(*) AS Total_Shipments
FROM Shipments
GROUP BY Delivery_Status
ORDER BY Total_Shipments DESC;



-- =========================
-- KPI 2: Route Performance Analysis
-- =========================
-- Business Question:
-- Which shipping routes experience the highest delays?

-- Business Value:
-- Identifies underperforming logistics corridors and helps
-- optimize route planning, carrier selection, and transit scheduling.

SELECT
r.Origin_City,
r.Destination_City,
COUNT(s.Shipment_ID) AS Total_Shipments,
AVG(CAST(s.Delay_Days AS INT)) AS Average_Delay
FROM Shipments s
JOIN Routes r
ON s.Route_ID = r.Route_ID
GROUP BY
r.Origin_City,
r.Destination_City
ORDER BY Average_Delay DESC;



-- =========================
-- KPI 3: Carrier Reliability Analysis
-- =========================
-- Business Question:
-- Which carriers deliver shipments with the lowest delay rates?

-- Business Value:
-- Supports vendor performance evaluation and helps logistics
-- managers negotiate contracts or reallocate shipment volumes
-- toward higher performing carriers.

SELECT
c.Carrier_Name,
c.Reliability_Rating,
COUNT(s.Shipment_ID) AS Total_Shipments,
AVG(CAST(s.Delay_Days AS INT)) AS Average_Delay
FROM Shipments s
JOIN Carriers c
ON s.Carrier_ID = c.Carrier_ID
GROUP BY
c.Carrier_Name,
c.Reliability_Rating
ORDER BY Average_Delay DESC;



-- =========================
-- KPI 4: Warehouse Performance
-- =========================
-- Business Question:
-- Which warehouses are associated with the highest shipment delays?

-- Business Value:
-- Helps identify operational inefficiencies such as handling
-- delays, storage mismatches, or processing bottlenecks.
-- Supports warehouse resource planning and infrastructure decisions.

SELECT
w.Warehouse_Name,
w.Storage_Type,
COUNT(s.Shipment_ID) AS Total_Shipments,
AVG(CAST(s.Delay_Days AS INT)) AS Average_Delay
FROM Shipments s
JOIN Warehouses w
ON s.Warehouse_ID = w.Warehouse_ID
GROUP BY
w.Warehouse_Name,
w.Storage_Type
ORDER BY Average_Delay DESC;



-- =========================
-- KPI 5: Priority Order Performance
-- =========================
-- Business Question:
-- Are high-priority or critical orders receiving faster delivery performance?

-- Business Value:
-- Evaluates SLA adherence for premium or urgent shipments and
-- helps ensure that operational priorities align with business commitments.

SELECT
o.Order_Priority,
COUNT(s.Shipment_ID) AS Total_Shipments,
AVG(CAST(s.Delay_Days AS INT)) AS Average_Delay
FROM Shipments s
JOIN Orders o
ON s.Order_ID = o.Order_ID
GROUP BY
o.Order_Priority
ORDER BY Average_Delay DESC;



-- =========================
-- KPI 6: Order Splitting Analysis
-- =========================
-- Business Question:
-- How frequently are orders split across multiple shipments?

-- Business Value:
-- Reveals fulfillment complexity and inventory distribution challenges.
-- High split frequency may increase transportation costs and
-- impact customer delivery experience.

SELECT
Order_ID,
COUNT(Shipment_ID) AS Shipment_Count
FROM Shipments
GROUP BY Order_ID
HAVING COUNT(Shipment_ID) > 1
ORDER BY Shipment_Count DESC;


/*
SUMMARY:

This analysis identifies key performance drivers in the
European logistics network including delivery reliability,
route efficiency, carrier performance, warehouse operations,
and order fulfillment complexity.

The insights generated from this analysis support strategic
decision-making to improve supply chain efficiency and
customer satisfaction.
*/