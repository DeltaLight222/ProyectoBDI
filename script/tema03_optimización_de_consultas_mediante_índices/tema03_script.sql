--Se realiza una copia de la tabla porque la tabla Reparacion tiene relaciones con otras entidades.

-- Copiamos la tabla reparacion
SELECT *
INTO Reparacion_Test
FROM Reparacion;
GO

-- Limpiamos los datos de la tabla de prueba
TRUNCATE TABLE Reparacion_Test;
GO

-- Verificamos que esté vacía
SELECT * 
FROM Reparacion_Test;
GO

-- 1. Cargar masivamente al menos un millón de registros en una tabla con campo fecha (sin índice) mediante un script automatizado. 

-- creamos el script para generar la carga masiva

DECLARE @RevisionID INT = 1;   
DECLARE @GrupoID INT = 1;      
DECLARE @i INT = 1;
DECLARE @batchSize INT = 50000;
DECLARE @max INT = 1000000;

WHILE @i <= @max
BEGIN
    WITH N AS (
        SELECT TOP (@batchSize)
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) + (@i - 1) AS num
        FROM sys.all_objects a
        CROSS JOIN sys.all_objects b
    )
    INSERT INTO Reparacion_Test (fecha_inicio, fecha_fin, id_revision, id_grupo)
    SELECT 
        DATEADD(DAY, (num - 1) % 600, '2024-01-01'),           
        DATEADD(DAY, ((num - 1) % 600) + 1, '2024-01-01'),     
        @RevisionID,                                           
        @GrupoID                                              
    FROM N;

    SET @i += @batchSize;
END
GO

-- Verificar cantidad de carga
SELECT COUNT(*) AS Total_Registros 
FROM Reparacion_Test;
GO

-- 2. Realizar búsquedas por periodo y registrar el plan de ejecución y los tiempos de respuesta.   

CHECKPOINT; -- Guarda las páginas modificadas en disco para dejar la base de datos en estado consistente.
DBCC DROPCLEANBUFFERS; -- Quita del buffer pool las páginas limpias para obligar a SQL Server a leer desde disco en la próxima consulta.
DBCC FREEPROCCACHE; -- Elimina los planes de ejecución almacenados para que SQL Server genere uno nuevo.
GO


SET STATISTICS TIME ON; -- Activa la medición del tiempo que tarda en ejecutarse cada consulta
SET STATISTICS IO ON; -- Activa la medición de estadísticas de entrada/salida

-- La consulta devuelve todas las reparaciones que esten en ese rango de fecha
SELECT *
FROM Reparacion_Test
WHERE fecha_inicio BETWEEN '2024-01-01' AND '2024-05-31';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO
-- tiempos devuelto sin indice
-- registros devuelto: 253384, CPU time = 250 ms,  elapsed time = 3355 ms

-- 3. Crear un índice agrupado sobre la columna fecha y repetir la búsqueda, registrando nuevamente plan de ejecución y tiempos. 

-- Crear índice clustered por fecha_inicio
CREATE CLUSTERED INDEX IX_ReparacionTest_Fecha
ON Reparacion_Test (fecha_inicio);
GO

CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT *
FROM Reparacion_Test
WHERE fecha_inicio BETWEEN '2024-01-01' AND '2024-05-31';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

-- tiempos devuelto con indice agrupado
-- registros devuelto: 253384, CPU time = 187 ms,  elapsed time = 3366 ms.

-- 4. Borrar el índice creado. 

-- Eliminamos el índice clustered anterior
DROP INDEX IX_ReparacionTest_Fecha ON Reparacion_Test;
GO

-- 5. Crear otro índice agrupado sobre la columna fecha incluyendo columnas adicionales y repetir la búsqueda, registrando resultados. 

-- Creamos un índice agrupado mas columna adicional
CREATE CLUSTERED INDEX IX_ReparacionTest_Fecha_Extendido
ON Reparacion_Test (fecha_inicio, fecha_fin, id_grupo, id_revision);

CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT *
FROM Reparacion_Test
WHERE fecha_inicio BETWEEN '2024-01-01' AND '2024-05-31';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

-- tiempos devuelto con indice mas columna adicional
-- registros devuelto: 253384, CPU time = 141 ms,  elapsed time = 2929 ms.

-- Eliminamos el índice con columna adicional
DROP INDEX IX_ReparacionTest_Fecha_Extendido ON Reparacion_Test;
DROP TABLE Reparacion_Test; -- eliminamos la tabla Reparacion_Test
GO

