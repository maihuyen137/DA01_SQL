-- Chuyển đổi kiểu dữ liệu
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE integer USING (ordernumber::integer),
ALTER COLUMN quantityordered TYPE integer USING (quantityordered::integer),
ALTER COLUMN priceeach TYPE numeric USING (priceeach::numeric),
ALTER COLUMN orderlinenumber TYPE smallint USING (orderlinenumber::smallint),
ALTER COLUMN sales TYPE numeric USING (sales::numeric),
ALTER COLUMN orderdate TYPE timestamp USING (orderdate::timestamp),
ALTER COLUMN status TYPE text USING (status::text),
ALTER COLUMN productline TYPE text USING (productline::text),
ALTER COLUMN msrp TYPE smallint USING (msrp::smallint),
ALTER COLUMN customername TYPE text USING (customername::text),
ALTER COLUMN city TYPE text USING (city::text),
ALTER COLUMN state TYPE text USING (state::text),
ALTER COLUMN country TYPE text USING (country::text),
ALTER COLUMN territory TYPE text USING (territory::text),
ALTER COLUMN contactfullname TYPE text USING (contactfullname::text),
ALTER COLUMN dealsize TYPE text USING (dealsize::text)

-- Kiểm ta null/blank
SELECT * FROM sales_dataset_rfm_prj
WHERE ordernumber IS NULL
OR quantityordered IS NULL
OR priceeach IS NULL
OR orderlinenumber IS NULL
OR sales IS NULL
OR orderdate IS NULL

-- Thêm cột
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN contactlastname varchar(15),
ADD COLUMN contactfirstname varchar(15);
UPDATE sales_dataset_rfm_prj
SET contactlastname=RIGHT(contactfullname,length(contactfullname)-position('-' in contactfullname)),
contactfirstname=LEFT(contactfullname,position('-' in contactfullname)-1);
UPDATE sales_dataset_rfm_prj
SET contactlastname=CONCAT(UPPER(LEFT(contactlastname,1)),LOWER(RIGHT(contactlastname,length(contactlastname)-1))),
contactfirstname=CONCAT(UPPER(LEFT(contactfirstname,1)),LOWER(RIGHT(contactfirstname,length(contactfirstname)-1)));

-- Thêm cột
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN QTR_ID numeric,
ADD COLUMN MONTH_ID numeric,
ADD COLUMN YEAR_ID numeric;
UPDATE sales_dataset_rfm_prj
SET QTR_ID = EXTRACT(QUARTER FROM orderdate),
MONTH_ID = EXTRACT(MONTH FROM orderdate),
YEAR_ID = EXTRACT(YEAR FROM orderdate)

-- Tìm outlier
WITH twt_min_max_value AS
(SELECT Q1-1.5*IQR AS min_value, Q3+1.5*IQR AS max_value FROM
(SELECT
percentile_cont(0.25) WITHIN GROUP(ORDER BY quantityordered) as Q1,
percentile_cont(0.75) WITHIN GROUP(ORDER BY quantityordered) as Q3,
percentile_cont(0.75) WITHIN GROUP(ORDER BY quantityordered)-percentile_cont(0.25) WITHIN GROUP(ORDER BY quantityordered) as IQR
FROM sales_dataset_rfm_prj) AS min_max)
SELECT * FROM sales_dataset_rfm_prj
WHERE quantityordered < (SELECT min_value FROM twt_min_max_value)
OR quantityordered > (SELECT max_value FROM twt_min_max_value); -- E thấy z-score TH bằng |z|>2 thì cân nhắc nên em làm theo Boxplot ạ

WITH twt_outlier AS
(SELECT * FROM sales_dataset_rfm_prj
WHERE quantityordered < (SELECT min_value FROM twt_min_max_value)
OR quantityordered > (SELECT max_value FROM twt_min_max_value))
UPDATE sales_dataset_rfm_prj
SET quantityordered=(SELECT AVG(quantityordered) FROM sales_dataset_rfm_prj)
WHERE quantityordered IN (SELECT quantityordered FROM twt_outlier);
-- c2:
DELETE FROM sales_dataset_rfm_prj
WHERE quantityordered IN (SELECT quantityordered FROM twt_outlier);

-- Chị ơi sao để các câu lệnh chạy liền nhau được thế 
