--Se realiza una copia de la tabla porque la tabla Reparacion tiene relaciones con otras entidades.

-- Copiamos la tabla reparacion
SELECT *
INTO Reparacion_Test
FROM Reparacion;
GO

-- Limpiamos los datos de la tabla de prueba
TRUNCATE TABLE Reparacion_Test;
GO

-- Verificamos que este vacía
SELECT COUNT(*) 
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
--Table 'Reparacion_Test'. Scan count 1, logical reads 3345, physical reads 0, page server reads 0, read-ahead reads 3299, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
-- registros devuelto: 253384, CPU time = 297 ms,  elapsed time = 3054 ms.

-- 3. Crear un índice agrupado sobre la columna fecha y repetir la búsqueda, registrando nuevamente plan de ejecución y tiempos. 

-- Crear indice clustered por fecha_inicio
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
-- Table 'Reparacion_Test'. Scan count 1, logical reads 1102, physical reads 3, page server reads 0, read-ahead reads 1099, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
-- registros devuelto: 253384, CPU time = 172 ms,  elapsed time = 2872 ms.

-- 4. Borrar el índice creado. 

-- Eliminamos el indice clustered anterior
DROP INDEX IX_ReparacionTest_Fecha ON Reparacion_Test;
GO

-- 5. Crear otro índice agrupado sobre la columna fecha incluyendo columnas adicionales y repetir la búsqueda, registrando resultados. 

-- Crear indice nonclustered por fecha_inicio con columnas incluidas
CREATE NONCLUSTERED INDEX IX_ReparacionTest_FechaInicio_NC
ON Reparacion_Test(fecha_inicio)
INCLUDE (id_revision, id_grupo, fecha_fin);
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

-- tiempos devuelto con indice nonclustered por fecha_inicio con columnas incluidas
-- Table 'Reparacion_Test'. Scan count 1, logical reads 4330, physical reads 0, page server reads 0, read-ahead reads 4330, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
-- registros devuelto: 253384, CPU time = 235 ms,  elapsed time = 2971 ms.

-- Eliminamos el indice nonclustered por fecha_inicio con columnas incluidas
DROP INDEX IX_ReparacionTest_FechaInicio_NC ON Reparacion_Test;
DROP TABLE Reparacion_Test; -- eliminamos la tabla Reparacion_Test
GO

-- 6. Expresar conclusiones en base a la información estudiada y las buenas prácticas de uso de índices. 

/*
A partir de las pruebas realizadas se observo que la consulta sin indice realizo una gran cantidad de lecturas lógicas (3345) 
y presento tiempos de ejecución elevados, lo que indica que realizo un escaneo completo de la tabla.

La creacion de un indice agrupado sobre fecha_inicio mejoro notablemente el rendimiento: las lecturas logicas se redujeron a 1102 
y tanto el tiempo de CPU como el tiempo total disminuyeron. Esto demuestra que el indice clustered fue eficaz al ordenar fisicamente
la tabla según la columna utilizada en la consulta, optimizando el acceso a los datos.

En cambio, el indice nonclustered con columnas incluidas no resulto beneficioso para este caso. Las lecturas logicas aumentaron a 4330 
y los tiempos fueron similares a los de la consulta sin indice.

En conclusión, el índice agrupado fue la opción más eficiente para esta consulta , mientras que el índice nonclustered no ofreció
un mejor rendimiento.
*/

