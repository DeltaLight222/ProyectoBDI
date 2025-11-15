---------------------------------------------------------
-- INSERTS: Marca
---------------------------------------------------------
INSERT INTO Marca (nombre) VALUES
('Caterpillar'),
('Komatsu'),
('John Deere'),
('Volvo'),
('Hitachi');

---------------------------------------------------------
-- INSERTS: Modelo
---------------------------------------------------------
INSERT INTO Modelo (descripcion) VALUES
('Excavadora ZX200'),
('Retroexcavadora 310L'),
('Pala Cargadora L90'),
('Topadora D6'),
('Grúa Hidráulica GH500');

---------------------------------------------------------
-- INSERTS: Establecimiento
---------------------------------------------------------
INSERT INTO Establecimiento (nombre, direccion) VALUES
('Depósito Central', 'Av. Siempre Viva 123'),
('Planta Norte', 'Ruta 8 Km 45'),
('Planta Sur', 'Camino del Álamo 2500'),
('Base Operativa Este', 'Calle Corrientes 555'),
('Base Operativa Oeste', 'Av. Libertad 900');

---------------------------------------------------------
-- INSERTS: Maquina
---------------------------------------------------------
INSERT INTO Maquina (matricula, id_modelo, id_marca, id_establecimiento) VALUES
('MAQ0001', 1, 1, 1),
('MAQ0002', 2, 3, 2),
('MAQ0003', 3, 4, 3),
('MAQ0004', 4, 2, 4),
('MAQ0005', 5, 5, 5);

---------------------------------------------------------
-- INSERTS: EstablecimientoTelefono
---------------------------------------------------------
INSERT INTO EstablecimientoTelefono (telefono, id_establecimiento) VALUES
('1111-1111', 1),
('2222-2222', 2),
('3333-3333', 3),
('4444-4444', 4),
('5555-5555', 5);

---------------------------------------------------------
-- INSERTS: Repuesto
---------------------------------------------------------
INSERT INTO Repuesto (descripcion) VALUES
('Filtro de aceite'),
('Batería industrial'),
('Juego de orugas'),
('Bomba hidráulica'),
('Radiador reforzado');

---------------------------------------------------------
-- INSERTS: Maquina_Repuesto
---------------------------------------------------------
INSERT INTO Maquina_Repuesto (id_maquina, id_repuesto) VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5);

---------------------------------------------------------
-- INSERTS: Diagnostico
---------------------------------------------------------
INSERT INTO Diagnostico (descripcion) VALUES
('Falla en sistema hidráulico'),
('Desgaste de orugas'),
('Pérdida de potencia'),
('Ruidos anómalos en motor'),
('Falla eléctrica intermitente');

---------------------------------------------------------
-- INSERTS: Grupo
---------------------------------------------------------
INSERT INTO Grupo (cant_integrantes) VALUES
(3),
(4),
(2),
(5),
(6);

---------------------------------------------------------
-- INSERTS: Revision
---------------------------------------------------------
INSERT INTO Revision (fecha_inicio, fecha_fin, id_diagnostico, id_grupo, id_maquina) VALUES
('2024-01-10', '2024-01-12', 1, 1, 1),
('2024-02-05', '2024-02-06', 2, 2, 2),
('2024-03-11', '2024-03-15', 3, 3, 3),
('2024-04-02', NULL, 4, 4, 4),
('2024-05-20', NULL, 5, 5, 5);

---------------------------------------------------------
-- INSERTS: Reparacion
---------------------------------------------------------
INSERT INTO Reparacion (fecha_inicio, fecha_fin, id_revision, id_grupo) VALUES
('2024-01-13', '2024-01-16', 1, 1),
('2024-02-07', '2024-02-10', 2, 2),
('2024-03-16', '2024-03-20', 3, 3),
('2024-04-03', NULL, 4, 4),
('2024-05-21', NULL, 5, 5);

---------------------------------------------------------
-- INSERTS: Tecnico
---------------------------------------------------------
INSERT INTO Tecnico (documento, nombre, apellido, fecha_nacimiento, telefono, id_grupo) VALUES
(10100100, 'Carlos', 'Pérez', '1985-04-12', '1160000001', 1),
(20200200, 'Lucía', 'Gómez', '1990-09-22', '1160000002', 2),
(30300300, 'Marcos', 'López', '1982-11-03', '1160000003', 3),
(40400400, 'Ana', 'Martínez', '1995-01-14', '1160000004', 4),
(50500500, 'Jorge', 'Fernández', '1988-07-08', '1160000005', 5);

---------------------------------------------------------
-- INSERTS: Reparacion_Repuesto
---------------------------------------------------------
INSERT INTO Reparacion_Repuesto (id_repuesto, id_reparacion) VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5);
