-- =====================================
-- TEMA1 : Transacciones y transacciones anidadas en SQL
-- =====================================

USE ProyectoSGM;
GO

-- =====================================
-- 1. Transacción consistente
-- =====================================

BEGIN TRY
    BEGIN TRANSACTION;

    -- Insertar un nuevo registro en la tabla Marca
    INSERT INTO Marca (nombre)
    VALUES ('Hyundai');

    -- Guardamos el ID recién insertado
    DECLARE @idMarca INT = SCOPE_IDENTITY();

    -- Insertar un nuevo registro en la tabla Maquina asociado a la marca anterior
    INSERT INTO Maquina (matricula, modelo, id_marca)
    VALUES ('AB123CD', 'EX200', @idMarca);

    -- Actualizar un registro existente en otra tabla
    UPDATE Marca
    SET nombre = 'Hyundai Motors'
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


-- =====================================
-- 2. Provocar un error intencional y verificar consistencia
-- =====================================

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO Marca (nombre)
    VALUES ('Komatsu');

    DECLARE @idMarca2 INT = SCOPE_IDENTITY();

    -- Provocar error intencional: valor NULL en campo obligatorio
    INSERT INTO Maquina (matricula, modelo, id_marca)
    VALUES ('ZZ999ZZ', NULL, @idMarca2);

    COMMIT TRANSACTION;
    PRINT('Transacción completada con éxito.');
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT('Error intencional detectado. Se realizó ROLLBACK.');
    PRINT('Mensaje de error: ' + ERROR_MESSAGE());
END CATCH;
GO


-- =====================================
-- 3. Verificación de consistencia
-- =====================================

SELECT * FROM Marca WHERE nombre = 'Hitachi';
SELECT * FROM Marca WHERE nombre = 'Hyundai Motors';
GO
