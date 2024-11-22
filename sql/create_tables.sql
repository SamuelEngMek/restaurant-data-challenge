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
    opnBusDt DATE,                         -- Data de abertura
    opnUTC TIMESTAMP,                      -- Hora de abertura UTC
    opnLcl TIMESTAMP,                      -- Hora de abertura local
    clsdBusDt DATE,                        -- Data de fechamento
    clsdUTC TIMESTAMP,                     -- Hora de fechamento UTC
    clsdLcl TIMESTAMP,                     -- Hora de fechamento local
    lastTransUTC TIMESTAMP,                -- Hora da última transação UTC
    lastTransLcl TIMESTAMP,                -- Hora da última transação local
    lastUpdatedUTC TIMESTAMP,              -- Hora da última atualização UTC
    lastUpdatedLcl TIMESTAMP,              -- Hora da última atualização local
    clsdFlag BOOLEAN,                      -- Pedido fechado?
    gstCnt INT,                            -- Contagem de convidados
    subTtl DECIMAL(10, 2),                 -- Subtotal da conta
    nonTxblSlsTtl DECIMAL(10, 2) DEFAULT NULL,  -- Total de vendas não tributáveis
    chkTtl DECIMAL(10, 2),                 -- Total da conta
    dscTtl DECIMAL(10, 2) DEFAULT 0,       -- Total de descontos
    payTtl DECIMAL(10, 2),                 -- Total pago
    balDueTtl DECIMAL(10, 2) DEFAULT NULL, -- Total devido
    rvcNum INT,                            -- Número de revisão
    otNum INT,                             -- Número de operação
    ocNum INT DEFAULT NULL,                -- Número de OC (caso exista)
    tblNum INT,                            -- Número da mesa
    tblName VARCHAR(50),                   -- Nome da mesa
    empNum INT,                            -- Número do empregado
    numSrvcRd INT,                         -- Número de rodadas de serviço
    numChkPrntd INT,                       -- Número de impressões do pedido
    locRef VARCHAR(50),                    -- FK para Restaurants
    FOREIGN KEY (locRef) REFERENCES Restaurants(locRef)
);

-- Tabela: Taxes
CREATE TABLE Taxes (
    taxId INT AUTO_INCREMENT PRIMARY KEY,  -- ID único do imposto
    guestCheckId BIGINT,                   -- FK para GuestChecks
    taxNum INT,                            -- Número do imposto
    txblSlsTtl DECIMAL(10, 2),             -- Total de vendas tributáveis
    taxCollTtl DECIMAL(10, 2),             -- Total de imposto recolhido
    taxRate DECIMAL(5, 2),                 -- Taxa do imposto
    type INT,                              -- Tipo do imposto
    FOREIGN KEY (guestCheckId) REFERENCES GuestChecks(guestCheckId)
);

-- Tabela: DetailLines
CREATE TABLE DetailLines (
    detailLineId BIGINT PRIMARY KEY,       -- ID único da linha do pedido
    guestCheckId BIGINT,                   -- FK para GuestChecks
    lineNum INT,                           -- Número da linha
    dtlOtNum INT,                          -- Número da operação de linha
    dtlOcNum INT DEFAULT NULL,             -- Número de OC da linha
    detailUTC TIMESTAMP,                   -- Hora detalhada UTC
    detailLcl TIMESTAMP,                   -- Hora detalhada local
    lastUpdateUTC TIMESTAMP,               -- Última atualização UTC
    lastUpdateLcl TIMESTAMP,               -- Última atualização local
    busDt DATE,                            -- Data do negócio
    wsNum INT,                             -- Número do trabalho
    dspTtl DECIMAL(10, 2),                 -- Total exibido
    dspQty INT,                            -- Quantidade exibida
    aggTtl DECIMAL(10, 2),                 -- Total agregado
    aggQty INT,                            -- Quantidade agregada
    chkEmpId INT,                          -- ID do empregado associado à linha
    chkEmpNum INT,                         -- Número do empregado associado à linha
    svcRndNum INT,                         -- Número da rodada de serviço
    seatNum INT,                           -- Número do assento
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
    modFlag BOOLEAN DEFAULT FALSE,                -- Flag de modificação (modificação do item)
    inclTax DECIMAL(10, 2),                       -- Imposto incluído no item
    activeTaxes VARCHAR(50),                      -- Impostos ativos relacionados ao item
    prcLvl INT,                                   -- Nível de preço
    FOREIGN KEY (detailLineId) REFERENCES DetailLines(detailLineId)
);


-- Tabela: ServiceCharge
CREATE TABLE ServiceCharge (
    serviceChargeId BIGINT PRIMARY KEY,         -- ID único da taxa de serviço
    detailLineId BIGINT,                        -- FK para DetailLines
    amount DECIMAL(10, 2),                      -- Valor da taxa de serviço
    FOREIGN KEY (detailLineId) REFERENCES DetailLines(detailLineId)
);

-- Tabela: TenderMedia
CREATE TABLE TenderMedia (
    tenderMediaId BIGINT PRIMARY KEY,           -- ID único do meio de pagamento
    detailLineId BIGINT,                        -- FK para DetailLines
    tenderMediaType VARCHAR(50),                -- Tipo de meio de pagamento (ex: 'Cartão', 'Dinheiro')
    amount DECIMAL(10, 2),                      -- Valor pago com esse meio de pagamento
    FOREIGN KEY (detailLineId) REFERENCES DetailLines(detailLineId)
);

-- Tabela: ErrorCode
CREATE TABLE ErrorCode (
    errorCodeId BIGINT PRIMARY KEY,            -- ID único do código de erro
    detailLineId BIGINT,                        -- FK para DetailLines
    errorCode INT,                              -- Código do erro
    description VARCHAR(255),                   -- Descrição do erro
    FOREIGN KEY (detailLineId) REFERENCES DetailLines(detailLineId)
);