-- 1. TRANSACCIÓN CONSISTENTE 

PRINT('=== PRUEBA 1: TRANSACCIÓN CONSISTENTE ===');
GO

BEGIN TRY
    BEGIN TRANSACTION;

    -- 1. Insertar un nuevo registro en la tabla Marca
    INSERT INTO Marca (nombre)
    VALUES ('Makita');

    DECLARE @idMarca INT = SCOPE_IDENTITY();

    -- 2. Insertar un registro en la tabla Maquina asociado a la nueva marca
    INSERT INTO Maquina (matricula, id_modelo, id_marca,id_establecimiento)
    VALUES ('AA777AA', '2', @idMarca,3);

    -- 3. Actualizar el nombre de la marca recientemente insertada
    UPDATE Marca
    SET nombre = 'Makita industrial'
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
SELECT * FROM Marca WHERE nombre LIKE 'Makita%';
SELECT * FROM Maquina WHERE matricula = 'AA777AA';
GO




-- 2. ERROR INTENCIONAL Y VERIFICACIÓN DE CONSISTENCIA

PRINT('=== PRUEBA 2: ERROR INTENCIONAL ===');

BEGIN TRY
    BEGIN TRANSACTION;

    -- 1. Insertar una nueva marca
    INSERT INTO Marca (nombre)
    VALUES ('Makita');

    DECLARE @idMarca2 INT = SCOPE_IDENTITY();

    -- 2. Provocar un error intencional: valor NULL en un campo obligatorio (id_modelo)
    INSERT INTO Maquina (matricula, id_modelo, id_marca)
    VALUES ('BB888BB', NULL, @idMarca2);

    -- 3. Actualización que no se ejecutará si ocurre error
    UPDATE Marca
    SET nombre = 'BOBCAT'
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
SELECT * FROM Maquina WHERE matricula = 'BB888BB';
SELECT * FROM Marca WHERE nombre LIKE 'BOBCAT%';
GO

-- 3. TRANSACCIONES ANIDADAS CON EL USO DE SAVEPOINTS

BEGIN TRY
    BEGIN TRANSACTION TransGeneral;
    PRINT('--- INICIO DE TRANSACCION PRINCIPAL ---');

    --------------------------------------------------------
    -- 1. Insertar diagnostico
    --------------------------------------------------------
    INSERT INTO Diagnostico (descripcion)
    VALUES ('Desgaste severo en componentes hidraulicos');

    DECLARE @idDiagnostico INT = SCOPE_IDENTITY();
    PRINT('Diagnostico insertado correctamente.');


    --------------------------------------------------------
    -- 2. Transacción anidada 1 (Insercion de Revision)
    --------------------------------------------------------
    SAVE TRANSACTION InsercionRevision;

    BEGIN TRY
        INSERT INTO Revision (fecha_inicio, fecha_fin, id_diagnostico, id_grupo)
        VALUES (GETDATE(), GETDATE(), @idDiagnostico, 1);

        DECLARE @idRevision INT = SCOPE_IDENTITY();
        PRINT('Revision creada exitosamente.');
    END TRY
    BEGIN CATCH
        PRINT('Error al insertar revision. Revirtiendo al SAVEPOINT.');
        ROLLBACK TRANSACTION InsercionRevision;
    END CATCH;


    --------------------------------------------------------
    -- 3. Obtener máquina vieja (la última registrada)
    --------------------------------------------------------
    DECLARE @idMaquinaVieja INT;

    SELECT @idMaquinaVieja = MAX(id_maquina)
    FROM Maquina;

    PRINT('Máquina vieja seleccionada: ' + CAST(@idMaquinaVieja AS VARCHAR(10)));


    --------------------------------------------------------
    -- 4. Insertar máquina nueva
    --------------------------------------------------------
    INSERT INTO Maquina (matricula, id_modelo, id_marca)
    VALUES ('RPL-999', 1, 2);

    DECLARE @idNuevaMaquina INT = SCOPE_IDENTITY();
    PRINT('Máquina de reemplazo registrada con ID: ' + CAST(@idNuevaMaquina AS VARCHAR(10)));


    --------------------------------------------------------
    -- 5. Transacción anidada 2 (Transferencia de repuestos)
    --------------------------------------------------------
    SAVE TRANSACTION TransferenciaRepuestos;

    BEGIN TRY
        INSERT INTO Maquina_Repuesto (id_maquina, id_repuesto)
        SELECT @idNuevaMaquina, id_repuesto
        FROM Maquina_Repuesto
        WHERE id_maquina = @idMaquinaVieja;

        -- Error intencional
        INSERT INTO Repuesto (descripcion) VALUES (NULL);

        DELETE FROM Maquina_Repuesto
        WHERE id_maquina = @idMaquinaVieja;

        PRINT('Repuestos transferidos correctamente.');
    END TRY
    BEGIN CATCH
        PRINT('Error durante la transferencia de repuestos. Revirtiendo al SAVEPOINT.');
        ROLLBACK TRANSACTION TransferenciaRepuestos;
    END CATCH;


    --------------------------------------------------------
    -- 6. Commit general
    --------------------------------------------------------
    COMMIT TRANSACTION TransGeneral;
    PRINT('--- TRANSACCION PRINCIPAL COMPLETADA ---');
END TRY


--------------------------------------------------------
-- CATCH GENERAL
--------------------------------------------------------
BEGIN CATCH
    PRINT('Error general. Revirtiendo transaccion principal.');
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION TransGeneral;

    PRINT(ERROR_MESSAGE());
END CATCH;


--VERIFICACION DE RESULTADOS DE LAS TRANSACCIONES ANIDADAS
-----------------------------------------------------------------
-- 1. Verificar último Diagnóstico insertado
-----------------------------------------------------------------
PRINT '--- Diagnóstico ---';

SELECT TOP 5 *
FROM Diagnostico
ORDER BY id_diagnostico DESC;


-----------------------------------------------------------------
-- 2. Verificar si se insertó la Revisión (puede haber rollback)
-----------------------------------------------------------------
PRINT '--- Revisión ---';

SELECT TOP 5 *
FROM Revision
ORDER BY id_revision DESC;


-----------------------------------------------------------------
-- 3. Verificar máquinas (la vieja y la nueva)
-----------------------------------------------------------------
PRINT '--- Máquinas ---';

SELECT TOP 5 *
FROM Maquina
ORDER BY id_maquina DESC;


-----------------------------------------------------------------
-- 4. Verificar repuestos asignados a la máquina nueva
-----------------------------------------------------------------
PRINT '--- Repuestos asociados a la nueva máquina ---';

DECLARE @ultimaMaquina INT;
SELECT @ultimaMaquina = MAX(id_maquina) FROM Maquina;

SELECT *
FROM Maquina_Repuesto
WHERE id_maquina = @ultimaMaquina;


-----------------------------------------------------------------
-- 5. Verificar si se insertó el repuesto inválido (NULL)
--    Debería NO existir por el rollback del SAVEPOINT
-----------------------------------------------------------------
PRINT '--- Repuestos (verificar que NO se insertó NULL) ---';

SELECT TOP 5 *
FROM Repuesto
ORDER BY id_repuesto DESC;
