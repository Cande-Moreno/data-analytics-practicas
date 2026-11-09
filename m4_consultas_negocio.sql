
-- Motor utilizado: Microsoft SQL Server
-- Proyecto: RetailPro
-- Base de datos: Ventas_Tech_DB

USE Ventas_Tech_DB;
GO

-- =========================================
-- CONSULTA 1: RESUMEN EJECUTIVO MENSUAL
-- Total facturado, pedidos y ticket promedio
-- =========================================

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;
GO


-- =========================================
-- CONSULTA 2: RANKING DE PRODUCTOS
-- Top 5 por total facturado
-- =========================================

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;
GO


-- =========================================
-- CONSULTA 3: CLIENTES RECURRENTES
-- Clientes con más de un pedido
-- =========================================

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;
GO


-- =========================================
-- CONSULTA 4: PRODUCTOS POR ENCIMA O
-- POR DEBAJO DEL PROMEDIO DE FACTURACIÓN
-- =========================================

WITH FacturacionPorProducto AS (
    SELECT
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto
)

SELECT
    id_producto,
    total_facturado,
    CASE
        WHEN total_facturado >= (
            SELECT AVG(total_facturado)
            FROM FacturacionPorProducto
        )
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM FacturacionPorProducto
ORDER BY total_facturado DESC;
GO


-- =========================================
-- BLOQUE DE CIERRE: 3 HALLAZGOS
-- =========================================

-- 1. El producto 1 es el que más facturación genera,
--    con un total de $3.600,00.

-- 2. Los cinco clientes realizaron más de un pedido,
--    por lo que todos califican como clientes recurrentes.

-- 3. Los productos 1 y 3 superan el promedio de
--    facturación por producto, que es de $1.074,00.
