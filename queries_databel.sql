-- Databel Telecom : PROJECT TASKS
-- Part 1: normalization & creation of dimension tables
-- Part 2: inserting of values into dimension tables from the main table(databel_db)
-- Part 3: restructing of main db(databel_db) to serve as fact table and renamed to 'customers'
-- Part 4: defining of Foreign keys & inserting of values
-- Part 5: remove/drop redundant columns from fact table (customers)
-- Part 6: data base design (star schema) & modelling - mysql workbench


-- Part 1: normalization & creation of dimension tables

-- *Additional customer table (dimension)
DROP TABLE IF EXISTS add_cust_info;
CREATE TABLE add_cust_info
        (
            id INT AUTO_INCREMENT PRIMARY KEY,
            billing_address VARCHAR(75),
            account_number VARCHAR(20),
            created_at DATE,
            updated_at DATE
        );

SELECT * FROM add_cust_info;

-- *Customer status table (dimension)
DROP TABLE IF EXISTS customer_status;
CREATE TABLE customer_status
        (
            status_id INT AUTO_INCREMENT PRIMARY KEY,
            customer_status	VARCHAR(15),
            churn_label VARCHAR(10),
            churn_category VARCHAR(20),
            churn_reason VARCHAR(35)
        );

SELECT * FROM customer_status;

-- *Subscription table (dimension)
DROP TABLE IF EXISTS cust_subscription;
CREATE TABLE cust_subscription
        (
            sub_id INT AUTO_INCREMENT PRIMARY KEY,
            subscription_plan VARCHAR(15),
            plan_start_date DATE,
            plan_expiry_date DATE,
            balance FLOAT,
            data_balance FLOAT,
            voice_minutes_balance FLOAT,
            sms_balance FLOAT
        );

SELECT * FROM cust_subscription; 

-- *Service Usage table (dimension)
DROP TABLE IF EXISTS service_usage;
CREATE TABLE service_usage
        (
            usage_id INT AUTO_INCREMENT PRIMARY KEY,
            local_calls INT,
            local_mins FLOAT,
            intl_calls INT,
            intl_mins FLOAT,
            extra_international FLOAT,
            avg_monthly_gb_download INT,
            total_data_used FLOAT,
            total_voice_minutes FLOAT,
            total_sms_sent INT
        );

SELECT * FROM service_usage;

-- *Payment table (dimension)
DROP TABLE IF EXISTS payments;
CREATE TABLE payments
        (
            payment_id INT AUTO_INCREMENT PRIMARY KEY,
            payment_method VARCHAR(15),
            last_payment_date DATE,
            last_payment_amount FLOAT
        );

SELECT * FROM payments;

-- *Contract information table (dimension)
DROP TABLE IF EXISTS contract_info;
CREATE TABLE contract_info 
        (
            contract_id INT AUTO_INCREMENT PRIMARY KEY,
            contract_type VARCHAR(15),
            number_of_customers_in_group INT,
            cust_group VARCHAR(5),
            device_protection_and_online_backup VARCHAR(5)
        );
SELECT * FROM contract_info;

-- *Billing table (dimension)
DROP TABLE IF EXISTS billing;
CREATE TABLE billing
        (
            id INT AUTO_INCREMENT PRIMARY KEY,
            monthly_charge INT,
            total_charges INT
        );

SELECT * FROM billing;

-- *Churn information table (dimension)
DROP TABLE IF EXISTS churn_info;
CREATE TABLE churn_info
        (
            churn_id INT AUTO_INCREMENT PRIMARY KEY,
            churn_label VARCHAR(10),
            churn_category VARCHAR(20),
            churn_reason VARCHAR(35)
        );

SELECT * FROM churn_info;

-- *Customer Support table (dimension)
DROP TABLE IF EXISTS customer_support;
CREATE TABLE customer_support
        (
            support_id INT AUTO_INCREMENT PRIMARY KEY,
            charges_customer_service_calls INT
        );

SELECT * FROM customer_support;


-- Part 2: inserting of values into dimension tables from the main table(databel_db)

-- **Inserting of values (add_cust_info)
INSERT INTO add_cust_info  
        (
            billing_address, 
            account_number, 
            created_at, 
            updated_at
        )
SELECT 
            DISTINCT billing_address, 
            account_number, 
            created_at, 
            updated_at
FROM databel_db AS db;

-- **Inserting of values (customer_status)
INSERT INTO customer_status 
        (
            customer_status, 
            churn_label, 
            churn_category, 
            churn_reason
        )
SELECT 
            DISTINCT customer_status, 
            churn_label, 
            churn_category, 
            churn_reason
FROM databel_db AS db;

-- **Inserting of values (cust_subscription)
INSERT INTO cust_subscription 
        (
            subscription_plan, 
            plan_start_date, 
            plan_expiry_date, 
            balance, 
            data_balance, 
            voice_minutes_balance, 
            sms_balance
        )
SELECT 
            DISTINCT subscrition_plan, 
            plan_start_date, 
            plan_expiry_date, 
            balance, 
            data_balance, 
            voice_minutes_balance, 
            sms_balance
FROM databel_db;

-- **Inserting of values (service_usage)
INSERT INTO service_usage 
        (
            local_calls, 
            local_mins, 
            intl_calls, 
            intl_mins, 
            extra_international, 
            avg_monthly_gb_download, 
            total_data_used, 
            total_voice_minutes, 
            total_sms_sent
        )
SELECT 
            DISTINCT local_calls, 
            local_mins, 
            intl_calls, 
            intl_mins, 
            extra_international, 
            avg_monthly_gb_download, 
            total_data_used, 
            total_voice_minutes, 
            total_sms_sent
FROM databel_db AS db;


-- **Inserting of values (payments)
INSERT INTO payments 
        (
            payment_method, 
            last_payment_date, 
            last_payment_amount
        )
SELECT 
            DISTINCT payment_method, 
            last_payment_date, 
            last_payment_amount
FROM databel_db;

-- **Inserting of values (contract_info)
INSERT INTO contract_info 
        (
            contract_type, 
            number_of_customers_in_group, 
            cust_group, 
            device_protection_and_online_backup
        )
SELECT 
            DISTINCT contract_type, 
            number_of_customers_in_group, 
            cust_group, 
            device_protection_and_online_backup
FROM databel_db;

-- **Inserting of values (billing)
INSERT INTO billing 
        (
            monthly_charge, 
            total_charges
        )
SELECT 
            DISTINCT monthly_charge, 
            total_charges
FROM databel_db AS db;

-- **Inserting of values (churn_info)
INSERT INTO churn_info 
        (
            churn_label, 
            churn_category, 
            churn_reason
        )
SELECT 
            DISTINCT churn_label, 
            churn_category, 
            churn_reason
FROM databel_db;

-- **Inserting of values (customer_support)
INSERT INTO customer_support 
        (
            charges_customer_service_calls
        )
SELECT 
            DISTINCT charges_customer_service_calls
FROM databel_db;


-- Part 3: restructing of main table(databel_db) to serve as fact table and renamed to 'customers'

-- *** Creation of id columns in main table to link dimension tables
ALTER TABLE databel_db
ADD COLUMN additional_cust_id INT, -- (add_cust_info table)
ADD COLUMN status_id INT, -- (customer_status)
ADD COLUMN sub_id INT, -- (cust_subscription)
ADD COLUMN usage_id INT, -- (service_usage)
ADD COLUMN payment_id INT, -- (payments)
ADD COLUMN contract_id INT, -- (contract_info)
ADD COLUMN billing_id INT, -- (billing)
ADD COLUMN churn_id INT, -- (churn_info)
ADD COLUMN support_id INT; -- (customer support)

SELECT * FROM databel_db;

-- *** Rename main table(databel_db) to customers
ALTER TABLE databel_db
RENAME TO customers;

SELECT * FROM customers;


-- Part 4: defining of Foreign keys & inserting of values

-- **** Defining all keys
ALTER TABLE customers
Add PRIMARY KEY(customer_id);

ALTER Table customers
ADD CONSTRAINT fk_add_cust_info FOREIGN KEY (additional_cust_id) 
    REFERENCES add_cust_info(id),
ADD CONSTRAINT fk_customer_status FOREIGN KEY (status_id) 
    REFERENCES customer_status(status_id),
ADD CONSTRAINT fk_cust_subscription FOREIGN KEY (sub_id) 
    REFERENCES cust_subscription(sub_id),
ADD CONSTRAINT fk_service_usage FOREIGN KEY (usage_id) 
    REFERENCES service_usage(usage_id),
ADD CONSTRAINT fk_payments FOREIGN KEY (payment_id) 
    REFERENCES payments(payment_id),
ADD CONSTRAINT fk_contract_info FOREIGN KEY (contract_id) 
    REFERENCES contract_info(contract_id),
ADD CONSTRAINT fk_billing FOREIGN KEY (billing_id) 
    REFERENCES billing(id),
ADD CONSTRAINT fk_churn_info FOREIGN KEY (churn_id) 
    REFERENCES churn_info(churn_id),
ADD CONSTRAINT fk_customer_support FOREIGN KEY (support_id) 
    REFERENCES customer_support(support_id);

SELECT * FROM customers;

-- **** Updating all FK columns with data from their respective dimension table.
-- Query max out time, so update table individually
UPDATE customers AS c
JOIN add_cust_info AS aci 
    ON c.billing_address = aci.billing_address
SET c.additional_cust_id = aci.id;

UPDATE customers AS c
JOIN customer_status AS cs 
    ON c.customer_status = cs.customer_status
SET c.status_id = cs.status_id;

UPDATE customers AS c
JOIN cust_subscription AS cs1 
    ON c.subscrition_plan = cs1.subscription_plan
SET c.sub_id = cs1.sub_id;

UPDATE customers AS c
JOIN service_usage AS su 
    ON c.local_calls = su.local_calls
SET c.usage_id = su.usage_id;

UPDATE customers AS c
JOIN payments AS p 
    ON c.payment_method = p.payment_method
SET c.payment_id = p.payment_id;

UPDATE customers AS c
JOIN contract_info AS ci 
    ON c.contract_type = ci.contract_type
SET c.contract_id = ci.contract_id;

UPDATE customers AS c
JOIN billing AS b 
    ON c.monthly_charge = b.monthly_charge
SET c.billing_id = b.id;

UPDATE customers AS c
JOIN churn_info AS ci1
    ON c.churn_label = ci1.churn_label
SET c.churn_id = ci1.churn_id;

UPDATE customers AS c
JOIN customer_support AS cs2
    ON c.charges_customer_service_calls = cs2.charges_customer_service_calls
SET c.support_id = cs2.support_id;

SELECT * FROM customers;

-- Part 5: remove/drop redundant columns from fact table (customers)
ALTER TABLE customers
DROP COLUMN churn_label, DROP COLUMN account_length_in_months, DROP COLUMN local_calls,
DROP COLUMN local_mins, DROP COLUMN intl_calls, DROP COLUMN intl_mins,
DROP COLUMN intl_active, DROP COLUMN intl_plan, DROP COLUMN extra_international,
DROP COLUMN charges_customer_service_calls, DROP COLUMN avg_monthly_gb_download, DROP COLUMN unlimited_data_plan,
DROP COLUMN extra_data_charges, DROP COLUMN under_30, DROP COLUMN senior,
DROP COLUMN cust_group, DROP COLUMN number_of_customers_in_group, DROP COLUMN device_protection_and_online_backup,
DROP COLUMN contract_type, DROP COLUMN payment_method, DROP COLUMN monthly_charge,
DROP COLUMN total_charges, DROP COLUMN churn_category, DROP COLUMN churn_reason,
DROP COLUMN account_number, DROP COLUMN subscrition_plan, DROP COLUMN plan_start_date,
DROP COLUMN plan_expiry_date, DROP COLUMN balance, DROP COLUMN data_balance,
DROP COLUMN voice_minutes_balance, DROP COLUMN sms_balance, DROP COLUMN billing_address,
DROP COLUMN last_payment_date, DROP COLUMN last_payment_amount, DROP COLUMN total_data_used,
DROP COLUMN total_voice_minutes, DROP COLUMN total_sms_sent, DROP COLUMN customer_status,
DROP COLUMN created_at, DROP COLUMN updated_at;

SELECT * FROM customers;


-- THE END 
