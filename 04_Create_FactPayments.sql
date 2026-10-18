USE OlistDW;
GO

CREATE TABLE dw.FactPayments (
    payment_key BIGINT IDENTITY(1,1) PRIMARY KEY,
    order_id VARCHAR(32) NOT NULL,
    payment_sequential INT NOT NULL,
    date_key INT NOT NULL,
    customer_key INT NOT NULL,
    payment_type VARCHAR(30) NOT NULL,
    payment_installments INT NOT NULL,
    payment_value DECIMAL(12,2) NOT NULL,

    CONSTRAINT UQ_FactPayments_OrderSequence
        UNIQUE (order_id, payment_sequential),

    CONSTRAINT FK_FactPayments_Date
        FOREIGN KEY (date_key) REFERENCES dw.DimDate(date_key),

    CONSTRAINT FK_FactPayments_Customer
        FOREIGN KEY (customer_key) REFERENCES dw.DimCustomer(customer_key)
);
GO