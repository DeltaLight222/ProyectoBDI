USE ProyectoSGM;
GO

 
--Realizar al menos tres procedimientos almacenados que permitan: Insertar, Modificar y borrar registros de alguna de las tablas del proyecto.


--Procedimiento para agregar una reparacion con repuesto (el id_repuesto se pasa por parametro y actualizar la tabla Reparacion_Repuesto)

IF OBJECT_ID('AgregarReparacionConRepuesto', 'P') IS NOT NULL
    DROP PROCEDURE AgregarReparacionConRepuesto;
GO

CREATE PROCEDURE AgregarReparacionConRepuesto
    @fecha_inicio DATE,
    @fecha_fin DATE = NULL,
    @id_revision INT,
    @id_grupo INT,
    @id_repuesto INT
AS
BEGIN

    DECLARE @NuevoIdReparacion INT;

    INSERT INTO Reparacion (
        fecha_inicio,
        fecha_fin,
        id_revision,
        id_grupo
    )
    VALUES (
        @fecha_inicio,
        @fecha_fin,
        @id_revision,
        @id_grupo
    );

    SET @NuevoIdReparacion = SCOPE_IDENTITY();

    INSERT INTO Reparacion_Repuesto (
        id_repuesto,
        id_reparacion
    )
    VALUES (
        @id_repuesto,
        @NuevoIdReparacion
    );
END
GO


-- Procedimiento para actualizar la fecha de fin de una reparacion
CREATE PROCEDURE setFechaFinReparacion
    @id_reparacion INT,
    @fecha_fin DATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Reparacion
    SET fecha_fin = @fecha_fin
    WHERE id_reparacion = @id_reparacion;
END
GO

--Procedimiento para eliminar una reparacion junto con sus repuestos asociados
CREATE PROCEDURE EliminarReparacionConRepuesto
    @id_reparacion INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Primero se elimina la asiacion de repuestos a la reparación
    DELETE FROM Reparacion_Repuesto
    WHERE id_reparacion = @id_reparacion;

    -- Luego se la reparación
    DELETE FROM Reparacion
    WHERE id_reparacion = @id_reparacion;
END
GO


--------------------------------------------------------------------------------------
-- INSERTANDO DATOS DE PRUEBA EN LA TABLA REPARACION Y REPARACION_REPUESTO DE FORMA MANUAL
--------------------------------------------------------------------------------------

PRINT '--- INICIO: Inserción Manual---';
DECLARE @NuevoIdReparacion_Manual INT;

BEGIN TRANSACTION; 

INSERT INTO Reparacion (fecha_inicio, id_revision, id_grupo) VALUES ('2025-11-14', 1, 1);
SET @NuevoIdReparacion_Manual = SCOPE_IDENTITY();
INSERT INTO Reparacion_Repuesto (id_repuesto, id_reparacion) VALUES (1, @NuevoIdReparacion_Manual);

INSERT INTO Reparacion (fecha_inicio, id_revision, id_grupo) VALUES ('2025-11-15', 2, 2);
SET @NuevoIdReparacion_Manual = SCOPE_IDENTITY();
INSERT INTO Reparacion_Repuesto (id_repuesto, id_reparacion) VALUES (2, @NuevoIdReparacion_Manual);

INSERT INTO Reparacion (fecha_inicio, id_revision, id_grupo) VALUES ('2025-11-16', 3, 3);
SET @NuevoIdReparacion_Manual = SCOPE_IDENTITY();
INSERT INTO Reparacion_Repuesto (id_repuesto, id_reparacion) VALUES (3, @NuevoIdReparacion_Manual);

INSERT INTO Reparacion (fecha_inicio, id_revision, id_grupo) VALUES ('2025-11-17', 4, 4);
SET @NuevoIdReparacion_Manual = SCOPE_IDENTITY();
INSERT INTO Reparacion_Repuesto (id_repuesto, id_reparacion) VALUES (4, @NuevoIdReparacion_Manual);

INSERT INTO Reparacion (fecha_inicio, id_revision, id_grupo) VALUES ('2025-11-18', 5, 5);
SET @NuevoIdReparacion_Manual = SCOPE_IDENTITY();
INSERT INTO Reparacion_Repuesto (id_repuesto, id_reparacion) VALUES (5, @NuevoIdReparacion_Manual);

INSERT INTO Reparacion (fecha_inicio, id_revision, id_grupo) VALUES ('2025-11-19', 1, 2);
SET @NuevoIdReparacion_Manual = SCOPE_IDENTITY();
INSERT INTO Reparacion_Repuesto (id_repuesto, id_reparacion) VALUES (1, @NuevoIdReparacion_Manual);

INSERT INTO Reparacion (fecha_inicio, id_revision, id_grupo) VALUES ('2025-11-20', 2, 3);
SET @NuevoIdReparacion_Manual = SCOPE_IDENTITY();
INSERT INTO Reparacion_Repuesto (id_repuesto, id_reparacion) VALUES (2, @NuevoIdReparacion_Manual);

INSERT INTO Reparacion (fecha_inicio, id_revision, id_grupo) VALUES ('2025-11-21', 3, 4);
SET @NuevoIdReparacion_Manual = SCOPE_IDENTITY();
INSERT INTO Reparacion_Repuesto (id_repuesto, id_reparacion) VALUES (3, @NuevoIdReparacion_Manual);

INSERT INTO Reparacion (fecha_inicio, id_revision, id_grupo) VALUES ('2025-11-22', 4, 5);
SET @NuevoIdReparacion_Manual = SCOPE_IDENTITY();
INSERT INTO Reparacion_Repuesto (id_repuesto, id_reparacion) VALUES (4, @NuevoIdReparacion_Manual);

INSERT INTO Reparacion (fecha_inicio, id_revision, id_grupo) VALUES ('2025-11-23', 5, 1);
SET @NuevoIdReparacion_Manual = SCOPE_IDENTITY();
INSERT INTO Reparacion_Repuesto (id_repuesto, id_reparacion) VALUES (5, @NuevoIdReparacion_Manual);

COMMIT TRANSACTION;
PRINT '--- FIN: Inserción Manual ---';


--------------------------------------------------------------------------------------
-- INSERTANDO DATOS DE PRUEBA EN LA TABLA REPARACION Y REPARACION_REPUESTO LLMANDO A PROCEDURE AgregarReparacionConRepuesto
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------

PRINT '--- INICIO: Inserción con procedimiento almacenado ---';

EXEC AgregarReparacionConRepuesto '2025-12-01', NULL, 1, 1, 5;

EXEC AgregarReparacionConRepuesto '2025-12-02', NULL, 2, 2, 4;

EXEC AgregarReparacionConRepuesto '2025-12-03', NULL, 3, 3, 3;

EXEC AgregarReparacionConRepuesto '2025-12-04', NULL, 4, 4, 2;

EXEC AgregarReparacionConRepuesto '2025-12-05', NULL, 5, 5, 1;

EXEC AgregarReparacionConRepuesto '2025-12-06', NULL, 1, 2, 5;

EXEC AgregarReparacionConRepuesto '2025-12-07', NULL, 2, 3, 4;

EXEC AgregarReparacionConRepuesto '2025-12-08', NULL, 3, 4, 3;

EXEC AgregarReparacionConRepuesto '2025-12-09', NULL, 4, 5, 2;

EXEC AgregarReparacionConRepuesto '2025-12-10', NULL, 5, 1, 1;
PRINT '--- FIN: Inserción con Stored Procedure ---';

-- Realizar  update y delete sobre  algunos de los registros insertados  en esas tablas invocando a los procedimientos. 


-- Ejecución del procedimiento de actualización
EXEC setFechaFinReparacion @id_reparacion = 1, @fecha_fin = '2025-11-5';
EXEC setFechaFinReparacion @id_reparacion = 2, @fecha_fin = '2025-10-23';
EXEC setFechaFinReparacion @id_reparacion = 3, @fecha_fin = '2025-10-21';
-- Verificación del cambio
SELECT 
    id_reparacion, 
    fecha_inicio, 
    fecha_fin
FROM Reparacion
WHERE id_reparacion IN(1,2,3);

-- Ejecución del procedimiento de eliminación
EXEC eliminarReparacionConRepuesto @id_reparacion = 4;
EXEC eliminarReparacionConRepuesto @id_reparacion = 5;
EXEC eliminarReparacionConRepuesto @id_reparacion = 6;

-- Verificación de eliminacion en Reparacion
SELECT 
    id_reparacion, 
    fecha_inicio, 
    fecha_fin
FROM Reparacion
WHERE id_reparacion IN (4, 5, 6);

-- Verificación de eliminacion en Reparacion_Repuesto
SELECT
    id_reparacion,
    id_repuesto
FROM Reparacion_Repuesto
WHERE id_reparacion IN (4, 5, 6);

--Desarrollar al menos tres funciones almacenadas. Por ej: calcular la edad, 




