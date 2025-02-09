![databel_project](https://gckarchive.com/wp-content/uploads/2025/02/databel-project-photo.png)

# Optimizing-Telecom-Data-Management-through-Database-Normalization
TASKS: database design, star schema, table normalizaton (1NF), live MySQL/PHP server

# Overview

Databel is a ficticious telecom company, which initially stored all its customer data in a single table with 49 columns, which made data management inefficient and difficult to scale.

This project aimed to optimize the database structure by normalizing the database, creating dimension tables, and restructuring the main table(databel_db) into a fact table following a star schema design. The objective was to proactively ensure data integrity, reduce redundancy, and enhance scalability for better db management, analytics and reporting.

# Problem Statement

* Data updates were inefficient with multiple records to update in the event of a change, leading to possible integrity issues.
* The existing single-table structure caused data redundancy.
* OLTP (Online Transaction Processing) query performance was slow due to large dataset scans.

# Solution Approach

* The database was normalized to 1st Normal Form (1NF) for proper attribute dependencies.
* The single table was restructured to serve as a fact table, and split into dimension tables based on logical groupings (e.g., Subscriptions, Usage, Support, etc.).
* Surrogate keys (Auto Increment IDs) were introduced in dimension tables to ensure uniqueness of each record.
* Primary and foreign keys constraints were established for table connections & data

# Tools Used

* MySQL / PHPmyAdmin database
* MySQL workbench
* Live Hostinger server

# Project Structure

The project was executed in six key phases:

### 1. Database Design & Normalization:
The single large table (databel_db) was split into dimension tables based on logical groupings:
* add_customer_info (basic customer details)
* cust_subscription (plan details)
* billing (payment records)
* payments (dates of payments records)
* customer_status (account status records)
* service_usage (data, voice, and SMS usage)
* customer_support (support interactions)
* contract_info (contract dates, types and terms)
* churn_info (customer retention and churn reasons)

![normalized_tables](https://gckarchive.com/wp-content/uploads/2025/02/Databel-Pro-768x432.jpg)

### 2. Inserting Values into Dimension Tables

Various data from (databel_db) table was extracted and distinct values inserted into respective dimension tables, to harmonize customers data attributes, ensuring consistency and integrity:

```sql
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
```

### 3. Restructuring of Main Table into a Fact Table

The original (databel_db) table was transformed to serve as a fact table and renamed to (customers)

New id columns, which contains surrogate keys, was created to enable linking all dimension tables, retaining only key identifiers and measurable attributes in the fact table:

```sql
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
```

### 4. Defining Foreign Keys & Populating Key Values
Foreign key relationships were established between customers (fact table) and the dimension tables, ensuring referential consistency.

The customers table id columns was then populated with foreign key references to link to related dimension tables:

```sql
-- Part 4: defining all Foreign keys & inserting of values

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

SELECT * FROM customers;
```

### 4. Removing Redundant Columns
After completion of normalization (1NF), redundant columns were removed from the customers table, to reduce duplicate records existing in both fact and dimension tables, leaving only the necessary foreign keys and fact data:

```sql
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
```

### 5. Modeling in MySQL Workbench
The final database model structure was designed using MySQL Workbench in a star schema format, optimizing it for efficient querying and reporting, establishing the appropriate relationship between fact and dimension tables:
![data model](https://gckarchive.com/wp-content/uploads/2025/02/Databel_-data-model-view-after-768x432.jpg)

NB: The complete queries for each steps taken are on the sql file attached

# Summary:

* Reduced Data Redundancy: Normalization helped eliminate duplicate data, improving storage efficiency.
* Improved Query Performance: Breaking data into fact and dimension tables resulted to faster and more structured queries.
* Better Data Integrity: No need for updating multiple rows in the event of a change of a contract terms or other attributes by the company.
* Scalability: The new star schema design has made it easier to extend the database as the business continues to grow.
* Enhanced Data Analysis: The new structure makes it easy to understand the db architecture, simplifying reporting and analytics, crucial for business intelligence.

see attached photos (before: table & model, after: normalized tables model after)

# Links & Others

This project is part of my stellar portfolio projects, showcasing my data modelling and DBA skills essential for any data role. If you have any questions, or feedback, or would like to collaborate, feel free to get in touch.


