/*
EDA (Exploratory Data Analysis) / Análisis Exploratorio de Datos.
EN: Initial data assessment to understand structure, identify missing values, ensure data integrity, and detect potential outliers.
ES: Evaluación inicial de los datos para comprender la estructura, identificar valores faltantes, asegurar la integridad de los datos y detectar posibles anomalías.
*/


-- 1. Dataset Preview / Vista previa del conjunto de datos.
SELECT *
FROM bmw_sales;

-- 2. Table Structure / Estructura de la tabla.
DESCRIBE bmw_sales;

-- 3. Dataset Size / Tamaño del conjunto de datos.
SELECT COUNT(*) AS total_rows
FROM bmw_sales;

-- 4. Duplicate Check / Verificación de duplicados.
SELECT 
	year, 
	month, 
	region,
    model,
	COUNT(*) AS occurrences
FROM bmw_sales
GROUP BY year, month, region, model
HAVING COUNT(*) > 1;

-- 5. Missing Values Check / Verificación de valores faltantes.
SELECT
    SUM(CASE WHEN units_sold IS NULL THEN 1 ELSE 0 END) AS null_units,
    SUM(CASE WHEN avg_price_eur IS NULL THEN 1 ELSE 0 END) AS null_price,
    SUM(CASE WHEN revenue_eur IS NULL THEN 1 ELSE 0 END) AS null_revenue,
    SUM(CASE WHEN bev_share IS NULL THEN 1 ELSE 0 END) AS null_bev,
    SUM(CASE WHEN premium_share IS NULL THEN 1 ELSE 0 END) AS null_premium,
    SUM(CASE WHEN gdp_growth IS NULL THEN 1 ELSE 0 END) AS null_gdp,
    SUM(CASE WHEN fuel_price_index IS NULL THEN 1 ELSE 0 END) AS null_fuel
FROM bmw_sales;
    
-- 6. Time Range Analysis / Análisis del rango temporal.
SELECT
	MIN(year) AS start_year,
	MAX(year) AS end_year,
	COUNT(DISTINCT(year)) AS total_years
FROM bmw_sales;

-- 7. Temporal Distribution / Distribución temporal.
SELECT
	year,
    COUNT(*) AS records,
    SUM(units_sold) AS units_sold,
    SUM(revenue_eur) AS revenue
FROM bmw_sales
GROUP BY year
ORDER BY year;

-- 8. Categorical Exploration / Exploración categórica.
SELECT DISTINCT(model) FROM bmw_sales;
SELECT DISTINCT(region) FROM bmw_sales;

-- 9. Numerical Stats by Region / Estadísticas numéricas por región.
SELECT 
    region,
    ROUND(AVG(avg_price_eur), 2) AS avg_price,
    ROUND(AVG(bev_share), 4) AS avg_bev_market_share,
    ROUND(AVG(gdp_growth), 2) AS avg_gdp_growth
FROM bmw_sales
GROUP BY region;

-- 10. Revenue Consistency Check / Validación de consistencia de ingresos.
SELECT 
    year, month, region, model,
    revenue_eur,
    (units_sold * avg_price_eur) AS calculated_revenue,
    ABS(revenue_eur - (units_sold * avg_price_eur)) AS diff
FROM bmw_sales
WHERE ABS(revenue_eur - (units_sold * avg_price_eur)) > 1
LIMIT 10;


-- 11. Macro Variable Consistency Check / Validación de consistencia de variables macro.
SELECT 
    year, month, region, 
    COUNT(DISTINCT gdp_growth) AS distinct_gdp_values
FROM bmw_sales
GROUP BY year, month, region
HAVING COUNT(DISTINCT gdp_growth) > 1;
