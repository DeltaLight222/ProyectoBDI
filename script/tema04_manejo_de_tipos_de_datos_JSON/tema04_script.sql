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
