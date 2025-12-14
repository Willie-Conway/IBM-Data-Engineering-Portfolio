/* =========================================================
   Fashion‑Retail Mini Data‑Warehouse  (Star‑like staging)
   ========================================================= */

/* ----------  Dimension‑style tables  ---------- */

/* Employee */
CREATE TABLE Employee (
    employee_id     INT PRIMARY KEY,
    employee_name   VARCHAR(100),
    position        VARCHAR(60),
    department      VARCHAR(60)
);

/* Customer Profiles */
CREATE TABLE CustomerProfiles (
    customer_id     INT PRIMARY KEY,
    customer_name   VARCHAR(100),
    email           VARCHAR(120),
    address         VARCHAR(200),
    phone_number    VARCHAR(30)
);

/* Seller Information */
CREATE TABLE SellerInformation (
    seller_id       INT PRIMARY KEY,
    seller_name     VARCHAR(120),
    seller_type     VARCHAR(60)
);

/* Inventory (Products) */
CREATE TABLE Inventory (
    product_id      INT PRIMARY KEY,
    product_name    VARCHAR(120),
    price           DECIMAL(10,2),
    quantity        INT,
    employee_id     INT,
    seller_id       INT,
    /* Foreign keys */
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (seller_id)   REFERENCES SellerInformation(seller_id)
);

/* ----------  Fact‑style table  ---------- */

/* Sales Data */
CREATE TABLE SalesData (
    sale_id      INT PRIMARY KEY,
    sale_date    DATE,
    sale_amount  DECIMAL(12,2),
    employee_id  INT,
    customer_id  INT,
    product_id   INT,
    /* Foreign keys */
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (customer_id) REFERENCES CustomerProfiles(customer_id),
    FOREIGN KEY (product_id)  REFERENCES Inventory(product_id)
);

/* ----------  Helpful indexes for queries (optional) ---------- */
CREATE INDEX idx_sales_date      ON SalesData (sale_date);
CREATE INDEX idx_inventory_emp   ON Inventory (employee_id);
CREATE INDEX idx_sales_customer  ON SalesData (customer_id);
