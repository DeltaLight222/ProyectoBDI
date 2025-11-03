-- Marcas
INSERT INTO Marca (nombre) VALUES 
('Caterpillar'),
('Komatsu'),
('John Deere'),
('Volvo'),
('Hitachi');

-- Máquinas
INSERT INTO Maquina (matricula, modelo, id_marca) VALUES
('MAQ-001', 'Retroexcavadora 420F2', 1),
('MAQ-002', 'Pala Cargadora WA200',  2),
('MAQ-003', 'Tractor 6155M',         3),
('MAQ-004', 'Excavadora EC210',      4),
('MAQ-005', 'Minicargadora ZW140',   5);

-- Establecimientos
INSERT INTO Establecimiento (nombre, direccion, id_maquina) VALUES
('Planta Norte', 'Av. Industrial 1200', 1),
('Planta Sur',   'Ruta 12 Km 8',       2),
('Taller Central', 'Av. Libertad 3450', 3);

-- Teléfonos de Establecimientos
INSERT INTO InstalacionTelefono (id_instalacion, telefono) VALUES
(1, '379-4001001'),
(1, '379-4301111'), 
(1, '379-4302222'), 
(2, '379-4002002'),
(2, '379-4303333'),
(3, '379-4003003'),
(3, '379-4304444');

-- Repuestos
INSERT INTO Repuesto (descripcion) VALUES
('Filtro de aceite'),
('Manguera hidráulica'),
('Filtro de aire'),
('Rodamiento'),
('Kit sellos hidráulicos'),
('Bomba hidráulica'),
('Correa de transmisión'),
('Aceite hidráulico');

-- Relación Maquina - Repuesto
INSERT INTO Maquina_Repuesto (id_maquina, id_repuesto) VALUES
(1, 1), (1, 2), (1, 5),
(2, 3),
(3, 4), (3, 8),
(4, 6),
(5, 7);

-- Grupos
INSERT INTO Grupo (cant_integrantes) VALUES 
(3), (4), (2);

-- Técnicos
INSERT INTO Tecnico (documento, nombre, apellido, fecha_nacimiento, telefono, id_grupo) VALUES
(40111222,'María','Gómez','1997-05-14','379-555111',1),
(39123456,'Luis','Benítez','1995-11-02','379-555222',1),
(38111222,'Rocío','Acosta','1998-07-30','379-555333',2),
(37123456,'Pablo','Zárate','1994-03-18','379-555444',2),
(40222333,'Sofía','Moreno','1999-02-22','379-555555',3),
(40333444,'Carlos','Ferreyra','1993-06-11','379-555666',3);

-- Diagnósticos
INSERT INTO Diagnostico (descripcion) VALUES
('Fuga de aceite en circuito hidráulico'),
('Filtro de aire obstruido'),
('Ruidos anómalos en transmisión'),
('Pérdida de potencia del motor'),
('Falla en sistema de frenos');

-- Revisiones
INSERT INTO Revision (fecha_inicio, fecha_fin, id_diagnostico, id_grupo) VALUES
('2025-10-20','2025-10-21', 1, 1),
('2025-10-22','2025-10-22', 2, 2),
('2025-10-23', NULL,        3, 1),
('2025-10-25','2025-10-26', 4, 3),
('2025-10-27', NULL,        5, 2);

-- Reparaciones
INSERT INTO Reparacion (fecha_inicio, fecha_fin, id_revision, id_grupo) VALUES
('2025-10-21','2025-10-21', 1, 1),
('2025-10-22','2025-10-22', 2, 2),
('2025-10-24', NULL,        3, 1),
('2025-10-26','2025-10-27', 4, 3),
('2025-10-28', NULL,        5, 2);

-- Reparación - Repuesto
INSERT INTO Reparacion_Repuesto (id_reparacion, id_repuesto) VALUES
(1, 2), (1, 5),
(2, 3),
(3, 4), (3, 8),
(4, 6),
(5, 7);