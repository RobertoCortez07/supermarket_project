-- Creating the database
CREATE DATABASE supermarket;
-- Creating the table and importing the data from the CSV files

CREATE TABLE pos_transactions(
    id INT PRIMARY KEY,
    workstation_group_id INT,
    begin_date_time TIMESTAMP,
    end_date_time TIMESTAMP,
    operator_id INT,
    basket_size INT,
    t_cash BOOLEAN,
    t_card BOOLEAN,
    amount DECIMAL(10,2)
);

\\copy public.pos_transactions (id, workstation_group_id, begin_date_time, end_date_time, operator_id, basket_size, t_cash, t_card, amount) FROM '...supermarket_project/pos_transactions.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8' QUOTE '\"' ESCAPE '''';

-- Task 1: Do people make more transactions with cash or card?
SELECT
    COUNT(CASE WHEN t_cash THEN 1 END) AS cash_transactions,
    COUNT(CASE WHEN t_card THEN 1 END) AS card_transactions
FROM pos_transactions;

-- Task 2: Do people spend more money per transaction with cash or card?
SELECT
    AVG(CASE WHEN t_cash AND NOT t_card THEN amount END) AS avg_cash_transactions,
    AVG(CASE WHEN t_card AND NOT t_cash THEN amount END) AS avg_card_transactions
FROM pos_transactions;

-- Task 4: Which day of the week has the most transactions in 2019?
SELECT
    COUNT(*) AS transactions,
    EXTRACT(DOW FROM begin_date_time) AS day_of_week
FROM pos_transactions
WHERE EXTRACT(YEAR FROM begin_date_time) = 2019
GROUP BY day_of_week
ORDER BY transactions DESC;
-- NOTE: Sunday(0) has the least transactions because supermarkets are closed for 2 sundays during the month

-- Task 5: What is the total and average amount spent per day of the week in 2019?
SELECT
    SUM(amount) AS total_amount,
    AVG(amount) AS avg_amount,
    EXTRACT(DOW FROM begin_date_time) AS day_of_week
FROM pos_transactions
WHERE EXTRACT(YEAR FROM begin_date_time) = 2019
GROUP BY day_of_week;
--NOTE: While Sunday has the least transactions and least total amount spent, it does not have the least average amount spent.

-- Task 6: What is the total revenue per week in 2019?
SELECT
    SUM(amount) AS total_revenue,
    EXTRACT(WEEK FROM begin_date_time) AS week
FROM pos_transactions
WHERE EXTRACT(YEAR FROM begin_date_time) = 2019
GROUP BY week;
