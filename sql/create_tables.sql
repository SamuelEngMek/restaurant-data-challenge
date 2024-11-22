-- Criação do banco de dados
CREATE DATABASE RestaurantDB;
-- Seleção do banco de dados para uso
USE RestaurantDB;

-- Tabela: Restaurants
CREATE TABLE Restaurants (
    locRef VARCHAR(50) PRIMARY KEY,        -- Identificador único do restaurante
    name VARCHAR(100) NOT NULL             -- Nome do restaurante
);

-- Tabela: GuestChecks
CREATE TABLE GuestChecks (
    guestCheckId BIGINT PRIMARY KEY,       -- ID único do pedido
    chkNum INT,                            -- Número do pedido
    locRef VARCHAR(50),                    -- FK para o restaurante
    opnBusDt DATE,                         -- Data de abertura
    clsdBusDt DATE,                        -- Data de fechamento
    clsdFlag BOOLEAN,                      -- Pedido fechado?
    subTtl DECIMAL(10, 2),                 -- Subtotal da conta
    FOREIGN KEY (locRef) REFERENCES Restaurants(locRef)
);

-- Tabela: Taxes
CREATE TABLE Taxes (
    taxId INT AUTO_INCREMENT PRIMARY KEY,  -- ID único do imposto
    guestCheckId BIGINT,                   -- FK para GuestChecks
    taxNum INT,                            -- Número do imposto
    taxCollTtl DECIMAL(10, 2),             -- Total de imposto recolhido
    FOREIGN KEY (guestCheckId) REFERENCES GuestChecks(guestCheckId)
);

-- Tabela: DetailLines
CREATE TABLE DetailLines (
    detailLineId BIGINT PRIMARY KEY,       -- ID único da linha do pedido
    guestCheckId BIGINT,                   -- FK para GuestChecks
    lineNum INT,                           -- Número da linha
    dspTtl DECIMAL(10, 2),                 -- Total exibido
    FOREIGN KEY (guestCheckId) REFERENCES GuestChecks(guestCheckId)
);

-- Tabela: Discounts
CREATE TABLE Discounts (
    discountId BIGINT PRIMARY KEY,         -- ID do desconto
    detailLineId BIGINT,                   -- FK para DetailLines
    amount DECIMAL(10, 2),                  -- Valor do desconto
    FOREIGN KEY (detailLineId) REFERENCES DetailLines(detailLineId)
);

-- Tabela: MenuItems
CREATE TABLE MenuItems (
    menuItemId BIGINT AUTO_INCREMENT PRIMARY KEY,  -- ID do item do menu
    detailLineId BIGINT,                          -- FK para DetailLines
    miNum INT,                                    -- Número do item do menu
    FOREIGN KEY (detailLineId) REFERENCES DetailLines(detailLineId)
);
