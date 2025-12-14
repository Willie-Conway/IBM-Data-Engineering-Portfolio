-- Customer Table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Address VARCHAR(100),
    Phone VARCHAR(20),
    Email VARCHAR(50)
);

-- Inventory Table
CREATE TABLE Inventory (
    StockCode INT PRIMARY KEY,
    Description VARCHAR(100),
    QuantityAvailable INT,
    Price DECIMAL(10, 2)
);

-- Transaction Invoice Table
CREATE TABLE TransactionInvoice (
    InvoiceNo INT PRIMARY KEY,
    StockCode INT,
    Quantity INT,
    InvoiceDate DATE,
    UnitPrice DECIMAL(10, 2),
    CustomerID INT,
    Country VARCHAR(50),
    FOREIGN KEY (StockCode) REFERENCES Inventory(StockCode),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
