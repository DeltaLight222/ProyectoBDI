---------------------------------------------------------
-- MARCA (5 registros)
---------------------------------------------------------
INSERT INTO Marca (nombre) VALUES
('Caterpillar'),
('John Deere'),
('Komatsu'),
('Volvo'),
('Hitachi');

---------------------------------------------------------
-- MODELO (5 registros)
---------------------------------------------------------
INSERT INTO Modelo (descripcion) VALUES
('Excavadora ZX200'),
('Pala Cargadora 980H'),
('Retroexcavadora 310L'),
('Minicargadora S450'),
('Topadora D65EX');

---------------------------------------------------------
-- ESTABLECIMIENTO (5 registros)
---------------------------------------------------------
INSERT INTO Establecimiento (nombre, direccion) VALUES
('Taller Central', 'Av. Industrial 123'),
('Depósito Norte', 'Ruta 11 Km 14'),
('Base Operativa Sur', 'Calle 45 Nº 2200'),
('Centro Logístico Oeste', 'Autopista 9 Km 33'),
('Planta Principal', 'Parque Industrial Sector B');

---------------------------------------------------------
-- ESTABLECIMIENTO TELEFONO (2 teléfonos por cada uno)
---------------------------------------------------------
INSERT INTO EstablecimientoTelefono (telefono, id_establecimiento) VALUES
('3794123456', 1), ('3794987654', 1),
('3794111122', 2), ('3794222233', 2),
('3794333344', 3), ('3794444455', 3),
('3794555566', 4), ('3794666677', 4),
('3794777788', 5), ('3794888899', 5);

---------------------------------------------------------
-- MAQUINA (5 registros)
---------------------------------------------------------
INSERT INTO Maquina (matricula, id_modelo, id_marca, id_establecimiento) VALUES
('MAQ0000001', 1, 1, 1),
('MAQ0000002', 2, 2, 2),
('MAQ0000003', 3, 3, 3),
('MAQ0000004', 4, 4, 4),
('MAQ0000005', 5, 5, 5);

---------------------------------------------------------
-- REPUESTO (5 registros)
---------------------------------------------------------
INSERT INTO Repuesto (descripcion) VALUES
('Filtro de aceite'),
('Bomba hidráulica'),
('Kit de correas'),
('Filtro de aire'),
('Motor de arranque');

---------------------------------------------------------
-- MAQUINA_REPUESTO (cada máquina usa un repuesto distinto)
---------------------------------------------------------
INSERT INTO Maquina_Repuesto (id_maquina, id_repuesto) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

---------------------------------------------------------
-- DIAGNOSTICO (5 registros)
---------------------------------------------------------
INSERT INTO Diagnostico (descripcion) VALUES
('Falla en sistema hidráulico'),
('Pérdida de potencia'),
('Problemas eléctricos'),
('Ruidos en transmisión'),
('Mantenimiento preventivo requerido');

---------------------------------------------------------
-- GRUPO (5 registros)
---------------------------------------------------------
INSERT INTO Grupo (cant_integrantes) VALUES
(3),
(4),
(2),
(5),
(3);

---------------------------------------------------------
-- REVISION (5 registros)
---------------------------------------------------------
INSERT INTO Revision (fecha_inicio, fecha_fin, id_diagnostico, id_grupo) VALUES
('2024-01-05', '2024-01-07', 1, 1),
('2024-02-10', '2024-02-12', 2, 2),
('2024-03-15', NULL, 3, 3),
('2024-04-01', '2024-04-03', 4, 4),
('2024-05-20', NULL, 5, 5);

---------------------------------------------------------
-- REPARACION (5 registros)
---------------------------------------------------------
INSERT INTO Reparacion (fecha_inicio, fecha_fin, id_revision, id_grupo) VALUES
('2024-01-08', '2024-01-12', 1, 1),
('2024-02-13', '2024-02-16', 2, 2),
('2024-03-20', NULL, 3, 3),
('2024-04-04', '2024-04-06', 4, 4),
('2024-05-22', NULL, 5, 5);

---------------------------------------------------------
-- TECNICO (5 registros)
---------------------------------------------------------
INSERT INTO Tecnico (documento, nombre, apellido, fecha_nacimiento, telefono, id_grupo) VALUES
(30111222, 'Carlos', 'Gómez', '1985-03-10', '3794000011', 1),
(30222333, 'María', 'López', '1990-07-22', '3794000022', 2),
(30333444, 'Javier', 'Martínez', '1988-12-05', '3794000033', 3),
(30444555, 'Sandra', 'Torres', '1992-01-15', '3794000044', 4),
(30555666, 'Lucas', 'Fernández', '1984-09-09', '3794000055', 5);

---------------------------------------------------------
-- REPARACION_REPUESTO (cada reparación usa un repuesto)
---------------------------------------------------------
INSERT INTO Reparacion_Repuesto (id_repuesto, id_reparacion) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
