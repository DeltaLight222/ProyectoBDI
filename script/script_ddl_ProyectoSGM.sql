CREATE TABLE Marca
(
  id_marca INT IDENTITY(1,1) NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  CONSTRAINT PK_Marca PRIMARY KEY (id_marca)
);

CREATE TABLE Modelo (
    id_modelo INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Modelo PRIMARY KEY (id_modelo)
);


CREATE TABLE Establecimiento
(
  id_establecimiento INT IDENTITY(1,1) NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  direccion VARCHAR(150) NOT NULL,
  CONSTRAINT PK_Establecimiento PRIMARY KEY (id_establecimiento),
);

CREATE TABLE Maquina
(
  id_maquina INT IDENTITY(1,1) NOT NULL,
  matricula CHAR(10) NOT NULL,
  id_modelo INT NOT NULL, 
  id_marca INT NOT NULL,
  id_establecimiento INT NOT NULL,
  
  CONSTRAINT PK_Maquina PRIMARY KEY (id_maquina),
  CONSTRAINT FK_Maquina_Marca FOREIGN KEY (id_marca) REFERENCES Marca(id_marca),
  CONSTRAINT FK_Maquina_Modelo FOREIGN KEY (id_modelo) REFERENCES Modelo(id_modelo),
  CONSTRAINT FK_Maquina_Establecimiento FOREIGN KEY (id_establecimiento) REFERENCES Establecimiento(id_establecimiento)
);

CREATE TABLE EstablecimientoTelefono
(
  telefono VARCHAR(15) NOT NULL,
  id_establecimiento INT NOT NULL,
  CONSTRAINT PK_EstablecimientoTelefono PRIMARY KEY (id_establecimiento, telefono),
  CONSTRAINT FK_EstablecimientoTelefonoo_Establecimiento 
      FOREIGN KEY (id_establecimiento) 
      REFERENCES Establecimiento(id_establecimiento)
);


CREATE TABLE Repuesto
(
  id_repuesto INT IDENTITY(1,1) NOT NULL,
  descripcion VARCHAR(150) NOT NULL,
  CONSTRAINT PK_Repuesto PRIMARY KEY (id_repuesto)
);

CREATE TABLE Maquina_Repuesto
(
  id_maquina INT NOT NULL,
  id_repuesto INT NOT NULL,

  CONSTRAINT PK_Maquina_Repuesto PRIMARY KEY (id_maquina, id_repuesto),

  CONSTRAINT FK_MaquinaRepuesto_Maquina 
      FOREIGN KEY (id_maquina) REFERENCES Maquina(id_maquina),

  CONSTRAINT FK_MaquinaRepuesto_Repuesto 
      FOREIGN KEY (id_repuesto) REFERENCES Repuesto(id_repuesto)
);


CREATE TABLE Diagnostico
(
  id_diagnostico INT IDENTITY(1,1) NOT NULL,
  descripcion VARCHAR(200) NOT NULL,
  CONSTRAINT PK_Diagnostico PRIMARY KEY (id_diagnostico)
);

CREATE TABLE Grupo
(
  id_grupo INT IDENTITY(1,1) NOT NULL,
  cant_integrantes INT NOT NULL,
  CONSTRAINT PK_Grupo PRIMARY KEY (id_grupo)
);

CREATE TABLE Revision
(
  id_revision INT IDENTITY(1,1) NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE,
  id_diagnostico INT NOT NULL,
  id_grupo INT NOT NULL,
  id_maquina INT NOT NULL,
  
  CONSTRAINT PK_Revision PRIMARY KEY (id_revision),
  CONSTRAINT FK_Revision_Diagnostico FOREIGN KEY (id_diagnostico) REFERENCES Diagnostico(id_diagnostico),
  CONSTRAINT FK_Revision_Grupo FOREIGN KEY (id_grupo) REFERENCES Grupo(id_grupo),
  CONSTRAINT FK_Revision_Maquina FOREIGN KEY (id_maquina) REFERENCES Maquina(id_maquina)
);

CREATE TABLE Reparacion
(
  id_reparacion INT IDENTITY(1,1) NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE,
  id_revision INT NOT NULL,
  id_grupo INT NOT NULL,
  CONSTRAINT PK_Reparacion PRIMARY KEY (id_reparacion),
  CONSTRAINT FK_Reparacion_Revision FOREIGN KEY (id_revision) REFERENCES Revision(id_revision),
  CONSTRAINT FK_Reparacion_Grupo FOREIGN KEY (id_grupo) REFERENCES Grupo(id_grupo)
);

CREATE TABLE Tecnico
(
  documento INT NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  fecha_nacimiento DATE NOT NULL,
  telefono VARCHAR(15),
  id_grupo INT NOT NULL,
  CONSTRAINT PK_Tecnico PRIMARY KEY (documento),
  CONSTRAINT FK_Tecnico_Grupo FOREIGN KEY (id_grupo) REFERENCES Grupo(id_grupo)
);

CREATE TABLE Reparacion_Repuesto
(
  id_repuesto INT NOT NULL,
  id_reparacion INT NOT NULL,

  CONSTRAINT PK_Reparacion_Repuesto PRIMARY KEY (id_reparacion, id_repuesto),

  CONSTRAINT FK_ReparacionRepuesto_Repuesto 
      FOREIGN KEY (id_repuesto) REFERENCES Repuesto(id_repuesto),

  CONSTRAINT FK_ReparacionRepuesto_Reparacion 
      FOREIGN KEY (id_reparacion) REFERENCES Reparacion(id_reparacion)
);
