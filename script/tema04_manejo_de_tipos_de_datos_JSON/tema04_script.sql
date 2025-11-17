-- Crea la tabla TelemetriaMaquina para almacenar datos de telemetría en formato JSON de una máquina determinada, con una frecuencia de lectura de 10 segundos.
CREATE TABLE TelemetriaMaquina (
    id_telemetria INT IDENTITY(1,1) PRIMARY KEY,
    id_maquina INT NOT NULL,
    fecha_lectura DATETIME NOT NULL DEFAULT GETDATE(),
    datos_telemetria NVARCHAR(MAX) NOT NULL, -- Columna JSON

    CONSTRAINT FK_Telemetria_Maquina
        FOREIGN KEY (id_maquina) REFERENCES Maquina(id_maquina)
);



/* Lote de inserción de datos de telemetría en formato JSON para las máquinas con maquina_id del 1 al 5 cada 10 segundos*/
DECLARE 
    @i INT = 1,
    @id_maquina INT,
    @temp INT,
    @rpm INT,
    @presAceite INT,
    @volt INT;

WHILE @i <= 1000000
BEGIN
    -- Datos aleatorios
    SET @id_maquina = ((@i - 1) % 5) + 1;                       -- máquinas 1 a 5
    SET @temp = (ABS(CHECKSUM(NEWID())) % 80) + 20;            -- 20 a 100 °C
    SET @rpm  = (ABS(CHECKSUM(NEWID())) % 5000) + 500;         -- 500 a 5500 RPM
    SET @presAceite = (ABS(CHECKSUM(NEWID())) % 200) + 50;     -- 50 a 250 PSI
    SET @volt = (ABS(CHECKSUM(NEWID())) % 30) + 210;           -- 210 a 240 V

    INSERT INTO TelemetriaMaquina (id_maquina, fecha_lectura, datos_telemetria)
    VALUES
    (
        @id_maquina,
        DATEADD(SECOND, -10 * @i, GETDATE()),   -- cada lectura = 10 segundos atrás
        CONCAT(
            '{',
                '"temperatura": ', @temp, ',',
                '"rpm": ', @rpm, ',',
                '"presion_aceite": ', @presAceite, ',',
                '"voltaje": ', @volt,
            '}'
        )
    );

    SET @i = @i + 1;
END;

--Ejemplo de actualización de un valor específico de temperatura dentro del campo JSON para id_telemetria = 10
UPDATE TelemetriaMaquina
SET datos_telemetria = JSON_MODIFY(datos_telemetria, '$.temperatura', '75')
WHERE id_telemetria = 10;


--Consulta con operación de agregación para obtener el promedio de la temperatura de todas las lecturas almacenadas en la tabla TelemetriaMaquina
SELECT AVG(CAST(JSON_VALUE(datos_telemetria, '$.temperatura') AS INT)) AS promedio_temperatura
FROM TelemetriaMaquina;

--Consulta para obtener el valor mínimo de voltaje registrado en todas las lecturas almacenadas en la tabla TelemetriaMaquina
SELECT 
    MIN(TRY_CAST(JSON_VALUE(datos_telemetria, '$.voltaje') AS FLOAT)) AS voltaje_minimo_global
FROM TelemetriaMaquina;

--Consulta que elimina el campo de temperatura de todas las lecturas de la máquina con id_maquina = 1 que se hayan registrado en la última semana
UPDATE TelemetriaMaquina
SET datos_telemetria = JSON_MODIFY(datos_telemetria, '$.temperatura', NULL)
WHERE id_maquina = 1
  AND fecha_lectura >= DATEADD(WEEK, -1, GETDATE());

--Consulta que obtiene el promedio de todos los parámetros de telemetría (voltaje, temperatura, rpm, presión de aceite) para cada máquina (id_maquina) almacenados en la tabla TelemetriaMaquina
SELECT
    id_maquina,
    ROUND(AVG(TRY_CAST(JSON_VALUE(datos_telemetria, '$.voltaje') AS FLOAT)), 2) AS promedio_voltaje,
    ROUND(AVG(TRY_CAST(JSON_VALUE(datos_telemetria, '$.temperatura') AS FLOAT)), 2) AS promedio_temperatura,
    ROUND(AVG(TRY_CAST(JSON_VALUE(datos_telemetria, '$.rpm') AS FLOAT)), 2) AS promedio_rpm,
    ROUND(AVG(TRY_CAST(JSON_VALUE(datos_telemetria, '$.presion_aceite') AS FLOAT)), 2) AS promedio_presion_aceite
FROM TelemetriaMaquina
GROUP BY id_maquina;

--Misma consulta anterior pero utilizando OPENJSON para extraer los valores de los parámetros de telemetría
--SELECT 
    t.id_maquina,
    ROUND(AVG(TRY_CAST(j.voltaje AS FLOAT)), 2) AS promedio_voltaje,
    ROUND(AVG(TRY_CAST(j.temperatura AS FLOAT)), 2) AS promedio_temperatura,
    ROUND(AVG(TRY_CAST(j.rpm AS FLOAT)), 2) AS promedio_rpm,
    ROUND(AVG(TRY_CAST(j.presion_aceite AS FLOAT)), 2) AS promedio_presion_aceite
FROM TelemetriaMaquina AS t
CROSS APPLY OPENJSON(t.datos_telemetria)
WITH (
        voltaje          FLOAT '$.voltaje',
        temperatura      FLOAT '$.temperatura',
        rpm              FLOAT '$.rpm',
        presion_aceite   FLOAT '$.presion_aceite'
     ) AS j
GROUP BY t.id_maquina;

--Agregar columnas calculadas persistentes para cada uno de los parámetros de telemetría extraídos del campo JSON datos_telemetria
ALTER TABLE TelemetriaMaquina
ADD voltaje_calc AS CAST(JSON_VALUE(datos_telemetria, '$.voltaje') AS FLOAT) PERSISTED;

ALTER TABLE TelemetriaMaquina
ADD temperatura_calc AS CAST(JSON_VALUE(datos_telemetria, '$.temperatura') AS FLOAT) PERSISTED;

ALTER TABLE TelemetriaMaquina
ADD rpm_calc AS CAST(JSON_VALUE(datos_telemetria, '$.rpm') AS FLOAT) PERSISTED;

ALTER TABLE TelemetriaMaquina
ADD presion_aceite_calc AS CAST(JSON_VALUE(datos_telemetria, '$.presion_aceite') AS FLOAT) PERSISTED;

--Crear índices en las columnas calculadas para mejorar el rendimiento de las consultas que filtran o agrupan por estos valores

CREATE INDEX IX_Telemetria_Voltaje ON TelemetriaMaquina(voltaje_calc);
CREATE INDEX IX_Telemetria_Temperatura ON TelemetriaMaquina(temperatura_calc);
CREATE INDEX IX_Telemetria_RPM ON TelemetriaMaquina(rpm_calc);
CREATE INDEX IX_Telemetria_Presion ON TelemetriaMaquina(presion_aceite_calc);