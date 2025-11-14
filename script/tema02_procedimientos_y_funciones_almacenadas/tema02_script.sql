USE ProyectoSGM;
GO

 
--Realizar al menos tres procedimientos almacenados que permitan: Insertar, Modificar y borrar registros de alguna de las tablas del proyecto.

--Procedimiento para insertar  un tecnico
CREATE PROCEDURE sp_InsertarTecnico
    @documento INT,
    @nombre VARCHAR(50),
    @apellido VARCHAR(50),
    @fecha_nacimiento DATE,
    @telefono VARCHAR(15),
    @id_grupo INT
AS
BEGIN
    SET NOCOUNT ON; -- Evitar un mensaje con las filas afectadas para mejorar el rendimiento

    INSERT INTO Tecnico (documento, nombre, apellido, fecha_nacimiento, telefono, id_grupo)
    VALUES (@documento, @nombre, @apellido, @fecha_nacimiento, @telefono, @id_grupo);
END;
GO

--Procedimiento para modificar un tecnico
CREATE PROCEDURE sp_ModificarTecnico
    @documento INT,
    @nombre VARCHAR(50),
    @apellido VARCHAR(50),
    @fecha_nacimiento DATE,
    @telefono VARCHAR(15),
    @id_grupo INT
AS
BEGIN
    SET NOCOUNT ON; -- Evitar un mensaje con las filas afectadas para mejorar el rendimiento

    UPDATE Tecnico
    SET nombre = @nombre,
        apellido = @apellido,
        fecha_nacimiento = @fecha_nacimiento,
        telefono = @telefono,
        id_grupo = @id_grupo
    WHERE documento = @documento;
END;
GO

--Procedimiento para borrar un tecnico
CREATE PROCEDURE sp_BorrarTecnico
    @documento INT
AS
BEGIN
    SET NOCOUNT ON; -- Evitar un mensaje con las filas afectadas para mejorar el rendimiento

    DELETE FROM Tecnico
    WHERE documento = @documento;
END;
GO



Insertar un lote de datos en las tablas mencionadas (guardar el script) con sentencias insert y otro lote invocando a los procedimientos creados.




Realizar  update y delete sobre  algunos de los registros insertados  en esas tablas invocando a los procedimientos. 

Desarrollar al menos tres funciones almacenadas. Por ej: calcular la edad, 

Comparar la eficiencia de las operaciones directas versus el uso de procedimientos y funciones













--(1) Tipo de tabla para pasar lista de repuestos al SP
 
IF TYPE_ID('dbo.tvp_RepuestoId') IS NULL
    CREATE TYPE dbo.tvp_RepuestoId AS TABLE
    (
        id_repuesto INT NOT NULL
    );
GO

--(2) PROCEDIMIENTOS ALMACENADOS


-- 2.1 Insert: Registrar una revisión y devolver su ID
IF OBJECT_ID('dbo.RegistrarRevision','P') IS NOT NULL DROP PROCEDURE dbo.RegistrarRevision;
GO
CREATE PROCEDURE dbo.RegistrarRevision
(
    @id_maquina     INT,
    @id_grupo       INT,
    @id_diagnostico VARCHAR(10),
    @fecha_inicio   DATE,
    @fecha_fin      DATE = NULL,
    @id_revision_out INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Revision (fecha_inicio_revision, fecha_fin_revision, id_maquina, id_grupo, id_diagnostico)
    VALUES (@fecha_inicio, @fecha_fin, @id_maquina, @id_grupo, @id_diagnostico);

    SET @id_revision_out = SCOPE_IDENTITY();
END;
GO

-- 2.2 Insert en varias tablas: Reparación + (N..N) Repuestos
IF OBJECT_ID('dbo.RegistrarReparacionConRepuestos','P') IS NOT NULL DROP PROCEDURE dbo.RegistrarReparacionConRepuestos;
GO
CREATE PROCEDURE dbo.RegistrarReparacionConRepuestos
(
    @id_revision    INT,
    @id_grupo       INT,
    @fecha_inicio   DATE,
    @fecha_fin      DATE = NULL,
    @Repuestos      dbo.tvp_RepuestoId READONLY, 
    @id_reparacion_out INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert de la reparación
    INSERT INTO Reparacion (fecha_inicio_reparacion, fecha_fin_reparacion, id_revision, id_grupo)
    VALUES (@fecha_inicio, @fecha_fin, @id_revision, @id_grupo);

    SET @id_reparacion_out = SCOPE_IDENTITY();

    -- Asociaciones N..N con repuestos
    INSERT INTO Reparacion_Repuesto (id_reparacion, id_repuesto)
    SELECT @id_reparacion_out, r.id_repuesto
    FROM @Repuestos AS r;
END;
GO

-- 2.3 Update: cerrar una reparación (asignar fecha de fin)
IF OBJECT_ID('dbo.ActualizarFinReparacion','P') IS NOT NULL DROP PROCEDURE dbo.ActualizarFinReparacion;
GO
CREATE PROCEDURE dbo.ActualizarFinReparacion
(
    @id_reparacion INT,
    @fecha_fin     DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Reparacion
       SET fecha_fin_reparacion = @fecha_fin
     WHERE id_reparacion = @id_reparacion;
END;
GO

-- 2.4 Delete: eliminar reparación + sus repuestos asociados
IF OBJECT_ID('dbo.EliminarReparacionCompleta','P') IS NOT NULL DROP PROCEDURE dbo.EliminarReparacionCompleta;
GO
CREATE PROCEDURE dbo.EliminarReparacionCompleta
(
    @id_reparacion INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM Reparacion_Repuesto WHERE id_reparacion = @id_reparacion;
    DELETE FROM Reparacion         WHERE id_reparacion = @id_reparacion;
END;
GO



--(3) FUNCIONES ALMACENADAS
  

-- 3.1 Escalar: cantidad de revisiones por máquina
IF OBJECT_ID('dbo.fn_CantidadRevisionesPorMaquina','FN') IS NOT NULL DROP FUNCTION dbo.fn_CantidadRevisionesPorMaquina;
GO
CREATE FUNCTION dbo.fn_CantidadRevisionesPorMaquina (@id_maquina INT)
RETURNS INT
AS
BEGIN
    DECLARE @cant INT;

    SELECT @cant = COUNT(*) 
    FROM Revision
    WHERE id_maquina = @id_maquina;

    RETURN ISNULL(@cant, 0);
END;
GO

-- 3.2 Escalar: reparaciones abiertas por grupo
IF OBJECT_ID('dbo.fn_ReparacionesAbiertasPorGrupo','FN') IS NOT NULL DROP FUNCTION dbo.fn_ReparacionesAbiertasPorGrupo;
GO
CREATE FUNCTION dbo.fn_ReparacionesAbiertasPorGrupo (@id_grupo INT)
RETURNS INT
AS
BEGIN
    DECLARE @cant INT;

    SELECT @cant = COUNT(*)
    FROM Reparacion
    WHERE id_grupo = @id_grupo
      AND fecha_fin_reparacion IS NULL;

    RETURN ISNULL(@cant, 0);
END;
GO

-- 3.3 Inline TVF: lista de repuestos por reparación
IF OBJECT_ID('dbo.fn_RepuestosDeReparacion','IF') IS NOT NULL DROP FUNCTION dbo.fn_RepuestosDeReparacion;
GO
CREATE FUNCTION dbo.fn_RepuestosDeReparacion (@id_reparacion INT)
RETURNS TABLE
AS
RETURN
(
    SELECT rr.id_repuesto, rep.descripcion
    FROM Reparacion_Repuesto AS rr
    INNER JOIN Repuesto AS rep
        ON rep.id_repuesto = rr.id_repuesto
    WHERE rr.id_reparacion = @id_reparacion
);
GO



-- (4) PRUEBAS 

-- A) Insertar una revisión y capturar su ID (OUTPUT)
DECLARE @id_rev INT;
EXEC dbo.RegistrarRevision
     @id_maquina     = 1,
     @id_grupo       = 1,
     @id_diagnostico = 'D001',
     @fecha_inicio   = '2025-10-25',
     @fecha_fin      = NULL,
     @id_revision_out = @id_rev OUTPUT;

PRINT 'Nueva revisión ID: ' + CAST(@id_rev AS VARCHAR(10));

-- B) Insertar una reparación con repuestos (TVP)
DECLARE @reps dbo.tvp_RepuestoId;
INSERT INTO @reps (id_repuesto) VALUES (2), (5); 

DECLARE @id_rep INT;
EXEC dbo.RegistrarReparacionConRepuestos
     @id_revision       = @id_rev,
     @id_grupo          = 1,
     @fecha_inicio      = '2025-10-26',
     @fecha_fin         = NULL,
     @Repuestos         = @reps,
     @id_reparacion_out = @id_rep OUTPUT;

PRINT 'Nueva reparación ID: ' + CAST(@id_rep AS VARCHAR(10));

-- C) Actualizar fin de reparación
EXEC dbo.ActualizarFinReparacion @id_reparacion = @id_rep, @fecha_fin = '2025-10-27';

-- D) Consultas usando funciones
SELECT dbo.fn_CantidadRevisionesPorMaquina(1)      AS Revisiones_Maq1;
SELECT dbo.fn_ReparacionesAbiertasPorGrupo(1)      AS ReparacionesAbiertas_Grupo1;
SELECT * FROM dbo.fn_RepuestosDeReparacion(@id_rep) AS RepuestosDeReparacion;

-- E) Eliminar reparación completa (limpia tablas N..N)
EXEC dbo.EliminarReparacionCompleta @id_reparacion = @id_rep;

-- Verificacion
SELECT TOP 10 * FROM Revision ORDER BY id_revision DESC;
SELECT TOP 10 * FROM Reparacion ORDER BY id_reparacion DESC;
SELECT TOP 10 * FROM Reparacion_Repuesto ORDER BY id_reparacion DESC, id_repuesto ASC;

