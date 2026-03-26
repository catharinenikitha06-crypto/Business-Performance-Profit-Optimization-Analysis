CREATE DATABASE retail_analysis;
USE retail_analysis;

CREATE TABLE sales_data (
    order_id VARCHAR(20),
    order_date DATE,
    region VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(100),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(4,2),
    profit DECIMAL(10,2)
);

-- Create helper table (numbers 0–99)
CREATE TABLE nums (n INT);

INSERT INTO nums (n)
VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

-- Expand to 100 rows
INSERT INTO nums SELECT n+10 FROM nums;
INSERT INTO nums SELECT n+20 FROM nums;
INSERT INTO nums SELECT n+40 FROM nums;

-- Now nums ≈ 80+ rows (enough for multiplication)
INSERT INTO sales_data
SELECT 
    ROW_NUMBER() OVER () AS order_id,
    
    DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND()*365) DAY) AS order_date,
    
    ELT(FLOOR(1 + RAND()*4), 'East','West','North','South') AS region,
    
    ELT(FLOOR(1 + RAND()*3), 'Technology','Furniture','Office Supplies') AS category,
    
    ELT(FLOOR(1 + RAND()*3), 'Phones','Chairs','Binders') AS sub_category,
    
    CONCAT('Product_', FLOOR(1 + RAND()*200)) AS product_name,
    
    ROUND(50 + RAND()*950,2) AS sales,
    
    FLOOR(1 + RAND()*10) AS quantity,
    
    ELT(FLOOR(1 + RAND()*5), 0,0.1,0.2,0.3,0.5) AS discount,
    
    ROUND((50 + RAND()*950) * (0.2 - ELT(FLOOR(1 + RAND()*5), 0,0.1,0.2,0.3,0.5)) * (0.5 + RAND()),2) AS profit

FROM nums a
CROSS JOIN nums b
LIMIT 10000;

SELECT COUNT(*) FROM sales_data;





TRUNCATE TABLE sales_data;



DROP TABLE IF EXISTS nums;

CREATE TABLE nums (n INT);

INSERT INTO nums (n)
VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

-- Make 100 rows
INSERT INTO nums SELECT n+10 FROM nums;
INSERT INTO nums SELECT n+20 FROM nums;
INSERT INTO nums SELECT n+40 FROM nums;


INSERT INTO sales_data
SELECT 
    (a.n * 100 + b.n + 1) AS order_id,   -- ✅ unique IDs
    
    DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND()*365) DAY),
    
    ELT(FLOOR(1 + RAND()*4), 'East','West','North','South'),
    
    ELT(FLOOR(1 + RAND()*3), 'Technology','Furniture','Office Supplies'),
    
    ELT(FLOOR(1 + RAND()*3), 'Phones','Chairs','Binders'),
    
    CONCAT('Product_', FLOOR(1 + RAND()*500)),  -- more variety
    
    ROUND(50 + RAND()*950,2),
    
    FLOOR(1 + RAND()*10),
    
    ELT(FLOOR(1 + RAND()*5), 0,0.1,0.2,0.3,0.5),
    
    ROUND((50 + RAND()*950) * 
          (0.25 - ELT(FLOOR(1 + RAND()*5), 0,0.1,0.2,0.3,0.5)) * 
          (0.5 + RAND()),2)

FROM nums a
CROSS JOIN nums b
LIMIT 10000;



DROP TABLE IF EXISTS sales_data;
DROP TABLE IF EXISTS nums;








CREATE TABLE sales_data (
    order_id INT,
    order_date DATE,
    region VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(100),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(4,2),
    profit DECIMAL(10,2)
);

CREATE TABLE nums AS
SELECT a.n + b.n*10 AS n
FROM 
(SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
(SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b;


SELECT COUNT(*) FROM nums;






INSERT INTO sales_data
SELECT 
    (a.n * 100 + b.n + 1) AS order_id,   -- unique 1–10000
    
    DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND()*365) DAY),
    
    ELT(FLOOR(1 + RAND()*4), 'East','West','North','South'),
    
    ELT(FLOOR(1 + RAND()*3), 'Technology','Furniture','Office Supplies'),
    
    ELT(FLOOR(1 + RAND()*3), 'Phones','Chairs','Binders'),
    
    CONCAT('Product_', FLOOR(1 + RAND()*500)),
    
    ROUND(50 + RAND()*950,2),
    
    FLOOR(1 + RAND()*10),
    
    ELT(FLOOR(1 + RAND()*5), 0,0.1,0.2,0.3,0.5),
    
    ROUND((50 + RAND()*950) * 
          (0.25 - ELT(FLOOR(1 + RAND()*5), 0,0.1,0.2,0.3,0.5)) * 
          (0.5 + RAND()),2)

FROM nums a
CROSS JOIN nums b;




SELECT COUNT(*) FROM sales_data;




SELECT COUNT(DISTINCT order_id) FROM sales_data;















SELECT 
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data;


SELECT 
    ROUND(SUM(profit)/SUM(sales)*100,2) AS profit_margin_pct
FROM sales_data;



SELECT 
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY category
ORDER BY total_profit ASC;






SELECT 
    sub_category,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY sub_category
ORDER BY total_profit ASC;SELECT 
    sub_category,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY sub_category
ORDER BY total_profit ASC;



SELECT 
    product_name,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_profit ASC
LIMIT 10;












UPDATE sales_data
SET product_name = 
CASE 
    WHEN category = 'Technology' THEN 
        ELT(FLOOR(1 + RAND()*5),
            'iPhone','Laptop','Headphones','Smartwatch','Tablet')

    WHEN category = 'Furniture' THEN 
        ELT(FLOOR(1 + RAND()*5),
            'Office Chair','Dining Table','Sofa','Bookshelf','Bed')

    ELSE 
        ELT(FLOOR(1 + RAND()*5),
            'Notebook','Pen Pack','Printer Paper','Art Kit','Files')
END;

SET SQL_SAFE_UPDATES = 0;


UPDATE sales_data
SET product_name = 
CASE 
    WHEN category = 'Technology' THEN 
        ELT(FLOOR(1 + RAND()*5),
            'iPhone','Laptop','Headphones','Smartwatch','Tablet')

    WHEN category = 'Furniture' THEN 
        ELT(FLOOR(1 + RAND()*5),
            'Office Chair','Dining Table','Sofa','Bookshelf','Bed')

    ELSE 
        ELT(FLOOR(1 + RAND()*5),
            'Notebook','Pen Pack','Printer Paper','Art Kit','Files')
END;


SELECT DISTINCT product_name FROM sales_data;




SELECT 
    product_name,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;


















SET SQL_SAFE_UPDATES = 0;

UPDATE sales_data
SET category = 
ELT(FLOOR(1 + RAND()*3),
    'Electronics',
    'Home & Living',
    'Fashion'
);



UPDATE sales_data
SET sub_category =
CASE 
    WHEN category = 'Electronics' THEN 
        ELT(FLOOR(1 + RAND()*3),
            'Mobiles','Laptops','Accessories')

    WHEN category = 'Home & Living' THEN 
        ELT(FLOOR(1 + RAND()*3),
            'Furniture','Decor','Kitchen')

    WHEN category = 'Fashion' THEN 
        ELT(FLOOR(1 + RAND()*3),
            'Men Wear','Women Wear','Footwear')
END;


UPDATE sales_data
SET product_name =
CASE 

-- 🔹 ELECTRONICS
WHEN sub_category = 'Mobiles' THEN 
    ELT(FLOOR(1 + RAND()*5),
        'iPhone 14','Samsung Galaxy S22','OnePlus 11','iQOO Neo','Pixel 7')

WHEN sub_category = 'Laptops' THEN 
    ELT(FLOOR(1 + RAND()*5),
        'MacBook Air','Dell XPS','HP Pavilion','Lenovo ThinkPad','Asus Vivobook')

WHEN sub_category = 'Accessories' THEN 
    ELT(FLOOR(1 + RAND()*5),
        'AirPods Pro','Boat Headphones','Wireless Mouse','SSD Drive','Keyboard')


-- 🔹 HOME & LIVING
WHEN sub_category = 'Furniture' THEN 
    ELT(FLOOR(1 + RAND()*5),
        'Sofa Set','Dining Table','Office Chair','Bed Frame','Wardrobe')

WHEN sub_category = 'Decor' THEN 
    ELT(FLOOR(1 + RAND()*5),
        'Wall Painting','Table Lamp','Carpet Rug','Wall Clock','Curtains')

WHEN sub_category = 'Kitchen' THEN 
    ELT(FLOOR(1 + RAND()*5),
        'Mixer Grinder','Cookware Set','Air Fryer','Dinner Set','Water Purifier')


-- 🔹 FASHION
WHEN sub_category = 'Men Wear' THEN 
    ELT(FLOOR(1 + RAND()*5),
        'Formal Shirt','Casual T-Shirt','Jeans','Blazer','Hoodie')

WHEN sub_category = 'Women Wear' THEN 
    ELT(FLOOR(1 + RAND()*5),
        'Kurti','Saree','Western Dress','Top','Skirt')

WHEN sub_category = 'Footwear' THEN 
    ELT(FLOOR(1 + RAND()*5),
        'Running Shoes','Heels','Sneakers','Sandals','Formal Shoes')

END;




SELECT DISTINCT category, sub_category FROM sales_data;



SELECT DISTINCT product_name FROM sales_data LIMIT 20;


















