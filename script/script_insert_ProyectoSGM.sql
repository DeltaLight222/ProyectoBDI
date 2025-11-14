------------------------------------------------------------
-- INSERTS
------------------------------------------------------------

-- MARCA (5)
INSERT INTO Marca (nombre) VALUES
('Makita'),
('Dewalt'),
('Bosch'),
('Hitachi'),
('Black & Decker');

-- MODELO (5)
INSERT INTO Modelo (descripcion) VALUES
('Modelo Industrial A1'),
('Modelo Industrial B2'),
('Modelo Doméstico C3'),
('Modelo Alta Potencia D4'),
('Modelo Liviano E5');

-- ESTABLECIMIENTO (5)
INSERT INTO Establecimiento (nombre, direccion) VALUES
('Planta Central', 'Av. Corrientes 1234'),
('Taller Norte', 'Ruta 12 Km 8'),
('Depósito Sur', 'Calle 45 Nº 876'),
('Sucursal Este', 'Av. Libertad 3000'),
('Puesto Oeste', 'Calle Mendoza 99');

-- MAQUINA (5)
INSERT INTO Maquina (matricula, id_modelo, id_marca, id_establecimiento) VALUES
('MAQ0000001', 1, 1, 1),
('MAQ0000002', 2, 2, 2),
('MAQ0000003', 3, 3, 3),
('MAQ0000004', 4, 4, 4),
('MAQ0000005', 5, 5, 5);

-- INSTALACION TELEFONO (5)
INSERT INTO InstalacionTelefono (telefono, id_instalacion) VALUES
('3794000001', 1),
('3794000002', 1),
('3794111111', 2),
('3794222222', 3),
('3794333333', 4);

-- REPUESTO (5)
INSERT INTO Repuesto (descripcion) VALUES
('Filtro de aire'),
('Correa de transmisión'),
('Bujía'),
('Carcasa metálica'),
('Rodamiento reforzado');

-- MAQUINA_REPUESTO (5)
INSERT INTO Maquina_Repuesto (id_maquina, id_repuesto) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5);

-- DIAGNOSTICO (5)
INSERT INTO Diagnostico (descripcion) VALUES
('Falla en el sistema eléctrico'),
('Vibración excesiva'),
('Pérdida de potencia'),
('Sobrecalentamiento'),
('Ruido anormal en motor');

-- GRUPO (5)
INSERT INTO Grupo (cant_integrantes) VALUES
(3),
(4),
(5),
(2),
(6);

-- REVISION (5)
INSERT INTO Revision (fecha_inicio, fecha_fin, id_diagnostico, id_grupo) VALUES
('2025-01-10', NULL, 1, 1),
('2025-01-12', NULL, 2, 2),
('2025-01-13', NULL, 3, 3),
('2025-01-14', NULL, 4, 4),
('2025-01-15', NULL, 5, 5);

-- REPARACION (5)
INSERT INTO Reparacion (fecha_inicio, fecha_fin, id_revision, id_grupo) VALUES
('2025-01-11', NULL, 1, 1),
('2025-01-13', NULL, 2, 2),
('2025-01-14', NULL, 3, 3),
('2025-01-16', NULL, 4, 4),
('2025-01-17', NULL, 5, 5);

-- TECNICO (5)
INSERT INTO Tecnico (documento, nombre, apellido, fecha_nacimiento, telefono, id_grupo) VALUES
(10000001, 'Luis', 'Fernandez', '1990-05-01', '3794550001', 1),
(10000002, 'Jorge', 'Gomez', '1988-02-10', '3794550002', 2),
(10000003, 'Marcos', 'Mendez', '1992-11-20', '3794550003', 3),
(10000004, 'Carlos', 'Sosa', '1995-07-15', '3794550004', 4),
(10000005, 'Pedro', 'Lopez', '1985-03-22', '3794550005', 5);

-- REPARACION_REPUESTO (5)
INSERT INTO Reparacion_Repuesto (id_reparacion, id_repuesto) VALUES
(1, 1),
(1, 3),
(2, 2),
(3, 4),
(4, 5);