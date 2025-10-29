/* =========================================================
   Proyecto: Gestor de Mantenimiento (SGM)
   Archivo : script_ddl_proyecto.sql
   Descripción: Creación de tablas y constraints
   ========================================================= */

USE ProyectoSGM;
GO

CREATE TABLE Marca (
  id_marca INT IDENTITY(1,1) PRIMARY KEY,
  nombre   VARCHAR(100) NOT NULL,
  CONSTRAINT UQ_Marca_nombre UNIQUE (nombre)
);

CREATE TABLE Instalacion (
  id_instalacion INT IDENTITY(1,1) PRIMARY KEY,
  nombre         VARCHAR(150) NOT NULL,
  direccion      VARCHAR(200) NOT NULL,
  telefono       VARCHAR(30)  NULL,
  CONSTRAINT UQ_Instalacion_nombre UNIQUE (nombre)
);

-- Teléfonos adicionales (0..N) por instalación
CREATE TABLE InstalacionTelefono (
  id_telefono     INT IDENTITY(1,1) PRIMARY KEY,
  id_instalacion  INT          NOT NULL,
  telefono        VARCHAR(30)  NOT NULL,
  CONSTRAINT FK_InstTel_Inst FOREIGN KEY (id_instalacion)
    REFERENCES Instalacion(id_instalacion)
    ON DELETE CASCADE
);

CREATE TABLE Grupo (
  id_grupo          INT IDENTITY(1,1) PRIMARY KEY,
  cant_integrantes  INT NOT NULL,
  CONSTRAINT CHK_Grupo_cantIntegrantes CHECK (cant_integrantes > 0)
);

CREATE TABLE Tecnico (
  documento       VARCHAR(20)  PRIMARY KEY,
  nombre          VARCHAR(80)  NOT NULL,
  apellido        VARCHAR(80)  NOT NULL,
  fecha_nacimiento DATE        NULL,
  telefono        VARCHAR(30)  NULL,
  id_grupo        INT          NOT NULL,
  CONSTRAINT FK_Tecnico_Grupo FOREIGN KEY (id_grupo)
    REFERENCES Grupo(id_grupo)
);

CREATE TABLE Maquina (
  id_maquina      INT IDENTITY(1,1) PRIMARY KEY,
  matricula       VARCHAR(50)   NOT NULL,
  modelo          VARCHAR(100)  NOT NULL,
  id_marca        INT           NOT NULL,
  id_instalacion  INT           NOT NULL,
  CONSTRAINT UQ_Maquina_matricula UNIQUE (matricula),
  CONSTRAINT FK_Maquina_Marca        FOREIGN KEY (id_marca)       REFERENCES Marca(id_marca),
  CONSTRAINT FK_Maquina_Instalacion  FOREIGN KEY (id_instalacion) REFERENCES Instalacion(id_instalacion)
);

CREATE TABLE Repuesto (
  id_repuesto  INT IDENTITY(1,1) PRIMARY KEY,
  descripcion  VARCHAR(150) NOT NULL,
  id_maquina   INT          NOT NULL,
  CONSTRAINT FK_Repuesto_Maquina FOREIGN KEY (id_maquina)
    REFERENCES Maquina(id_maquina)
);

CREATE TABLE Diagnostico (
  id_diagnostico VARCHAR(10)  PRIMARY KEY,
  descripcion    VARCHAR(200) NOT NULL
);

CREATE TABLE Revision (
  id_revision            INT IDENTITY(1,1) PRIMARY KEY,
  fecha_inicio_revision  DATE NOT NULL,
  fecha_fin_revision     DATE NULL,
  id_maquina             INT  NOT NULL,
  id_grupo               INT  NOT NULL,
  id_diagnostico         VARCHAR(10) NOT NULL,
  CONSTRAINT CHK_Revision_Fechas CHECK (fecha_fin_revision IS NULL OR fecha_fin_revision >= fecha_inicio_revision),
  CONSTRAINT FK_Revision_Maquina     FOREIGN KEY (id_maquina)     REFERENCES Maquina(id_maquina),
  CONSTRAINT FK_Revision_Grupo       FOREIGN KEY (id_grupo)       REFERENCES Grupo(id_grupo),
  CONSTRAINT FK_Revision_Diagnostico FOREIGN KEY (id_diagnostico) REFERENCES Diagnostico(id_diagnostico)
);

CREATE TABLE Reparacion (
  id_reparacion              INT IDENTITY(1,1) PRIMARY KEY,
  fecha_inicio_reparacion    DATE NOT NULL,
  fecha_fin_reparacion       DATE NULL,
  id_revision                INT  NOT NULL,
  id_grupo                   INT  NOT NULL,
  CONSTRAINT CHK_Reparacion_Fechas CHECK (fecha_fin_reparacion IS NULL OR fecha_fin_reparacion >= fecha_inicio_reparacion),
  CONSTRAINT FK_Reparacion_Revision FOREIGN KEY (id_revision) REFERENCES Revision(id_revision),
  CONSTRAINT FK_Reparacion_Grupo    FOREIGN KEY (id_grupo)    REFERENCES Grupo(id_grupo)
);


CREATE TABLE Reparacion_Repuesto (
  id_reparacion INT NOT NULL,
  id_repuesto   INT NOT NULL,
  CONSTRAINT PK_Reparacion_Repuesto PRIMARY KEY (id_reparacion, id_repuesto),
  CONSTRAINT FK_RR_Reparacion FOREIGN KEY (id_reparacion) REFERENCES Reparacion(id_reparacion),
  CONSTRAINT FK_RR_Repuesto   FOREIGN KEY (id_repuesto)   REFERENCES Repuesto(id_repuesto)
);

/* ---------- Índices ---------- */
CREATE INDEX IX_Maquina_Marca          ON Maquina(id_marca);
CREATE INDEX IX_Maquina_Instalacion    ON Maquina(id_instalacion);
CREATE INDEX IX_Repuesto_Maquina       ON Repuesto(id_maquina);
CREATE INDEX IX_Revision_Maq_Fecha     ON Revision(id_maquina, fecha_inicio_revision);
CREATE INDEX IX_Reparacion_Revision    ON Reparacion(id_revision);
