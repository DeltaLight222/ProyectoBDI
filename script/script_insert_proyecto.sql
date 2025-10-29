USE ProyectoSGM;

-- Marcas
INSERT INTO Marca (nombre) VALUES ('Caterpillar'), ('Komatsu'), ('John Deere');

-- Instalaciones
INSERT INTO Instalacion (nombre, direccion, telefono) VALUES
('Planta Norte', 'Av. Industrial 1200', '379-4001001'),
('Planta Sur',   'Ruta 12 Km 8',       '379-4002002');

-- Teléfonos adicionales
INSERT INTO InstalacionTelefono (id_instalacion, telefono) VALUES
(1, '379-4301111'), (1, '379-4302222'), (2, '379-4303333');

-- Máquinas
INSERT INTO Maquina (matricula, modelo, id_marca, id_instalacion) VALUES
('MAQ-001', 'Retroexcavadora 420F2', 1, 1),
('MAQ-002', 'Pala Cargadora WA200',  2, 1),
('MAQ-003', 'Tractor 6155M',         3, 2);

-- Repuestos
INSERT INTO Repuesto (descripcion, id_maquina) VALUES
('Filtro de aceite',       1),
('Manguera hidráulica',    1),
('Filtro de aire',         2),
('Rodamiento',             3),
('Kit sellos hidráulicos', 1);

-- Grupos
INSERT INTO Grupo (cant_integrantes) VALUES (3), (4);

-- Técnicos
INSERT INTO Tecnico (documento, nombre, apellido, fecha_nacimiento, telefono, id_grupo) VALUES
('40111222','María','Gómez','1997-05-14','379-555111',1),
('39123456','Luis','Benítez','1995-11-02','379-555222',1),
('38111222','Rocío','Acosta','1998-07-30','379-555333',2),
('37123456','Pablo','Zárate','1994-03-18','379-555444',2);

-- Diagnósticos
INSERT INTO Diagnostico (id_diagnostico, descripcion) VALUES
('D001','Fuga de aceite en circuito hidráulico'),
('D002','Filtro de aire obstruido'),
('D003','Ruidos anómalos en transmisión');

-- Revisiones
INSERT INTO Revision (fecha_inicio_revision, fecha_fin_revision, id_maquina, id_grupo, id_diagnostico) VALUES
('2025-10-20','2025-10-21', 1, 1, 'D001'),
('2025-10-22','2025-10-22', 2, 2, 'D002'),
('2025-10-23', NULL,        3, 1, 'D003');

-- Reparaciones
INSERT INTO Reparacion (fecha_inicio_reparacion, fecha_fin_reparacion, id_revision, id_grupo) VALUES
('2025-10-21','2025-10-21', 1, 1),
('2025-10-22','2025-10-22', 2, 2),
('2025-10-24', NULL,        3, 1);

-- Rep. 1 (fuga aceite): usa manguera + kit sellos
INSERT INTO Reparacion_Repuesto (id_reparacion, id_repuesto) VALUES
(1, 2), (1, 5);

-- Rep. 2 (filtro aire): usa filtro aire
INSERT INTO Reparacion_Repuesto (id_reparacion, id_repuesto) VALUES
(2, 3);

-- Rep. 3 (ruidos transmisión): usa rodamiento (en curso)
INSERT INTO Reparacion_Repuesto (id_reparacion, id_repuesto) VALUES
(3, 4);
