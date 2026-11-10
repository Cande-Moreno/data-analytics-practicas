USE Ventas_Tech_DB;
GO

-- =========================================
-- CONSULTA 1: VISTA BASE DEL PROYECTO
-- INNER JOIN
-- Propósito: reunir ventas, clientes, productos,
-- categorías y ciudad en una sola consulta.
-- =========================================

SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad,
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;

-- Hallazgo: las 10 ventas registradas quedan vinculadas
-- con sus clientes, productos, categorías y ciudades.


-- =========================================
-- CONSULTA 2: CLIENTES SIN VENTAS
-- LEFT JOIN
-- Propósito: identificar clientes registrados
-- que todavía no realizaron compras.
-- =========================================

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo: no aparecen clientes sin compras.
-- Los 5 clientes registrados realizaron al menos un pedido.


-- =========================================
-- CONSULTA 3: PRODUCTOS SIN VENTAS
-- LEFT JOIN
-- Propósito: identificar productos del catálogo
-- que todavía no registraron ventas.
-- =========================================

SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos AS p
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- Hallazgo: no aparecen productos sin ventas.
-- Los 6 productos del catálogo tuvieron movimiento comercial.


-- =========================================
-- CONSULTA 4: CONSOLIDADO POR PERÍODO
-- UNION ALL
-- Propósito: comparar la facturación de dos períodos.
-- Se utiliza la fecha como criterio de separación.
-- =========================================

SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Primer período (1 al 10 de marzo)' AS canal
    FROM ventas
    WHERE fecha_venta >= '2024-03-01'
      AND fecha_venta < '2024-03-11'

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Segundo período (11 al 31 de marzo)' AS canal
    FROM ventas
    WHERE fecha_venta >= '2024-03-11'
      AND fecha_venta < '2024-04-01'
) AS consolidado
GROUP BY canal
ORDER BY canal;

-- Hallazgo: el primer período generó $3.620,
-- mientras que el segundo período generó $2.824.
-- El primer período tuvo mayor facturación.
