-- Crear tabla Admins
CREATE TABLE admins (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Crear tabla Addresses
CREATE TABLE addresses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    address VARCHAR(255),
    district VARCHAR(255),
    province VARCHAR(255),
    department VARCHAR(255),
    sector VARCHAR(255)
);

-- Crear tabla ISPs
CREATE TABLE isps (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ruc VARCHAR(20),
    name VARCHAR(255) NOT NULL
);

-- Crear tabla Providers
CREATE TABLE providers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ruc VARCHAR(20),
    name VARCHAR(255) NOT NULL,
    logo VARCHAR(255)
);

-- Crear tabla AdminProvider
CREATE TABLE admin_providers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    provider_id INTEGER,
    admin_id INTEGER,
    FOREIGN KEY (provider_id) REFERENCES providers(id),
    FOREIGN KEY (admin_id) REFERENCES admins(id)
);

-- Crear tabla Companies
CREATE TABLE companies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    address_id INTEGER,
    ruc VARCHAR(20),
    name VARCHAR(255),
    FOREIGN KEY (address_id) REFERENCES addresses(id)
);

-- Crear tabla IspServices
CREATE TABLE isp_services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    isp_id INTEGER,
    provider_id INTEGER,
    description TEXT,
    cost FLOAT,
    pay_code VARCHAR(50),
    FOREIGN KEY (isp_id) REFERENCES isps(id),
    FOREIGN KEY (provider_id) REFERENCES providers(id)
);

-- Crear tabla Dependencies
CREATE TABLE dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    company_id INTEGER,
    provider_id INTEGER,
    name VARCHAR(255),
    sign_date DATE,
    validity_time VARCHAR(50),
    termination_date DATE,
    anniversary VARCHAR(50),
    equipment VARCHAR(255),
    FOREIGN KEY (company_id) REFERENCES companies(id),
    FOREIGN KEY (provider_id) REFERENCES providers(id)
);

-- Crear tabla Contacts
CREATE TABLE contacts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    dependency_id INTEGER,
    name VARCHAR(255),
    last_name VARCHAR(255),
    cellphone VARCHAR(20),
    rank VARCHAR(100),
    position VARCHAR(100),
    birthday DATE,
    FOREIGN KEY (dependency_id) REFERENCES dependencies(id)
);

-- Crear tabla ProviderServices
CREATE TABLE provider_services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    dependency_id INTEGER,
    provider_id INTEGER,
    description TEXT,
    price FLOAT,
    FOREIGN KEY (dependency_id) REFERENCES dependencies(id),
    FOREIGN KEY (provider_id) REFERENCES providers(id)
);

-- Crear tabla Invoices
CREATE TABLE invoices (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    invoice_number VARCHAR(50),
    service_type VARCHAR(255),
    service_id INTEGER,  
    invoice_month INTEGER,
    invoiced BOOLEAN,
    issue_date DATE,
    due_date DATE
);
