COPY Temporal
FROM '/home/ldecast/Documentos/VI Semestre/Archivos/Práctica1/BlockbusterData.csv' DELIMITER ';';
UPDATE Temporal
SET codigopostalcliente = null
WHERE codigopostalcliente = '-';
UPDATE Temporal
SET codigopostalempleado = null
WHERE codigopostalempleado = '-';
UPDATE Temporal
SET codigopostaltienda = null
WHERE codigopostaltienda = '-';
UPDATE Temporal
SET lanzamiento = null
WHERE lanzamiento = '-';
UPDATE Temporal
SET duracion = null
WHERE duracion = '-';
UPDATE Temporal
SET fecharenta = null
WHERE fecharenta = '-';
UPDATE Temporal
SET fecharetorno = null
WHERE fecharetorno = '-';
UPDATE Temporal
SET montopagar = null
WHERE montopagar = '-';
UPDATE Temporal
SET fechapago = null
WHERE fechapago = '-';
-- pais
INSERT INTO Pais (nombre)
SELECT DISTINCT paiscliente
FROM Temporal
WHERE paiscliente != '-'
    AND paiscliente not in (
        SELECT nombre
        FROM Pais
    );
INSERT INTO Pais (nombre)
SELECT DISTINCT paisempleado
FROM Temporal
WHERE paisempleado != '-'
    AND paisempleado not in (
        SELECT nombre
        FROM Pais
    );
INSERT INTO Pais (nombre)
SELECT DISTINCT paistienda
FROM Temporal
WHERE paistienda != '-'
    AND paistienda not in (
        SELECT nombre
        FROM Pais
    );
-- actor
INSERT INTO Actor (nombre, apellido)
SELECT DISTINCT SPLIT_PART(actorpelicula, ' ', 1),
    SPLIT_PART(actorpelicula, ' ', 2)
FROM Temporal
WHERE actorpelicula != '-';
-- tipo empleado
INSERT INTO TipoEmpleado (tipo)
values ('encargado');
INSERT INTO TipoEmpleado (tipo)
values ('normal');
-- empleado
INSERT INTO UsuarioEmpleado (usuario, contrasena)
SELECT DISTINCT usuarioempleado,
    contrasenaempleado
FROM Temporal
WHERE usuarioempleado != '-'
    AND contrasenaempleado != '-';
-- clasificacion
INSERT INTO Clasificacion (clasificacion)
SELECT DISTINCT clasificacion
FROM Temporal
WHERE Temporal.clasificacion != '-';
-- lenguaje
INSERT INTO Lenguaje (lenguaje)
SELECT DISTINCT lenguajepelicula
FROM Temporal
WHERE lenguajepelicula != '-';
-- categoria
INSERT INTO Categoria (categoria)
SELECT DISTINCT categoriapelicula
FROM temporal
WHERE categoriapelicula != '-';
-- ciudad 
INSERT INTO Ciudad (nombre, idpais)
SELECT DISTINCT ciudadcliente,
    (
        Select idpais
        FROM Pais
        WHERE nombre = Temporal.paiscliente
    )
FROM Temporal
WHERE ciudadcliente != '-'
    AND ciudadcliente not in (
        SELECT nombre
        FROM Ciudad
    );
INSERT INTO Ciudad (nombre, idpais)
SELECT DISTINCT ciudadempleado,
    (
        Select idpais
        FROM Pais
        WHERE nombre = Temporal.paisempleado
    )
FROM Temporal
WHERE ciudadempleado != '-'
    AND ciudadempleado not in (
        SELECT nombre
        FROM Ciudad
    );
INSERT INTO Ciudad (nombre, idpais)
SELECT DISTINCT ciudadtienda,
    (
        Select idpais
        FROM Pais
        WHERE nombre = Temporal.paistienda
    )
FROM Temporal
WHERE ciudadtienda != '-'
    AND ciudadtienda not in (
        SELECT nombre
        FROM Ciudad
    );
-- direccion
INSERT INTO Direccion (direccion, idciudad, codigopostal)
SELECT DISTINCT direccioncliente,
    (
        SELECT idciudad
        FROM Ciudad
            INNER JOIN Pais ON Ciudad.idpais = Pais.idpais
        WHERE Ciudad.nombre = Temporal.ciudadcliente
            AND Pais.nombre = Temporal.paiscliente
    ),
    CAST(codigopostalcliente AS INT)
FROM Temporal
WHERE direccioncliente != '-'
    AND direccioncliente not in (
        SELECT direccion
        FROM direccion
    );
INSERT INTO Direccion (direccion, idciudad, codigopostal)
SELECT DISTINCT direccionempleado,
    (
        SELECT idciudad
        FROM Ciudad
            INNER JOIN Pais ON Ciudad.idpais = Pais.idpais
        WHERE Ciudad.nombre = Temporal.ciudadempleado
            AND Pais.nombre = Temporal.paisempleado
    ),
    CAST(codigopostalempleado AS INT)
FROM Temporal
WHERE direccionempleado != '-'
    AND direccionempleado not in (
        SELECT direccion
        FROM direccion
    );
INSERT INTO Direccion (direccion, idciudad, codigopostal)
SELECT DISTINCT direcciontienda,
    (
        SELECT idciudad
        FROM Ciudad
            INNER JOIN Pais ON Ciudad.idpais = Pais.idpais
        WHERE Ciudad.nombre = Temporal.ciudadtienda
            AND Pais.nombre = Temporal.paistienda
    ),
    CAST(codigopostaltienda AS INT)
FROM Temporal
WHERE direcciontienda != '-'
    AND direcciontienda not in (
        SELECT direccion
        FROM direccion
    );
-- tienda
INSERT INTO Tienda(nombre, iddireccion)
SELECT DISTINCT nombretienda,
    (
        SELECT iddireccion
        FROM Direccion
        WHERE direccion = Temporal.direcciontienda
    )
FROM Temporal
WHERE nombretienda != '-'
    AND nombretienda not in (
        SELECT nombre
        FROM Tienda
    );
-- entrega
INSERT INTO Entrega(
        titulo,
        descripcion,
        lanzamiento,
        duracion,
        idclasificacion
    )
SELECT DISTINCT nombrepelicula,
    descripcionpelicula,
    CAST(lanzamiento AS INT),
    CAST(duracion AS INT),
    (
        SELECT idclasificacion
        FROM Clasificacion
        WHERE clasificacion = Temporal.clasificacion
    )
FROM Temporal
WHERE nombrepelicula != '-'
    AND nombrepelicula not in (
        SELECT titulo
        FROM Entrega
    );
-- cliente
INSERT INTO Cliente(
        nombre,
        apellido,
        email,
        iddireccion,
        fecharegistro,
        activo,
        idtiendafavorita
    )
SELECT DISTINCT SPLIT_PART(nombrecliente, ' ', 1),
    SPLIT_PART(nombrecliente, ' ', 2),
    correocliente,
    (
        SELECT iddireccion
        FROM Direccion
        WHERE direccion = Temporal.direccioncliente
    ),
    CAST(fechacreacion AS DATE),
    clienteactivo,
    (
        SELECT idtienda
        FROM Tienda
        WHERE nombre = Temporal.tiendapreferida
    )
FROM Temporal
WHERE nombrecliente != '-'
    AND SPLIT_PART(nombrecliente, ' ', 1) not in (
        SELECT nombre
        FROM Cliente
    );
-- empleado
INSERT INTO Empleado(
        nombre,
        apellido,
        iddireccion,
        email,
        activo,
        idtipo,
        idusuarioempleado
    )
SELECT DISTINCT SPLIT_PART(nombreempleado, ' ', 1),
    SPLIT_PART(nombreempleado, ' ', 2),
    (
        SELECT iddireccion
        FROM Direccion
        WHERE direccion = Temporal.direccionempleado
    ),
    correoempleado,
    empleadoactivo,
    (
        case
            when nombreempleado in (
                SELECT encargadotienda
                FROM Temporal
            ) then 1
            else 2
        end
    ),
    (
        SELECT idusuarioempleado
        FROM UsuarioEmpleado
        WHERE usuario = Temporal.usuarioempleado
    )
FROM Temporal
WHERE nombreempleado != '-'
    AND SPLIT_PART(nombreempleado, ' ', 1) not in (
        SELECT nombre
        FROM Empleado
    );
-- pelicula 
INSERT INTO Pelicula(
        diasrenta,
        costorenta,
        costodanorenta,
        idlenguaje,
        identrega
    )
SELECT DISTINCT CAST(diasrenta AS INT),
    CAST(costorenta AS FLOAT),
    CAST(costodanorenta AS FLOAT),
    (
        SELECT idlenguaje
        FROM Lenguaje
        WHERE lenguaje = Temporal.lenguajepelicula
    ),
    (
        SELECT identrega
        FROM Entrega
        WHERE titulo = Temporal.nombrepelicula
    )
FROM Temporal
WHERE nombrepelicula != '-';
-- renta
INSERT INTO Renta(
        fecharenta,
        fecharetorno,
        montopagar,
        fechapago,
        idcliente,
        idempleado,
        idtienda,
        idpelicula
    )
SELECT DISTINCT CAST(fecharenta AS DATE),
    CAST(fecharetorno AS DATE),
    CAST(montopagar AS FLOAT),
    CAST(fechapago AS DATE),
    (
        SELECT idcliente
        FROM Cliente
        WHERE CONCAT(nombre, ' ', apellido) = Temporal.nombrecliente
    ),
    (
        SELECT idempleado
        FROM Empleado
        WHERE CONCAT(nombre, ' ', apellido) = Temporal.nombreempleado
    ),
    (
        SELECT idtienda
        FROM Tienda
        WHERE nombre = Temporal.nombretienda
    ),
    (
        SELECT idpelicula
        FROM Pelicula
            INNER JOIN Entrega ON Pelicula.identrega = Entrega.identrega
        WHERE Entrega.titulo = nombrepelicula
    )
FROM Temporal
WHERE fecharenta != '-';
-- actor entrega
INSERT INTO ActorEntrega(idactor, identrega)
SELECT DISTINCT (
        SELECT idactor
        FROM Actor
        WHERE CONCAT(nombre, ' ', apellido) = Temporal.actorpelicula
    ),
    (
        SELECT identrega
        FROM Entrega
        WHERE titulo = Temporal.nombrepelicula
    )
FROM Temporal
WHERE actorpelicula != '-'
    AND nombrepelicula != '-';
-- categoria entrega
INSERT INTO CategoriaEntrega(idcategoria, identrega)
SELECT DISTINCT (
        SELECT idcategoria
        FROM Categoria
        WHERE categoria = Temporal.categoriapelicula
    ),
    (
        SELECT identrega
        FROM Entrega
        WHERE titulo = Temporal.nombrepelicula
    )
FROM Temporal
WHERE categoriapelicula != '-'
    AND nombrepelicula != '-';
-- inventario
INSERT INTO Inventario(identrega, idtienda)
SELECT DISTINCT (
        SELECT identrega
        FROM Entrega
        WHERE titulo = Temporal.nombrepelicula
    ),
    (
        SELECT idtienda
        FROM Tienda
        WHERE nombre = Temporal.nombretienda
    )
FROM Temporal
WHERE nombrepelicula != '-'
    AND nombretienda != '-';