-- sel
-- 1
SELECT COUNT(*)
FROM Inventario
    INNER JOIN Entrega ON Entrega.identrega = Inventario.identrega
WHERE Entrega.titulo = 'SUGAR WONKA';
-- 2
SELECT cliente.nombre,
    cliente.apellido,
    sum(renta.montopagar) AS pagototal
FROM Renta
    INNER JOIN cliente ON cliente.idcliente = renta.idcliente
GROUP BY cliente.nombre,
    cliente.apellido
HAVING COUNT(*) >= 40;
-- 3
SELECT CONCAT(nombre, ' ', apellido) AS nombrecompleto
FROM Actor
WHERE apellido LIKE '%son%'
    OR apellido LIKE 'Son%'
ORDER BY nombre;
-- 4
-- TODO preguntar sobre si son las 2 o solo una
SELECT DISTINCT entrega.lanzamiento,
    actor.nombre,
    actor.apellido
FROM actorentrega
    INNER JOIN entrega ON entrega.identrega = actorentrega.identrega
    INNER JOIN actor ON actor.idactor = actorentrega.idactor
WHERE entrega.descripcion LIKE '%Crocodile%'
    OR entrega.descripcion LIKE '%Shark%'
ORDER BY actor.apellido ASC;
-- 5
-- TODO es de cada pais 
with COSTOPAIS AS (
    SELECT sum(renta.montopagar) as suma,
        pais.nombre
    FROM pais
        INNER JOIN ciudad ON pais.idpais = ciudad.idpais
        INNER JOIN direccion ON ciudad.idciudad = direccion.idciudad
        INNER JOIN cliente ON cliente.iddireccion = direccion.iddireccion
        INNER JOIN renta ON renta.idcliente = cliente.idcliente
    GROUP BY pais.idpais
),
AUXILIAR as(
    SELECT pais.nombre AS pais,
        cliente.nombre,
        cliente.apellido,
        sum(renta.montopagar) AS pagopersona,
        COSTOPAIS.suma AS pagopais,
        COUNT(*) AS rentas,
        (sum(renta.montopagar) / COSTOPAIS.suma) * 100 AS porcentaje,
        rownumber() over (
            partition BY pais.nombre
            ORDER BY COUNT(*) desc
        ) AS rank
    FROM Renta
        cross join COSTOPAIS
        INNER JOIN cliente ON cliente.idcliente = renta.idcliente
        INNER JOIN direccion ON cliente.iddireccion = direccion.iddireccion
        INNER JOIN ciudad ON direccion.idciudad = ciudad.idciudad
        INNER JOIN pais ON ciudad.idpais = pais.idpais
    GROUP BY cliente.nombre,
        cliente.apellido,
        COSTOPAIS.suma,
        COSTOPAIS.nombre,
        pais.nombre
    HAVING COSTOPAIS.nombre = pais.nombre
    ORDER BY COUNT(*) desc
)
SELECT AUXILIAR.pais,
    AUXILIAR.nombre,
    AUXILIAR.apellido,
    AUXILIAR.porcentaje
FROM COSTOPAIS
    INNER JOIN AUXILIAR ON COSTOPAIS.nombre = AUXILIAR.pais
WHERE AUXILIAR.rank = 1;
-- 6
with CLIENTESCIUDAD as(
    SELECT COUNT(cliente.idcliente) as clientes,
        ciudad.nombre AS nombre,
        ciudad.idpais
    FROM Ciudad
        INNER JOIN Direccion ON Direccion.idciudad = Ciudad.idciudad
        INNER JOIN Cliente ON Cliente.iddireccion = Direccion.iddireccion
    GROUP BY ciudad.idpais,
        ciudad.nombre
),
CLIENTESPAIS as(
    SELECT COUNT(cliente.idcliente) as clientes,
        pais.nombre AS nombre,
        pais.idpais
    FROM Pais
        INNER JOIN Ciudad ON Ciudad.idpais = Pais.idpais
        INNER JOIN Direccion ON Direccion.idciudad = Ciudad.idciudad
        INNER JOIN Cliente ON Cliente.iddireccion = Direccion.iddireccion
    GROUP BY pais.nombre,
        pais.idpais
)
SELECT CLIENTESCIUDAD.nombre AS nombreciudad,
    CLIENTESCIUDAD.clientes AS clientesciudad,
    CLIENTESPAIS.nombre AS nombrepais,
    CLIENTESPAIS.clientes AS clientespais,
    (
        CAST(CLIENTESCIUDAD.clientes AS FLOAT) / CLIENTESPAIS.clientes
    ) * 100 AS porcentaje
FROM CLIENTESCIUDAD
    INNER JOIN CLIENTESPAIS ON CLIENTESCIUDAD.idpais = CLIENTESPAIS.idpais;
-- 7
with RENTAPAIS AS (
    SELECT COUNT(renta.montopagar) AS rentas,
        pais.nombre,
        pais.idpais
    FROM renta
        INNER JOIN cliente ON cliente.idcliente = renta.idcliente
        INNER JOIN direccion ON cliente.iddireccion = direccion.iddireccion
        INNER JOIN ciudad ON direccion.idciudad = ciudad.idciudad
        INNER JOIN pais ON ciudad.idpais = pais.idpais
    GROUP BY pais.nombre,
        pais.idpais
),
RENTACIUDAD as(
    SELECT COUNT(renta.montopagar) AS rentas,
        ciudad.nombre,
        ciudad.idpais
    FROM renta
        INNER JOIN cliente ON cliente.idcliente = renta.idcliente
        INNER JOIN direccion ON cliente.iddireccion = direccion.iddireccion
        INNER JOIN ciudad ON direccion.idciudad = ciudad.idciudad
    GROUP BY ciudad.idciudad,
        ciudad.nombre,
        ciudad.idpais
),
CIUDADESPAIS AS (
    SELECT COUNT(*) AS cantidad,
        pais.idpais
    FROM pais
        INNER JOIN ciudad ON ciudad.idpais = pais.idpais
    GROUP BY ciudad.idpais,
        pais.idpais
)
SELECT RENTAPAIS.nombre AS nombrepais,
    RENTACIUDAD.nombre AS nombreciudad,
    CAST(RENTAPAIS.rentas AS FLOAT) / CIUDADESPAIS.cantidad AS promedio
FROM RENTAPAIS
    INNER JOIN RENTACIUDAD ON RENTACIUDAD.idpais = RENTAPAIS.idpais
    INNER JOIN CIUDADESPAIS ON CIUDADESPAIS.idpais = RENTAPAIS.idpais;
-- 8
with RENTASTOTALES as(
    SELECT COUNT(renta.montopagar) AS rentas,
        pais.nombre,
        pais.idpais
    FROM renta
        INNER JOIN cliente ON cliente.idcliente = renta.idcliente
        INNER JOIN direccion ON cliente.iddireccion = direccion.iddireccion
        INNER JOIN ciudad ON direccion.idciudad = ciudad.idciudad
        INNER JOIN pais ON ciudad.idpais = pais.idpais
    GROUP BY pais.idpais,
        pais.nombre
),
RENTASSPORTS as(
    SELECT COUNT(renta.montopagar) AS rentas,
        pais.nombre,
        pais.idpais
    FROM renta
        INNER JOIN cliente ON cliente.idcliente = renta.idcliente
        INNER JOIN direccion ON cliente.iddireccion = direccion.iddireccion
        INNER JOIN ciudad ON direccion.idciudad = ciudad.idciudad
        INNER JOIN pais ON ciudad.idpais = pais.idpais
        INNER JOIN pelicula ON renta.idpelicula = pelicula.idpelicula
        INNER JOIN entrega ON entrega.identrega = pelicula.identrega
        INNER JOIN categoriaentrega ON categoriaentrega.identrega = entrega.identrega
        INNER JOIN categoria ON categoriaentrega.idcategoria = categoria.idcategoria
    GROUP BY pais.idpais,
        pais.nombre,
        categoria.categoria
    HAVING categoria.categoria = 'Sports'
)
SELECT RENTASTOTALES.nombre,
    (
        CAST(RENTASSPORTS.rentas AS FLOAT) / RENTASTOTALES.rentas
    ) * 100 AS porcentaje
FROM RENTASTOTALES
    INNER JOIN RENTASSPORTS ON RENTASTOTALES.idpais = RENTASSPORTS.idpais;
-- 9
with CIUDADESLISTADO as(
    SELECT ciudad.nombre,
        ciudad.idciudad,
        ciudad.idpais
    FROM Ciudad
        INNER JOIN Pais ON pais.idpais = ciudad.idpais
    WHERE pais.nombre = 'United States'
),
RENTASCIUDADES as(
    SELECT COUNT(renta.montopagar) AS rentas,
        ciudad.nombre,
        ciudad.idciudad,
        ciudad.idpais
    FROM renta
        INNER JOIN cliente ON cliente.idcliente = renta.idcliente
        INNER JOIN direccion ON cliente.iddireccion = direccion.iddireccion
        INNER JOIN ciudad ON direccion.idciudad = ciudad.idciudad
        INNER JOIN pais ON ciudad.idpais = pais.idpais
    GROUP BY ciudad.nombre,
        ciudad.idciudad,
        ciudad.idpais,
        pais.nombre
    HAVING pais.nombre = 'United States'
),
RENTASDAYTON as(
    SELECT COUNT(renta.montopagar) AS rentas,
        ciudad.nombre,
        ciudad.idciudad,
        ciudad.idpais
    FROM renta
        INNER JOIN cliente ON cliente.idcliente = renta.idcliente
        INNER JOIN direccion ON cliente.iddireccion = direccion.iddireccion
        INNER JOIN ciudad ON direccion.idciudad = ciudad.idciudad
    GROUP BY ciudad.nombre,
        ciudad.idciudad,
        ciudad.idpais
    HAVING ciudad.nombre = 'Dayton'
)
SELECT CIUDADESLISTADO.nombre,
    RENTASCIUDADES.rentas
FROM CIUDADESLISTADO
    INNER JOIN RENTASCIUDADES ON CIUDADESLISTADO.idciudad = RENTASCIUDADES.idciudad
    INNER JOIN RENTASDAYTON ON CIUDADESLISTADO.idpais = RENTASDAYTON.idpais
WHERE RENTASCIUDADES.rentas > RENTASDAYTON.rentas;
-- 10
with TOPS as(
    SELECT ciudad.nombre AS ciudad,
        pais.nombre AS pais,
        categoria.categoria,
        COUNT(categoria.categoria) AS contador,
        rownumber() over (
            partition BY ciudad.nombre
            ORDER BY COUNT(categoria.categoria) desc
        ) AS rank
    FROM renta
        INNER JOIN cliente ON cliente.idcliente = renta.idcliente
        INNER JOIN direccion ON cliente.iddireccion = direccion.iddireccion
        INNER JOIN ciudad ON direccion.idciudad = ciudad.idciudad
        INNER JOIN pais ON ciudad.idpais = pais.idpais
        INNER JOIN pelicula ON renta.idpelicula = pelicula.idpelicula
        INNER JOIN entrega ON entrega.identrega = pelicula.identrega
        INNER JOIN categoriaentrega ON categoriaentrega.identrega = entrega.identrega
        INNER JOIN categoria ON categoriaentrega.idcategoria = categoria.idcategoria
    GROUP BY ciudad.idciudad,
        ciudad.nombre,
        pais.nombre,
        categoria.categoria
)
SELECT ciudad,
    pais,
    contador
FROM TOPS
WHERE rank = 1
    AND categoria = 'Horror';