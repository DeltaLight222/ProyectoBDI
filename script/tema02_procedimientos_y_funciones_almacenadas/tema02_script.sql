USE ProyectoSGM;
GO

 
--Realizar al menos tres procedimientos almacenados que permitan: Insertar, Modificar y borrar registros de alguna de las tablas del proyecto.


--Procedimiento para agregar una reparacion con repuesto (el id_repuesto se pasa por parametro y actualizar la tabla Reparacion_Repuesto)

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

--Procedimiento para eliminar una reparacion junto con su relacion a un repuesto asociado
CREATE PROCEDURE EliminarReparacionConRepuesto
    @id_reparacion INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Primero se elimina la asiacion de repuestos a la reparación
    DELETE FROM Reparacion_Repuesto
    WHERE id_reparacion = @id_reparacion;

    -- Luego se elimina la reparación
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

PRINT '--- INICIO: INFORME DE REPARACIONES (INSERCIÓN MANUAL) ---';
SELECT
    R.id_reparacion,
    R.fecha_inicio,
    R.id_revision,
    R.id_grupo,
    RR.id_repuesto
FROM
    Reparacion AS R
INNER JOIN
    Reparacion_Repuesto AS RR ON R.id_reparacion = RR.id_reparacion
WHERE
    R.fecha_inicio BETWEEN '2025-11-14' AND '2025-11-23' -- Filtrar por el rango de fechas de la inserción manual
ORDER BY
    R.id_reparacion;
PRINT '--- FIN: INFORME DE REPARACIONES (INSERCIÓN MANUAL) ---';

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

PRINT '--- INICIO: INFORME DE REPARACIONES (INSERCIÓN CON PROCEDURE) ---';
SELECT
    R.id_reparacion,
    R.fecha_inicio,
    R.id_revision,
    R.id_grupo,
    RR.id_repuesto
FROM
    Reparacion AS R
INNER JOIN
    Reparacion_Repuesto AS RR ON R.id_reparacion = RR.id_reparacion
WHERE
    R.fecha_inicio BETWEEN '2025-12-01' AND '2025-12-10' -- Filtrar por el rango de fechas de la inserción con procedure
ORDER BY
    R.id_reparacion;
PRINT '--- FIN: INFORME DE REPARACIONES (INSERCIÓN CON PROCEDURE) ---';

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

--Funcion que devuelve la cantidad de máquinas reparadas por un grupo identificado por su id.
CREATE FUNCTION cantMaquinasReparadasGrupo
(
    @id_grupo INT
)
RETURNS INT
AS
BEGIN
    DECLARE @cantidad INT;

    SELECT @cantidad = COUNT(DISTINCT rv.id_maquina)
    FROM Grupo g
    INNER JOIN Reparacion r
        ON r.id_grupo = g.id_grupo
    INNER JOIN Revision rv
        ON rv.id_revision = r.id_revision
    WHERE g.id_grupo = @id_grupo
      AND r.fecha_fin IS NOT NULL         -- Reparación finalizada
      AND rv.fecha_fin IS NOT NULL;       -- Revisión finalizada

    RETURN @cantidad;
END;
GO

--Ejemplo de ejecucion de la funcion con id_grupo=3
SELECT dbo.cantMaquinasReparadasGrupo(3) AS [MaquinasReparadasPorGrupo];

--Función que devuelve una tabala con el historial de reparaciones de una máquina dada su id.
CREATE FUNCTION getHistorialReparacionesMaquina (
    @idMaquina INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        MOD.descripcion AS [Modelo maquina],
        M.matricula AS [Matricula maquina],
        E.nombre AS [Nombre establecimiento],
        R.fecha_inicio AS [Fecha inicio reparacion],
        R.fecha_fin AS [Fecha fin reparacion],
        G.id_grupo AS [ID grupo reparacion],
        DI.descripcion AS [Descripcion diagnostico],
        REP.descripcion AS [Repuesto utilizado]
    FROM
        Maquina M
    INNER JOIN
        Modelo MOD ON M.id_modelo = MOD.id_modelo
    INNER JOIN
        Revision REV ON M.id_maquina = REV.id_maquina
    INNER JOIN
        Reparacion R ON REV.id_revision = R.id_revision
    LEFT JOIN
        Establecimiento E ON M.id_establecimiento = E.id_establecimiento
    LEFT JOIN
        Diagnostico DI ON REV.id_diagnostico = DI.id_diagnostico
    LEFT JOIN
        Grupo G ON R.id_grupo = G.id_grupo
    LEFT JOIN
        Reparacion_Repuesto RR ON R.id_reparacion = RR.id_reparacion
    LEFT JOIN
        Repuesto REP ON RR.id_repuesto = REP.id_repuesto
    WHERE
        M.id_maquina = @idMaquina
);

--Ejemplo de ejecucion de la funcion con id_maquina=3
SELECT *
FROM dbo.getHistorialReparacionesMaquina(3);

--Funcion que devuelve 1 si una máquina tiene reparaciones activas (sin fecha de fin) o 0 si no la tiene
CREATE FUNCTION tieneReparacionActiva (@idMaquina INT)
RETURNS BIT
AS
BEGIN
    DECLARE @ReparacionesActivas INT;
    DECLARE @Resultado BIT;

    -- Cuenta el número de reparaciones activas para la máquina dada
    SELECT
        @ReparacionesActivas = COUNT(R.id_reparacion)
    FROM
        Maquina M
    INNER JOIN
        Revision REV ON M.id_maquina = REV.id_maquina
    INNER JOIN
        Reparacion R ON REV.id_revision = R.id_revision
    WHERE
        M.id_maquina = @idMaquina
        AND R.fecha_fin IS NULL; -- La fecha de fin NULL indica que la reparación está activa

    -- Establece el resultado: 1 (True) si el conteo es mayor a 0, 0 (False) si es 0
    IF @ReparacionesActivas > 0
        SET @Resultado = 1;
    ELSE
        SET @Resultado = 0;

    RETURN @Resultado;
END;
--Ejemplo de ejecucion de la funcion con id_maquina=3
SELECT dbo.tieneReparacionActiva(3) AS [MaquinaEnReparacion];
--Resultado:1 (tiene reparación activa)

---------------------------
--PRUEBA DE EFICIENCIA DE OPERACIONES DIRECTAS VS FUNCIONES
---------------------------
SET NOCOUNT ON;

DECLARE @Iteraciones INT = 100;
DECLARE @Contador INT = 1;
DECLARE @GrupoID INT;
DECLARE @Inicio DATETIME;
DECLARE @Fin DATETIME;
DECLARE @Cantidad INT; -- Variable para almacenar la cantidad de máquinas reparadas


--Comparar la eficiencia de las operaciones directas versus el uso de procedimientos y funciones.

--Funcion para comparar entre realizar operaciones directas y utilizar funciones almacenadas.
-- 1 PRUEBA DE CONTEO DIRECTO (Manual)

PRINT '--- INICIANDO PRUEBA DE CONTEO DIRECTO (MANUAL) ---';
SET @Inicio = GETDATE();
SET @Contador = 1;

WHILE @Contador <= @Iteraciones
BEGIN
    -- Rota el ID de Grupo entre 1 y 5
    SET @GrupoID = (@Contador - 1) % 5 + 1;

    -- Ejecución Manual de la Consulta
    SELECT @Cantidad = COUNT(DISTINCT rv.id_maquina)
    FROM Grupo g
    INNER JOIN Reparacion r
        ON r.id_grupo = g.id_grupo
    INNER JOIN Revision rv
        ON rv.id_revision = r.id_revision
    WHERE g.id_grupo = @GrupoID
      AND r.fecha_fin IS NOT NULL
      AND rv.fecha_fin IS NOT NULL;

    -- Muestra el resultado de la iteración con el número de iteración
    PRINT 'Manual - Grupo ID: ' + CAST(@GrupoID AS VARCHAR) + ' - Cantidad: ' + CAST(@Cantidad AS VARCHAR) + ' | Iteracion Nro: ' + CAST(@Contador AS VARCHAR);

    SET @Contador = @Contador + 1;
END

SET @Fin = GETDATE();
PRINT '--- FIN PRUEBA MANUAL ---';
SELECT DATEDIFF(ms, @Inicio, @Fin) AS [Tiempo Total (ms) - Conteo Directo Manual];

-- 2 PRUEBA DE FUNCIÓN ESCALAR (cantMaquinasReparadasGrupo)

PRINT '--- INICIANDO PRUEBA DE FUNCIÓN ESCALAR (cantMaquinasReparadasGrupo) ---';
SET @Inicio = GETDATE();
SET @Contador = 1;

WHILE @Contador <= @Iteraciones
BEGIN
    -- Rota el ID de Grupo entre 1 y 5
    SET @GrupoID = (@Contador - 1) % 5 + 1;

    -- Ejecución con la Función Escalar
    SET @Cantidad = dbo.cantMaquinasReparadasGrupo(@GrupoID);

    -- Muestra el resultado de la iteración con el número de iteración
    PRINT 'Función - Grupo ID: ' + CAST(@GrupoID AS VARCHAR) + ' - Cantidad: ' + CAST(@Cantidad AS VARCHAR) + ' | Iteracion Nro: ' + CAST(@Contador AS VARCHAR);

    SET @Contador = @Contador + 1;
END

SET @Fin = GETDATE();
PRINT '--- FIN PRUEBA FUNCIÓN ESCALAR ---';
SELECT DATEDIFF(ms, @Inicio, @Fin) AS [Tiempo Total (ms) - Función Escalar];

--Resultado: 
--Tiempo Total (ms) - Conteo Directo Manual: 16903
--Tiempo Total (ms) - Función Escalar: 464