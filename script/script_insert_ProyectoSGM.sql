-- 1. MARCA
INSERT INTO Marca (nombre) VALUES
('Caterpillar'),
('Komatsu'),
('Volvo'),
('Hitachi'),
('John Deere');

-- 2. MODELO
INSERT INTO Modelo (id_modelo, descripcion) VALUES
(1, 'Excavadora 320D'),
(2, 'Retroexcavadora WB93R'),
(3, 'Cargadora L120H'),
(4, 'Topadora D6R'),
(5, 'Miniexcavadora ZX55U');

-- 3. ESTABLECIMIENTO
INSERT INTO Establecimiento (nombre, direccion) VALUES
('Taller Central', 'Av. San Martín 1020'),
('Planta Norte', 'Ruta 11 Km 22'),
('Base Sur', 'Calle 25 de Mayo 845'),
('Depósito Industrial', 'Av. Belgrano 1440'),
('Centro Logístico', 'Av. Rivadavia 2300');

-- 4. MAQUINA
INSERT INTO Maquina (matricula, id_modelo, id_marca, id_establecimiento) VALUES
('CAT001A', 1, 1, 1),
('KMT002B', 2, 2, 2),
('VOL003C', 3, 3, 3),
('HTC004D', 4, 4, 4),
('JDN005E', 5, 5, 5);

-- 5. INSTALACION TELEFONO
INSERT INTO InstalacionTelefono (telefono, id_instalacion) VALUES
('3794123456', 1),
('3794234567', 2),
('3794345678', 3),
('3794456789', 4),
('3794567890', 5);

-- 6. REPUESTO
INSERT INTO Repuesto (descripcion) VALUES
('Filtro de aceite'),
('Batería 12V 180Ah'),
('Correa de transmisión'),
('Bomba hidráulica'),
('Filtro de aire');

-- 7. MAQUINA_REPUESTO
INSERT INTO Maquina_Repuesto (id_maquina, id_repuesto) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5);

-- 8. DIAGNOSTICO
INSERT INTO Diagnostico (descripcion) VALUES
('Falla en sistema hidráulico'),
('Pérdida de potencia del motor'),
('Vibración en transmisión'),
('Sobrecalentamiento'),
('Ruido anormal en dirección');

-- 9. GRUPO
INSERT INTO Grupo (cant_integrantes) VALUES
(3),
(4),
(5),
(3),
(2);

-- 10. REVISION
INSERT INTO Revision (fecha_inicio, fecha_fin, id_diagnostico, id_grupo) VALUES
('2025-01-10', '2025-01-11', 1, 1),
('2025-02-05', '2025-02-07', 2, 2),
('2025-03-15', '2025-03-16', 3, 3),
('2025-04-01', '2025-04-02', 4, 4),
('2025-04-20', '2025-04-21', 5, 5);

-- 11. REPARACION
INSERT INTO Reparacion (fecha_inicio, fecha_fin, id_revision, id_grupo) VALUES
('2025-01-12', '2025-01-14', 1, 1),
('2025-02-08', '2025-02-10', 2, 2),
('2025-03-17', '2025-03-18', 3, 3),
('2025-04-03', '2025-04-05', 4, 4),
('2025-04-22', '2025-04-23', 5, 5);

-- 12. TECNICO
INSERT INTO Tecnico (documento, nombre, apellido, fecha_nacimiento, telefono, id_grupo) VALUES
(35000111, 'Juan', 'Pérez', '1990-05-10', '3794112233', 1),
(36000222, 'María', 'Gómez', '1988-07-15', '3794223344', 2),
(37000333, 'Carlos', 'López', '1992-09-21', '3794334455', 3),
(38000444, 'Ana', 'Fernández', '1995-12-02', '3794445566', 4),
(39000555, 'Lucía', 'Martínez', '1998-03-30', '3794556677', 5);

-- 13. REPARACION_REPUESTO
INSERT INTO Reparacion_Repuesto (id_repuesto, id_reparacion) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 3),
(5, 4);