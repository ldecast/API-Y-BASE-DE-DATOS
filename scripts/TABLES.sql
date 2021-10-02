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
    Traduccionpelicula VARCHAR(10),
    categoriapelicula VARCHAR(20),
    actorpelicula VARCHAR(50)
);
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
CREATE TABLE UserEmpleado(
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
    FOREIGN KEY (idusuarioempleado) REFERENCES UserEmpleado(idusuarioempleado)
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
    apellido VARCHAR(150) NOT NULL,
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
CREATE TABLE Traduccion(
    idTraduccion INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Traduccion VARCHAR(150) NOT NULL
);
CREATE TABLE Pelicula(
    idpelicula INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    diasrenta INT,
    costorenta FLOAT,
    costodanorenta FLOAT,
    idTraduccion INT NOT NULL,
    identrega INT NOT NULL,
    FOREIGN KEY (idTraduccion) REFERENCES Traduccion(idTraduccion),
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
CREATE TABLE CEntrega(
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
CREATE TABLE AEntrega(
    idactorentrega INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    idactor INT,
    identrega INT,
    FOREIGN KEY (idactor) REFERENCES Actor(idactor),
    FOREIGN KEY (identrega) REFERENCES Entrega(identrega)
);