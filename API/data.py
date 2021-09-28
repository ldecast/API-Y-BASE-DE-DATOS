import psycopg2
import psycopg2.extras

DBHOST = 'localhost'
DBNAME = 'blockbuster'
DBUSER = 'ldecast'
DBPASS = 'ldecast'

DELETETMP = """DELETE FROM temporal;"""
DELETEMODEL = """DROP TABLE ActorEntrega;
DROP TABLE Actor;
DROP TABLE CategoriaEntrega;
DROP TABLE Categoria;
DROP TABLE Renta;
DROP TABLE Inventario;
DROP TABLE Pelicula;
DROP TABLE Lenguaje;
DROP TABLE Entrega;
DROP TABLE Clasificacion;
DROP TABLE Cliente;
DROP TABLE Tienda;
DROP TABLE Empleado;
DROP TABLE UsuarioEmpleado;
DROP TABLE TipoEmpleado;
DROP TABLE Direccion;
DROP TABLE Ciudad;
DROP TABLE Pais;
DROP TABLE Temporal;
"""
MASSIVE = """
CREATE TABLE Temporal(
    nombrecliente VARCHAR(50),
    correocliente VARCHAR(60),
    clienteactivo VARCHAR(5),
    fechacreacion VARCHAR(30),
    tiendapreferida VARCHAR(40),
    direccioncliente VARCHAR(80),
    codigopostalcliente VARCHAR(10),
    ciudadcliente VARCHAR(40),
    paiscliente VARCHAR(40),
    fecharenta VARCHAR(30),
    fecharetorno VARCHAR(30),
    montopagar VARCHAR(10),
    fechapago VARCHAR(30),
    nombreempleado VARCHAR(50),
    correoempleado VARCHAR(60),
    empleadoactivo VARCHAR(5),
    tiendaempleado VARCHAR(40),
    usuarioempleado VARCHAR(50),
    contrasenaempleado VARCHAR(100),
    direccionempleado VARCHAR(80),
    codigopostalempleado VARCHAR(10),
    ciudadempleado VARCHAR(40),
    paisempleado VARCHAR(40),
    nombretienda VARCHAR(40),
    encargadotienda VARCHAR(40),
    direcciontienda VARCHAR(80),
    codigopostaltienda VARCHAR(10),
    ciudadtienda VARCHAR(40),
    paistienda VARCHAR(40),
    tiendapelicula VARCHAR(40),
    nombrepelicula VARCHAR(50),
    descripcionpelicula VARCHAR(250),
    lanzamiento VARCHAR(10),
    diasrenta VARCHAR(5),
    costorenta VARCHAR(10),
    duracion VARCHAR(10),
    costodanorenta VARCHAR(10),
    clasificacion VARCHAR(5),
    lenguajepelicula VARCHAR(10),
    categoriapelicula VARCHAR(20),
    actorpelicula VARCHAR(50)
);

-- creacion de tablas db
CREATE TABLE Pais(
    idpais INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL
);
CREATE TABLE Ciudad(
    idciudad INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    idpais INT NOT NULL,
    FOREIGN KEY (idpais) REFERENCES Pais(idpais)
);
CREATE TABLE Direccion(
    iddireccion INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    direccion VARCHAR(150) NOT NULL,
    idciudad INT,
    distrito VARCHAR(150),
    codigopostal INT,
    FOREIGN KEY (idciudad) REFERENCES Ciudad(idciudad)
);
CREATE TABLE TipoEmpleado(
    idtipo INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tipo VARCHAR(10)
);
CREATE TABLE UsuarioEmpleado(
    idusuarioempleado INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario VARCHAR(150) NOT NULL,
    contrasena VARCHAR(150) NOT NULL
);
CREATE TABLE Empleado(
    idempleado INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    apellido VARCHAR(150) NOT NULL,
    iddireccion INT NOT NULL,
    email VARCHAR(150) NOT NULL,
    activo VARCHAR(5) NOT NULL,
    idtipo INT NOT NULL,
    idusuarioempleado INT NOT NULL,
    FOREIGN KEY (iddireccion) REFERENCES Direccion(iddireccion),
    FOREIGN KEY (idtipo) REFERENCES TipoEmpleado(idtipo),
    FOREIGN KEY (idusuarioempleado) REFERENCES UsuarioEmpleado(idusuarioempleado)
);
CREATE TABLE Tienda(
    idtienda INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    iddireccion INT NOT NULL,
    FOREIGN KEY (iddireccion) REFERENCES Direccion(iddireccion)
);
CREATE TABLE Cliente(
    idcliente INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    apellido VARCHAR(150)NOT NULL,
    email VARCHAR(150),
    iddireccion INT NOT NULL,
    fecharegistro DATE,
    activo VARCHAR(5) NOT NULL,
    idtiendafavorita INT,
    FOREIGN KEY (iddireccion) REFERENCES Direccion(iddireccion),
    FOREIGN KEY (idtiendafavorita) REFERENCES Tienda(idtienda)
);
CREATE TABLE Clasificacion(
    idclasificacion INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    clasificacion VARCHAR(10) NOT NULL
);
CREATE TABLE Entrega(
    identrega INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion VARCHAR(150) NOT NULL,
    lanzamiento INT,
    duracion INT,
    idclasificacion INT NOT NULL,
    FOREIGN KEY (idclasificacion) REFERENCES Clasificacion(idclasificacion)
);
CREATE TABLE Lenguaje(
    idlenguaje INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    lenguaje VARCHAR(150) NOT NULL
);
CREATE TABLE Pelicula(
    idpelicula INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    diasrenta INT,
    costorenta FLOAT,
    costodanorenta FLOAT,
    idlenguaje INT NOT NULL,
    identrega INT NOT NULL,
    FOREIGN KEY (idlenguaje) REFERENCES Lenguaje(idlenguaje),
    FOREIGN KEY (identrega) REFERENCES Entrega(identrega)
);
CREATE TABLE Inventario(
    idinventario INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    identrega INT NOT NULL,
    idtienda INT NOT NULL,
    FOREIGN KEY (identrega) REFERENCES Entrega(identrega),
    FOREIGN KEY (idtienda) REFERENCES Tienda(idtienda)
);
CREATE TABLE Renta(
    idrenta INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecharenta DATE NOT NULL,
    fecharetorno DATE,
    montopagar FLOAT NOT NULL,
    fechapago DATE,
    idcliente INT,
    idempleado INT,
    idtienda INT,
    idpelicula INT,
    FOREIGN KEY (idcliente) REFERENCES Cliente(idcliente),
    FOREIGN KEY (idempleado) REFERENCES Empleado(idempleado),
    FOREIGN KEY (idtienda) REFERENCES Tienda(idtienda),
    FOREIGN KEY (idpelicula) REFERENCES Pelicula(idpelicula)
);
CREATE TABLE Categoria(
    idcategoria INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    categoria VARCHAR(150)
);
CREATE TABLE CategoriaEntrega(
    idcategoriaentrega INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    idcategoria INT,
    identrega INT,
    FOREIGN KEY (idcategoria) REFERENCES Categoria(idcategoria),
    FOREIGN KEY (identrega) REFERENCES Entrega(identrega)
);
CREATE TABLE Actor(
    idactor INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(150),
    apellido VARCHAR(150)
);
CREATE TABLE ActorEntrega(
    idactorentrega INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    idactor INT,
    identrega INT,
    FOREIGN KEY (idactor) REFERENCES Actor(idactor),
    FOREIGN KEY (identrega) REFERENCES Entrega(identrega)
);

COPY Temporal
FROM '/home/ldecast/Documentos/VI Semestre/Archivos/Práctica1/BlockbusterData.csv'
DELIMITER ';'
CSV HEADER;"""
MODEL = """

UPDATE Temporal SET codigopostalcliente = null WHERE codigopostalcliente = '-';
UPDATE Temporal SET codigopostalempleado = null WHERE codigopostalempleado = '-';
UPDATE Temporal SET codigopostaltienda = null WHERE codigopostaltienda = '-';
UPDATE Temporal SET lanzamiento = null WHERE lanzamiento = '-';
UPDATE Temporal SET duracion = null WHERE duracion = '-';
UPDATE Temporal SET fecharenta = null WHERE fecharenta = '-';
UPDATE Temporal SET fecharetorno = null WHERE fecharetorno = '-';
UPDATE Temporal SET montopagar = null WHERE montopagar = '-';
UPDATE Temporal SET fechapago = null WHERE fechapago = '-';

-- insertar a base de datos
-- pais
INSERT INTO Pais (nombre)
SELECT DISTINCT paiscliente FROM Temporal WHERE paiscliente != '-'
AND paiscliente not in (SELECT nombre FROM Pais);
INSERT INTO Pais (nombre)
SELECT DISTINCT paisempleado FROM Temporal WHERE paisempleado != '-'
AND paisempleado not in (SELECT nombre FROM Pais);
INSERT INTO Pais (nombre)
SELECT DISTINCT paistienda FROM Temporal WHERE paistienda != '-'
AND paistienda not in (SELECT nombre FROM Pais);
-- actor
INSERT INTO Actor (nombre, apellido)
SELECT DISTINCT SPLITPART(actorpelicula, ' ', 1), SPLITPART(actorpelicula, ' ', 2) FROM Temporal WHERE actorpelicula != '-';
-- tipo empleado
INSERT INTO TipoEmpleado (tipo) values ('encargado');
INSERT INTO TipoEmpleado (tipo) values ('normal');
-- usuario empleado
INSERT INTO UsuarioEmpleado (usuario, contrasena)
SELECT DISTINCT usuarioempleado , contrasenaempleado FROM Temporal WHERE usuarioempleado != '-' AND contrasenaempleado != '-';
-- clasificacion
INSERT INTO Clasificacion (clasificacion)
SELECT DISTINCT clasificacion FROM Temporal WHERE Temporal.clasificacion != '-';
-- lenguaje
INSERT INTO Lenguaje (lenguaje)
SELECT DISTINCT lenguajepelicula FROM Temporal WHERE lenguajepelicula != '-';
-- categoria
INSERT INTO Categoria (categoria)
SELECT DISTINCT categoriapelicula FROM temporal WHERE categoriapelicula != '-';
-- ciudad 
INSERT INTO Ciudad (nombre, idpais)
SELECT DISTINCT ciudadcliente,(Select idpais FROM Pais WHERE nombre = Temporal.paiscliente) FROM Temporal WHERE ciudadcliente != '-'
AND ciudadcliente not in (SELECT nombre FROM Ciudad);
INSERT INTO Ciudad (nombre, idpais)
SELECT DISTINCT ciudadempleado, (Select idpais FROM Pais WHERE nombre = Temporal.paisempleado) FROM Temporal WHERE ciudadempleado != '-'
AND ciudadempleado not in (SELECT nombre FROM Ciudad);
INSERT INTO Ciudad (nombre, idpais)
SELECT DISTINCT ciudadtienda, (Select idpais FROM Pais WHERE nombre = Temporal.paistienda) FROM Temporal WHERE ciudadtienda != '-'
AND ciudadtienda not in (SELECT nombre FROM Ciudad);
-- direccion
INSERT INTO Direccion (direccion, idciudad, codigopostal)
SELECT DISTINCT direccioncliente, (SELECT idciudad FROM Ciudad INNER JOIN Pais 
                                     ON Ciudad.idpais = Pais.idpais 
                                     WHERE Ciudad.nombre = Temporal.ciudadcliente 
                                     AND Pais.nombre = Temporal.paiscliente ), CAST(codigopostalcliente AS INT) FROM Temporal WHERE direccioncliente != '-'
AND direccioncliente not in (SELECT direccion FROM direccion);
INSERT INTO Direccion (direccion, idciudad, codigopostal)
SELECT DISTINCT direccionempleado, (SELECT idciudad FROM Ciudad INNER JOIN Pais 
                                     ON Ciudad.idpais = Pais.idpais 
                                     WHERE Ciudad.nombre = Temporal.ciudadempleado
                                     AND Pais.nombre = Temporal.paisempleado), CAST(codigopostalempleado AS INT) FROM Temporal WHERE direccionempleado != '-'
AND direccionempleado not in (SELECT direccion FROM direccion);
INSERT INTO Direccion (direccion, idciudad, codigopostal)
SELECT DISTINCT direcciontienda, (SELECT idciudad FROM Ciudad INNER JOIN Pais 
                                     ON Ciudad.idpais = Pais.idpais 
                                     WHERE Ciudad.nombre = Temporal.ciudadtienda 
                                     AND Pais.nombre = Temporal.paistienda ), CAST(codigopostaltienda AS INT) FROM Temporal WHERE direcciontienda != '-'
AND direcciontienda not in (SELECT direccion FROM direccion);
-- tienda
INSERT INTO Tienda(nombre, iddireccion)
SELECT DISTINCT nombretienda, (SELECT iddireccion FROM Direccion WHERE direccion = Temporal.direcciontienda) FROM Temporal WHERE nombretienda != '-'
AND nombretienda not in (SELECT nombre FROM Tienda);
-- entrega
INSERT INTO Entrega(titulo, descripcion, lanzamiento, duracion, idclasificacion)
SELECT DISTINCT nombrepelicula, descripcionpelicula, CAST(lanzamiento AS INT), CAST(duracion AS INT), (SELECT idclasificacion FROM Clasificacion WHERE clasificacion = Temporal.clasificacion)
 FROM Temporal WHERE nombrepelicula != '-'
AND nombrepelicula not in (SELECT titulo FROM Entrega);
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
SELECT DISTINCT 
    SPLITPART(nombrecliente, ' ',1),
    SPLITPART(nombrecliente, ' ',2),
    correocliente, 
    (SELECT iddireccion FROM Direccion WHERE direccion = Temporal.direccioncliente),
    CAST(fechacreacion AS DATE),
    clienteactivo, 
    (SELECT idtienda FROM Tienda WHERE nombre = Temporal.tiendapreferida)
FROM Temporal WHERE nombrecliente != '-'
AND SPLITPART(nombrecliente, ' ',1) not in (SELECT nombre FROM Cliente);
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
SELECT DISTINCT
    SPLITPART(nombreempleado, ' ',1),
    SPLITPART(nombreempleado, ' ',2),
    (SELECT iddireccion FROM Direccion WHERE direccion = Temporal.direccionempleado),
    correoempleado,
    empleadoactivo,
    (case when nombreempleado in (SELECT encargadotienda FROM Temporal) then 1 else 2 end),
    (SELECT idusuarioempleado FROM UsuarioEmpleado WHERE usuario = Temporal.usuarioempleado)
FROM Temporal WHERE nombreempleado != '-'
AND SPLITPART(nombreempleado, ' ',1) not in (SELECT nombre FROM Empleado);
-- pelicula 
INSERT INTO Pelicula(
    diasrenta,
    costorenta,
    costodanorenta,
    idlenguaje,
    identrega
)SELECT DISTINCT 
    CAST(diasrenta AS INT),
    CAST(costorenta AS FLOAT),
    CAST(costodanorenta AS FLOAT),
    (SELECT idlenguaje FROM Lenguaje WHERE lenguaje = Temporal.lenguajepelicula),
    (SELECT identrega FROM Entrega WHERE titulo = Temporal.nombrepelicula)
FROM Temporal WHERE nombrepelicula != '-';
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
)SELECT DISTINCT
    CAST(fecharenta AS DATE),
    CAST(fecharetorno AS DATE),
    CAST(montopagar AS FLOAT),
    CAST(fechapago AS DATE),
    (SELECT idcliente FROM Cliente WHERE CONCAT(nombre,' ',apellido) = Temporal.nombrecliente),
    (SELECT idempleado FROM Empleado WHERE CONCAT(nombre,' ',apellido) = Temporal.nombreempleado),
    (SELECT idtienda FROM Tienda WHERE nombre = Temporal.nombretienda),
    (SELECT idpelicula FROM Pelicula INNER JOIN Entrega ON Pelicula.identrega = Entrega.identrega WHERE Entrega.titulo = nombrepelicula)
FROM Temporal WHERE fecharenta != '-';
-- actor entrega
INSERT INTO ActorEntrega(
    idactor,
    identrega
)SELECT DISTINCT
    (SELECT idactor FROM Actor WHERE CONCAT(nombre,' ',apellido) = Temporal.actorpelicula),
    (SELECT identrega FROM Entrega WHERE titulo = Temporal.nombrepelicula)
FROM Temporal WHERE actorpelicula != '-' AND nombrepelicula != '-';
-- categoria entrega
INSERT INTO CategoriaEntrega(
    idcategoria,
    identrega
)SELECT DISTINCT
    (SELECT idcategoria FROM Categoria WHERE categoria = Temporal.categoriapelicula),
    (SELECT identrega FROM Entrega WHERE titulo = Temporal.nombrepelicula)
FROM Temporal WHERE categoriapelicula != '-' AND nombrepelicula != '-';
-- inventario (pelicula tienda)
INSERT INTO Inventario(
    identrega,
    idtienda
)SELECT DISTINCT
    (SELECT identrega FROM Entrega WHERE titulo = Temporal.nombrepelicula),
    (SELECT idtienda FROM Tienda WHERE nombre = Temporal.nombretienda)
FROM Temporal WHERE nombrepelicula != '-' AND nombretienda != '-';"""


def sel(query, conection):
    cursor = conection.cursor(cursorfactory=psycopg2.extras.DictCursor)
    cursor.execute(query)
    salida = 0
    try:
        salida = cursor.fetchall()
    except:
        pass
    cursor.close()
    return salida


def ins(query, conection):
    cursor = conection.cursor(cursorfactory=psycopg2.extras.DictCursor)
    cursor.execute(query)
    cursor.close()


async def connection(consulta):
    conection = psycopg2.connect(dbname=DBNAME,
                                 user=DBUSER,
                                 password=DBPASS,
                                 host=DBHOST)
    SELECT = sel(consulta, conection)
    conection.commit()
    conection.close()
    return SELECT