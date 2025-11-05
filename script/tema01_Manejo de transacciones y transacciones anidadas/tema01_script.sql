
-- 1. TRANSACCIÓN CONSISTENTE 

PRINT('=== PRUEBA 1: TRANSACCIÓN CONSISTENTE ===');
GO

BEGIN TRY
    BEGIN TRANSACTION;

    -- 1. Insertar un nuevo registro en la tabla Marca
    INSERT INTO Marca (nombre)
    VALUES ('Komatsu');

    DECLARE @idMarca INT = SCOPE_IDENTITY();

    -- 2. Insertar un registro en la tabla Maquina asociado a la nueva marca
    INSERT INTO Maquina (matricula, modelo, id_marca)
    VALUES ('AA777AA', 'EX300', @idMarca);

    -- 3. Actualizar el nombre de la marca recientemente insertada
    UPDATE Marca
    SET nombre = 'Komatsu Industrial'
    WHERE id_marca = @idMarca;

    COMMIT TRANSACTION;
    PRINT('Transacción completada con éxito.');
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT('Error detectado. Se realizó ROLLBACK.');
    PRINT('Mensaje de error: ' + ERROR_MESSAGE());
END CATCH;
GO

-- Verificación de resultados
SELECT * FROM Marca WHERE nombre LIKE 'Komatsu%';
SELECT * FROM Maquina WHERE matricula = 'AA777AA';
GO


-- 2. ERROR INTENCIONAL Y VERIFICACIÓN DE CONSISTENCIA

PRINT('=== PRUEBA 2: ERROR INTENCIONAL ===');

BEGIN TRY
    BEGIN TRANSACTION;

    -- 1. Insertar una nueva marca
    INSERT INTO Marca (nombre)
    VALUES ('Caterpillar');

    DECLARE @idMarca2 INT = SCOPE_IDENTITY();

    -- 2. Provocar un error intencional: valor NULL en un campo obligatorio
    INSERT INTO Maquina (matricula, modelo, id_marca)
    VALUES ('BB888BB', NULL, @idMarca2);

    -- 3. Actualización que no se ejecutará si ocurre error
    UPDATE Marca
    SET nombre = 'Caterpillar Heavy'
    WHERE id_marca = @idMarca2;

    COMMIT TRANSACTION;
    PRINT('Transacción completada con éxito.');
    END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT('Error intencional detectado. Se realizó ROLLBACK.');
    PRINT('Mensaje de error: ' + ERROR_MESSAGE());
END CATCH;
GO

-- Verificación: los registros no deben existir
SELECT * FROM Marca WHERE nombre LIKE 'Caterpillar%';
SELECT * FROM Maquina WHERE matricula = 'BB888BB';
GO

-- 3. TRANSACCIONES ANIDADAS

-- Se tiene como ejemplo el caso en que una maquina vieja es reemplazada por una nueva.
-- Se le realiza un ultimo diagnóstico y revisión a la máquina vieja, se registra la nueva máquin y se le transfieren los repuestos de la maquina vieja.
-- Por ultimo se elimina la máquina vieja.


BEGIN TRY
    BEGIN TRANSACTION TransGeneral;
    PRINT('--- INICIO DE TRANSACCIÓN PRINCIPAL ---');

    -- 1. Insertar nuevo diagnóstico
    INSERT INTO Diagnostico (descripcion)
    VALUES ('Desgaste severo en componentes hidráulicos');

    DECLARE @idDiagnostico INT = SCOPE_IDENTITY();
    PRINT('Diagnóstico insertado correctamente.');


    -- 2. Crear un SAVEPOINT antes de insertar revisión
    SAVE TRANSACTION InsercionRevision;

    BEGIN TRY
        INSERT INTO Revision (fecha_inicio, fecha_fin, id_diagnostico, id_grupo)
        VALUES (GETDATE(), GETDATE(), @idDiagnostico, 1);

        DECLARE @idRevision INT = SCOPE_IDENTITY();
        PRINT('Revisión creada exitosamente.');
    END TRY
    BEGIN CATCH
        PRINT('Error al insertar revisión. Revirtiendo al SAVEPOINT.');
        ROLLBACK TRANSACTION InsercionRevision;
    END CATCH;


    -- 3. Insertar nueva máquina de reemplazo
    INSERT INTO Maquina (matricula, modelo, id_marca)
    VALUES ('RPL-999', 'Modelo XR-6000', 2);

    DECLARE @idNuevaMaquina INT = SCOPE_IDENTITY();
    PRINT('Máquina de reemplazo registrada.');


    -- 4. Crear un SAVEPOINT antes de transferir repuestos
    SAVE TRANSACTION TransferenciaRepuestos;

    BEGIN TRY
        DECLARE @idMaquinaVieja INT = 5; -- Ejemplo

        -- Transferir repuestos de la máquina vieja a la nueva
        INSERT INTO Maquina_Repuesto (id_maquina, id_repuesto)
        SELECT @idNuevaMaquina, id_repuesto
        FROM Maquina_Repuesto
        WHERE id_maquina = @idMaquinaVieja;

        -- Provocar un error intencional (campo obligatorio NULL)
        INSERT INTO Repuesto (descripcion)
        VALUES (NULL); -- Forzar error

        -- Si todo va bien, eliminar vínculos de la máquina vieja
        DELETE FROM Maquina_Repuesto
        WHERE id_maquina = @idMaquinaVieja;

        PRINT('Repuestos transferidos correctamente.');
    END TRY
    BEGIN CATCH
        PRINT('Error durante la transferencia. Volviendo al SAVEPOINT.');
        ROLLBACK TRANSACTION TransferenciaRepuestos;
    END CATCH;


    -- 5. Eliminar máquina vieja
    DELETE FROM Maquina
    WHERE id_maquina = @idMaquinaVieja;

    PRINT('Máquina vieja eliminada correctamente.');


    COMMIT TRANSACTION TransGeneral;
    PRINT('--- TRANSACCIÓN COMPLETADA CON ÉXITO ---');
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION TransGeneral;

    PRINT('Error general. Se revirtieron todos los cambios.');
    PRINT('Mensaje de error: ' + ERROR_MESSAGE());
END CATCH;
