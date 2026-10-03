
-- Insertar en Admins
INSERT INTO admins (username, password)
VALUES ('admin1', 'password123'),
       ('admin2', 'password456'),
       ('admin3', 'password789');

-- Insertar en Addresses
INSERT INTO addresses (address, district, province, department, sector)
VALUES
('Av. Los Próceres 123', 'Surco', 'Lima', 'Lima', 'Educación'),
('Jr. Los Libertadores 456', 'San Miguel', 'Lima', 'Lima', 'Salud'),
('Calle La Merced 789', 'Cercado de Arequipa', 'Arequipa', 'Arequipa', 'Comercio'),
('Av. Primavera 321', 'La Molina', 'Lima', 'Lima', 'Transporte'),
('Pasaje Las Flores 101', 'Miraflores', 'Lima', 'Lima', 'Turismo'),
('Jr. Santa Rosa 998', 'Trujillo', 'Trujillo', 'La Libertad', 'Agricultura'),
('Av. Industrial 202', 'Villa El Salvador', 'Lima', 'Lima', 'Industria'),
('Calle Comercio 304', 'Puno', 'Puno', 'Puno', 'Ganadería'),
('Av. El Sol 567', 'Cusco', 'Cusco', 'Cusco', 'Turismo'),
('Jr. Los Incas 785', 'San Juan de Lurigancho', 'Lima', 'Lima', 'Tecnología'),
('Calle Real 132', 'Huancayo', 'Huancayo', 'Junín', 'Educación'),
('Av. Brasil 256', 'Jesús María', 'Lima', 'Lima', 'Salud'),
('Jr. San Martín 333', 'Piura', 'Piura', 'Piura', 'Pesca'),
('Av. Arequipa 1212', 'Lince', 'Lima', 'Lima', 'Servicios'),
('Pasaje Las Gardenias 654', 'Tacna', 'Tacna', 'Tacna', 'Comercio');

-- Insertar en ISPs
INSERT INTO isps (ruc, name)
VALUES
('20123456789', 'Claro Perú'),
('20456789012', 'Movistar'),
('20567890123', 'Entel'),
('20678901234', 'Bitel'),
('20789012345', 'FiberNet'),
('20890123456', 'Netline'),
('20901234567', 'SpeedyNet'),
('20111234567', 'Infinitum'),
('20222345678', 'MegaCable'),
('20333456789', 'InternetYa');

-- Insertar en Providers
INSERT INTO providers (ruc, name, logo)
VALUES
('20123456789', 'Proveedor Alpha SAC', 'alpha_logo.png'),
('20456789012', 'Proveedor Beta EIRL', 'beta_logo.png'),
('20678901234', 'Proveedor Gamma SRL', 'gamma_logo.png'),
('20890123456', 'Proveedor Delta SAC', 'delta_logo.png'),
('20987654321', 'Proveedor Epsilon S.A.', 'epsilon_logo.png'),
('20765432109', 'Proveedor Zeta SAC', 'zeta_logo.png'),
('20543210987', 'Proveedor Eta SAC', 'eta_logo.png'),
('20321098765', 'Proveedor Theta SAC', 'theta_logo.png'),
('20210987654', 'Proveedor Iota SAC', 'iota_logo.png'),
('20109876543', 'Proveedor Kappa SAC', 'kappa_logo.png');

-- Insertar en AdminProvider (relacionando 3 admins con 3 a 4 providers)
INSERT INTO admin_provider (provider_id, admin_id)
VALUES
(1, 1), -- Proveedor Alpha SAC con Admin 1
(2, 1), -- Proveedor Beta EIRL con Admin 1
(3, 1), -- Proveedor Gamma SRL con Admin 1
(4, 2), -- Proveedor Delta SAC con Admin 2
(5, 2), -- Proveedor Epsilon S.A. con Admin 2
(6, 2), -- Proveedor Zeta SAC con Admin 2
(7, 3), -- Proveedor Eta SAC con Admin 3
(8, 3), -- Proveedor Theta SAC con Admin 3
(9, 3), -- Proveedor Iota SAC con Admin 3
(10, 1), -- Proveedor Kappa SAC con Admin 1
(3, 2), -- Proveedor Gamma SRL con Admin 2
(5, 3); -- Proveedor Epsilon S.A. con Admin 3

-- Insertar en Companies
INSERT INTO companies (address_id, ruc, name)
VALUES
(1, '20123456789', 'Empresa Educativa S.A.C.'),
(2, '20234567890', 'Centro Médico Integral'),
(3, '20345678901', 'Supermercados El Ahorro'),
(4, '20456789012', 'Transporte Nacional S.R.L.'),
(5, '20567890123', 'Agencia de Turismo Perú'),
(6, '20678901234', 'Granja Los Andes'),
(7, '20789012345', 'Industria Textil Andina'),
(8, '20890123456', 'Ganadería del Sur'),
(9, '20901234567', 'Cusco Travel Group'),
(10, '21012345678', 'Soluciones Digitales S.A.C.'),
(11, '21123456789', 'Instituto de Educación Junín'),
(12, '21234567890', 'Clínica Santa Fe'),
(13, '21345678901', 'Exportadora Marina S.A.'),
(14, '21456789012', 'Servicios Generales Lima'),
(15, '21567890123', 'Comercializadora Tacna');

-- Insertar en IspServices
INSERT INTO isp_services (isp_id, provider_id, description, cost, pay_code)
VALUES
(1, 1, 'Internet 100 Mbps', 89.90, 'CL001'),
(2, 2, 'Internet 200 Mbps', 120.50, 'MV002'),
(3, 3, 'Fibra 300 Mbps', 150.00, 'EN003'),
(4, 4, 'Plan Gamer 150 Mbps', 99.99, 'BT004'),
(5, 5, 'Internet Básico 50 Mbps', 70.00, 'FN005'),
(6, 6, 'Plan Hogar 200 Mbps', 110.00, 'NL006'),
(7, 7, 'Plan PyME 500 Mbps', 199.00, 'SP007'),
(8, 8, 'Fibra 1000 Mbps', 299.99, 'IN008'),
(9, 9, 'TV + Internet 100 Mbps', 139.50, 'MC009'),
(10, 10, 'Internet Prepago 20 Mbps', 45.00, 'IY010');

-- Insertar en Dependencies
INSERT INTO dependencies (company_id, provider_id, name, sign_date, validity_time, termination_date, anniversary, equipment)
VALUES
(9, 7, 'Sede Central Lima', '2022-07-23', '5 años', '2026-11-03', '06-02', '3 routers Marca Tplink modelo Archer C62 AC1200, Switch administrable Tplink 48 puertos PoE'),
(9, 5, 'Sucursal Arequipa', '2024-03-21', '5 años', '2025-11-26', '11-18', '1 Access Point Ubiquiti UniFi 6, Router MikroTik hAP ac²'),
(2, 2, 'Oficina Trujillo', '2024-06-18', '1 años', '2027-04-15', '02-09', '2 routers Cisco RV340, Switch D-Link 24 puertos PoE'),
(1, 9, 'Centro Piura', '2023-04-20', '3 años', '2028-01-30', '03-22', '1 Access Point Ubiquiti UniFi 6, Router MikroTik hAP ac²'),
(1, 9, 'Sede Cusco', '2023-01-01', '5 años', '2025-09-25', '02-19', '4 routers Tenda AC10U, Switch administrable TP-Link 16 puertos'),
(1, 10, 'Oficina Iquitos', '2023-11-04', '2 años', '2028-03-21', '02-12', '4 routers Tenda AC10U, Switch administrable TP-Link 16 puertos'),
(7, 2, 'Sucursal Chiclayo', '2024-11-29', '5 años', '2027-10-03', '09-27', '2 routers Huawei AX3 Quad-core, Switch Netgear ProSAFE 24 puertos'),
(8, 5, 'Base Tacna', '2023-08-20', '4 años', '2027-12-10', '10-03', '2 routers Huawei AX3 Quad-core, Switch Netgear ProSAFE 24 puertos'),
(1, 6, 'Oficina Puno', '2024-12-16', '5 años', '2026-08-20', '06-12', '2 routers Cisco RV340, Switch D-Link 24 puertos PoE'),
(5, 3, 'Sede Callao', '2023-08-26', '5 años', '2026-07-02', '04-22', '2 routers Cisco RV340, Switch D-Link 24 puertos PoE'),
(7, 4, 'Sucursal Huancayo', '2023-10-22', '3 años', '2026-06-26', '05-27', '2 routers Huawei AX3 Quad-core, Switch Netgear ProSAFE 24 puertos'),
(4, 5, 'Oficina Juliaca', '2023-03-07', '3 años', '2026-09-29', '05-30', '2 routers Cisco RV340, Switch D-Link 24 puertos PoE'),
(5, 6, 'Centro Tumbes', '2025-01-18', '4 años', '2025-08-09', '05-14', '1 Access Point Ubiquiti UniFi 6, Router MikroTik hAP ac²'),
(6, 1, 'Sede Ica', '2022-12-17', '4 años', '2027-03-20', '05-24', '2 routers Huawei AX3 Quad-core, Switch Netgear ProSAFE 24 puertos'),
(6, 8, 'Sucursal Ayacucho', '2023-12-31', '4 años', '2027-04-01', '01-02', '2 routers Huawei AX3 Quad-core, Switch Netgear ProSAFE 24 puertos'),
(3, 8, 'Base Cajamarca', '2023-10-20', '4 años', '2027-02-24', '11-19', '1 Access Point Ubiquiti UniFi 6, Router MikroTik hAP ac²'),
(1, 6, 'Oficina Tarapoto', '2023-05-22', '3 años', '2027-09-25', '03-31', '3 routers Marca Tplink modelo Archer C62 AC1200, Switch administrable Tplink 48 puertos PoE'),
(7, 4, 'Sede Huaraz', '2023-05-22', '2 años', '2025-11-24', '09-02', '1 Access Point Ubiquiti UniFi 6, Router MikroTik hAP ac²'),
(8, 1, 'Sucursal Moquegua', '2024-09-05', '5 años', '2025-07-13', '04-30', '2 routers Huawei AX3 Quad-core, Switch Netgear ProSAFE 24 puertos'),
(10, 5, 'Centro Chimbote', '2024-05-05', '1 años', '2027-11-23', '05-11', '4 routers Tenda AC10U, Switch administrable TP-Link 16 puertos');

-- Insertar en Contacts
INSERT INTO contacts (dependency_id, name, last_name, cellphone, rank, position, birthday)
VALUES
(12, 'Aurelio', 'Fajardo Garriga', '968846847', 'Gerente', 'Investment analyst', '06-05'),
(16, 'Hernán', 'del Pineda', '999550928', 'Asistente', 'Health visitor', '05-11'),
(7, 'Marianela', 'Pedro Guillén', '914529145', 'Supervisor', 'Biomedical engineer', '11-23'),
(20, 'Lalo', 'Espada Cifuentes', '915454812', 'Director', 'Engineer, land', '05-15'),
(9, 'Carla', 'Emperatriz Cáceres Arévalo', '956968883', 'Gerente', 'Fish farm manager', '06-26'),
(12, 'Martina', 'Salvà', '977779451', 'Asistente', 'Youth worker', '05-05'),
(14, 'Teodora', 'Cruz Cueto', '943800006', 'Gerente', 'Adult nurse', '01-10'),
(12, 'Clementina', 'Borrego Palomino', '925768238', 'Director', 'Investment analyst', '01-24'),
(19, 'Ariel', 'del Llano', '950206363', 'Asistente', 'Fish farm manager', '12-24'),
(5, 'Felipe', 'Manrique Dueñas', '955674872', 'Gerente', 'Chartered loss adjuster', '08-11'),
(15, 'Herberto', 'Pereira Donoso', '977547829', 'Director', 'Research officer, trade union', '08-03'),
(20, 'Lisandro', 'de Canales', '978852068', 'Gerente', 'Child psychotherapist', '01-13'),
(2, 'Íngrid', 'Sainz Porras', '933479102', 'Asistente', 'Television/film/video producer', '07-31'),
(17, 'León', 'Vilar Moles', '985435793', 'Gerente', 'Charity officer', '06-04'),
(10, 'Octavia', 'del Guzmán', '921582692', 'Gerente', 'Engineer, communications', '03-05'),
(10, 'Kike', 'Cuevas', '960732584', 'Supervisor', 'Applications developer', '04-11'),
(9, 'Rosario', 'Company Landa', '998068518', 'Gerente', 'Radio producer', '04-12'),
(3, 'Javi', 'Montalbán', '920589036', 'Asistente', 'Medical illustrator', '06-14'),
(14, 'Omar', 'Cánovas Morata', '926685606', 'Director', 'Clinical cytogeneticist', '12-01'),
(14, 'Clara', 'Tamayo Guillen', '943488121', 'Gerente', 'Patent attorney', '03-25');

-- Insertar en ProviderServices
INSERT INTO provider_services (dependency_id, provider_id, description, price)
VALUES
(1, 1, 'Servicio de mantenimiento de servidores', 250.00),
(2, 2, 'Consultoría en ciberseguridad', 500.50),
(3, 3, 'Desarrollo de aplicación móvil', 1200.00),
(4, 1, 'Soporte técnico mensual', 300.00),
(5, 2, 'Diseño y desarrollo web', 950.75),
(6, 3, 'Instalación de redes LAN', 430.00),
(7, 1, 'Auditoría de sistemas', 670.20),
(8, 2, 'Capacitación en herramientas ofimáticas', 220.00),
(9, 3, 'Licenciamiento de software', 800.00),
(10, 1, 'Consultoría en transformación digital', 1500.00);

-- Insertar en Invoices
INSERT INTO invoices (invoice_number, service_type, service_id, invoice_month, invoiced, issue_date, due_date)
VALUES
('E001-000586', 'Proveedor', 1, 2, false, '2025-03-07', '2025-03-31'),
('F001-00008976', 'ISP', 4, 2, true, '2025-02-01', '2025-02-25'),
('E001-000587', 'Proveedor', 10, 3, true, '2025-04-01', '2025-04-28'),
('F001-00008977', 'ISP', 3, 3, false, '2025-03-05', '2025-03-25'),
('E001-000588', 'Proveedor', 1, 4, true, '2025-05-02', '2025-05-30'),
('F001-00008978', 'ISP', 4, 4, false, '2025-04-01', '2025-04-29'),
('E001-000589', 'Proveedor', 2, 5, false, '2025-06-01', '2025-06-30'),
('F001-00008979', 'ISP', 3, 5, true, '2025-05-01', '2025-05-28'),
('E001-000590', 'Proveedor', 3, 6, true, '2025-07-01', '2025-07-25'),
('F001-00008980', 'ISP', 1, 6, false, '2025-06-01', '2025-06-26');
