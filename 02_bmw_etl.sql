/*
ETL (Extract, Transform, Load) & Data Modeling / (Extracción, Transformación, Carga) y Modelado de Datos.
EN: Cleaning raw data, implementing business logic, and structuring the schema into dimensions and a fact table to ensure high-performance analytics.
ES: Limpieza de datos crudos, implementación de reglas de negocio y estructuración del esquema en dimensiones y una tabla de hechos para garantizar análisis de alto rendimiento.
*/


-- ====================================
-- 1. Data Cleaning & Transform / Limpieza y transformación de datos.
-- ====================================

DROP TABLE IF EXISTS bmw_sales_clean;

CREATE TABLE bmw_sales_clean (
    sales_id VARCHAR(100) PRIMARY KEY,
    sales_date DATE,
    sales_year INT,
    sales_month INT,
    region VARCHAR(50),
    model VARCHAR(50),
    units_sold INT,
    avg_price_eur DECIMAL(10, 2),
    revenue_eur DECIMAL(15, 2),
    bev_share DECIMAL(5, 4),
    premium_share DECIMAL(5, 2),
    gdp_growth DECIMAL(5, 2),
    fuel_price_index DECIMAL(5, 2)
);

INSERT INTO bmw_sales_clean
SELECT
    CONCAT(Year, '-', Month, '-', Region, '-', Model) AS sales_id,
    CAST(CONCAT(Year, '-', Month, '-01') AS DATE) AS date_id,
    Year,
    Month,
    TRIM(Region),
    TRIM(Model),
    Units_Sold,
    ROUND(Avg_Price_EUR, 2),
    ROUND(Revenue_EUR, 2),

    CASE 
        WHEN BEV_Share < 0 THEN 0 
        ELSE BEV_Share 
    END AS bev_share,
    Premium_Share,
    GDP_Growth,
    Fuel_Price_Index
FROM bmw_sales
WHERE Units_Sold > 0;

-- ====================================
-- 2. Dimension Tables / Tablas de dimensión.
-- ====================================

-- 2.1 Time Dimension / Dimensión de tiempo.
CREATE TABLE dim_date (
    sales_date DATE PRIMARY KEY,
    sales_year INT,
    sales_month INT,
    month_name VARCHAR(20),
    sales_quarter INT
);

INSERT INTO dim_date
SELECT DISTINCT 
    sales_date, 
    sales_year, 
    sales_month,
    MONTHNAME(sales_date),
    QUARTER(sales_date)
FROM bmw_sales_clean;

-- 2.2 Region Dimension / Dimensión de regiones.
CREATE TABLE dim_region (
    region VARCHAR(50) PRIMARY KEY
);

INSERT INTO dim_region
SELECT DISTINCT region FROM bmw_sales_clean;

-- 2.3 Model Dimension / Dimensión de modelos.
CREATE TABLE dim_model (
    model VARCHAR(50) PRIMARY KEY
);

INSERT INTO dim_model
SELECT DISTINCT model FROM bmw_sales_clean;

-- 2.4 Market Trends Dimension (Macro) / Dimensión de tendencias de mercado.
CREATE TABLE dim_market_trends (
    market_trend_id VARCHAR(100) PRIMARY KEY,
    sales_date DATE,
    region VARCHAR(50),
    gdp_growth DECIMAL(5, 2),
    fuel_price_index DECIMAL(5, 2),
    premium_share DECIMAL(5, 2)
);

INSERT INTO dim_market_trends
SELECT DISTINCT
    CONCAT(sales_date, '-', region) AS market_trend_id,
    sales_date,
    region,
    gdp_growth,
    fuel_price_index,
    premium_share
FROM bmw_sales_clean;

-- ====================================
-- 3. Fact Table / Tabla de hechos.
-- ====================================
CREATE TABLE fact_sales (
    sales_id VARCHAR(100) PRIMARY KEY,
    market_trend_id VARCHAR(100),
    sales_date DATE,
    region VARCHAR(50),
    model VARCHAR(50),
    units_sold INT,
    avg_price_eur DECIMAL(15, 2),
    revenue_eur DECIMAL(18, 2),
    bev_share DECIMAL(5, 4)
);

INSERT INTO fact_sales
SELECT 
    sales_id,
	CONCAT(sales_date, '-', region) AS market_trend_id,
    sales_date,
    region,
    model,
    units_sold,
    avg_price_eur,
    revenue_eur,
    bev_share
FROM bmw_sales_clean;
