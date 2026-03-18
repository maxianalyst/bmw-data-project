# 🏎️ BMW Global Sales & Market Intelligence Analysis

## 📌 Resumen del Proyecto
Este proyecto presenta un análisis técnico del rendimiento de ventas globales de BMW (2018-2025). 
Se centra en la integración de **SQL** para el procesamiento de datos y **Power BI** para la visualización de resultados, analizando la transición hacia vehículos eléctricos (BEV) y su contexto macroeconómico.

* Dataset: Los datos crudos fueron obtenidos de https://www.kaggle.com/datasets/dmahajanbe23/bmw-global-automotive-sales.

## 🛠️ Stack Tecnológico
* **Data Engineering (SQL):** Procesamiento de datos, limpieza profunda (ETL) y diseño de un modelo relacional en estrella (*Star Schema*).
* **Business Intelligence (Power BI):** Modelado de datos relacional, diseño de reportes interactivos y desarrollo de métricas mediante DAX.

## 📂 Estructura y Flujo de Trabajo
El proceso técnico está documentado paso a paso dentro de los archivos SQL, donde se detalla cada etapa del análisis:

1. **`bmw_raw_sales.csv`**: Dataset fuente con los datos originales de la marca.
2. **`01_bmw_eda.sql`**: **Análisis Exploratorio (EDA)**. Contiene la validación de integridad, detección de duplicados, manejo de nulos y limpieza inicial.
3. **`02_bmw_etl_modeling.sql`**: **ETL y Modelado**. Documentación del proceso de transformación y creación de tablas de hechos y dimensiones para optimizar el análisis.
4. **`03_bmw_analysis_queries.sql`**: **Consultas de Análisis**. Scripts diseñados para extraer insights específicos de negocio directamente desde la base de datos.
5. **`bmw_dashboard.pbix`**: Dashboard interactivo donde se visualizan los hallazgos finales.
6. **`bmw_night_theme.json`**: Configuración de la paleta de colores personalizada del reporte.

## 📈 Insights y Métricas Clave
* **Estrategia Premium:** El Precio Promedio de Venta (ASP) se sitúa en **$64.08K**, reafirmando el posicionamiento de lujo de la marca.
* **Transición Eléctrica:** Se identificó una cuota de mercado global de **11%** para vehículos eléctricos de batería (BEV).
* **Indicadores Macro:** El análisis revela la resiliencia del volumen de ventas frente a variables como el crecimiento del PIB y las fluctuaciones del precio del combustible.

## 📖 Glosario de Métricas (Data Dictionary)
Para facilitar la interpretación de los scripts de SQL y el Dashboard, se detallan las definiciones de negocio utilizadas:

* **ASP (Average Selling Price):** Precio promedio de venta por unidad (Ingresos totales / Unidades vendidas).
* **BEV Share:** Porcentaje de penetración de vehículos eléctricos de batería en el total de ventas.
* **GDP Growth:** Variación porcentual del Producto Interno Bruto por región (Indicador macro).
* **Fuel Price Index:** Índice de precios de combustible ajustado por región y año.
* **Premium Share:** Participación de modelos de alta gama dentro del volumen total de ventas de la marca.
