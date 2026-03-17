/*
Data Analysis & Business Insights / Análisis de Datos e Información Empresarial.
EN: SQL queries designed to extract actionable insights regarding regional performance, product segmentation, temporal trends, and market leaders.
ES: Consultas SQL diseñadas para extraer hallazgos estratégicos sobre desempeño regional, segmentación de productos, tendencias temporales y líderes de mercado.
*/

-- 1. Regional Performance vs Global Average / Desempeño regional vs promedio global.
-- EN: Identifies regions generating revenue above the global average.
-- ES: Identifica regiones que generan ingresos superiores al promedio global.

SELECT 
    r.region, 
    ROUND(SUM(f.revenue_eur), 2) AS total_revenue
FROM fact_sales f
JOIN dim_region r ON f.region = r.region
GROUP BY r.region
HAVING SUM(f.revenue_eur) > (
    SELECT AVG(region_revenue)
    FROM (
        SELECT SUM(revenue_eur) AS region_revenue
        FROM fact_sales
        GROUP BY region
    ) AS sub
);

-- 2. Sales by Price Segment / Ventas por segmento de precio.
-- EN: Classifies models into price tiers to analyze revenue distribution.
-- ES: Clasifica los modelos en segmentos de precio para analizar la distribución de ingresos.

SELECT 
    CASE 
        WHEN avg_price_eur < 45000 THEN 'Entry Level'
        WHEN avg_price_eur BETWEEN 45000 AND 75000 THEN 'Mid-Range'
        ELSE 'Luxury'
    END AS model_segment,
    SUM(units_sold) AS total_units,
    ROUND(SUM(revenue_eur), 2) AS total_revenue
FROM fact_sales
GROUP BY model_segment
ORDER BY total_revenue DESC;

-- 2. Sales by Price Segment / Ventas por segmento de precio.
-- EN: Classifies models into price tiers to analyze revenue distribution.
-- ES: Clasifica los modelos en segmentos de precio para analizar la distribución de ingresos.

SELECT 
    sales_date,
    SUM(revenue_eur) AS monthly_revenue,
    LAG(SUM(revenue_eur)) OVER (ORDER BY sales_date) AS prev_month_revenue,
		ROUND((SUM(revenue_eur) - LAG(SUM(revenue_eur)) OVER (ORDER BY sales_date)) / 
		LAG(SUM(revenue_eur)) OVER (ORDER BY sales_date) * 100, 2) AS growth_pct
FROM fact_sales
GROUP BY sales_date;

-- 4. Top Selling Model per Region / Modelo más vendido por región.
-- EN: Uses ranking functions to identify the best-selling model in each geographic area.
-- ES: Utiliza funciones de ranking para identificar el modelo más vendido en cada área geográfica.

SELECT * FROM (
    SELECT 
        region, 
        model, 
        SUM(units_sold) AS total_units,
        RANK() OVER (PARTITION BY region ORDER BY SUM(units_sold) DESC) AS ranking
    FROM fact_sales
    GROUP BY region, model
) AS top_models
WHERE ranking = 1;