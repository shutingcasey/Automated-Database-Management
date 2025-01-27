-- ***********************
-- Name : SHUTING HSU
-- Student ID :133505222
-- Oracle ID : dbs311_242nee07
-- ***********************

-- CREATE PRODUCTshutinghsu table
CREATE TABLE PRODUCTshutinghsu (
    prod_no NUMBER(5) PRIMARY KEY,
    qty NUMBER(10)
);

-- Insert data into PRODUCTshutinghsu
INSERT INTO PRODUCTshutinghsu (prod_no, qty)
SELECT prod_no, qoh
FROM products;

-- CREATE DAILYRUNshutinghsu table
CREATE TABLE DAILYRUNshutinghsu (
    product_no NUMBER(5),
    action CHAR(1),
    amount NUMBER(4),
    whendate DATE,
    status VARCHAR2(50)
);

-- Insert data into DAILYRUNshutinghsu
INSERT INTO DAILYRUNshutinghsu (product_no, action, amount, whendate, status)
VALUES (40100, 'U', 74, TO_DATE('2024-03-01', 'YYYY-MM-DD'), NULL);

INSERT INTO DAILYRUNshutinghsu (product_no, action, amount, whendate, status)
VALUES (40101, 'U', 11, TO_DATE('2024-03-01', 'YYYY-MM-DD'), NULL);

INSERT INTO DAILYRUNshutinghsu (product_no, action, amount, whendate, status)
VALUES (40102, 'U', 20, TO_DATE('2024-04-01', 'YYYY-MM-DD'), NULL);

INSERT INTO DAILYRUNshutinghsu (product_no, action, amount, whendate, status)
VALUES (60302, 'U', 650, TO_DATE('2024-04-01', 'YYYY-MM-DD'), NULL);

INSERT INTO DAILYRUNshutinghsu (product_no, action, amount, whendate, status)
VALUES (40100, 'I', -4, TO_DATE('2024-04-03', 'YYYY-MM-DD'), NULL);

INSERT INTO DAILYRUNshutinghsu (product_no, action, amount, whendate, status)
VALUES (40100, 'I', 10, TO_DATE('2024-04-05', 'YYYY-MM-DD'), NULL);

INSERT INTO DAILYRUNshutinghsu (product_no, action, amount, whendate, status)
VALUES (60302, 'I', 20, TO_DATE('2024-04-06', 'YYYY-MM-DD'), NULL);

INSERT INTO DAILYRUNshutinghsu (product_no, action, amount, whendate, status)
VALUES (60303, 'I', 10, TO_DATE('2024-04-02', 'YYYY-MM-DD'), NULL);

INSERT INTO DAILYRUNshutinghsu (product_no, action, amount, whendate, status)
VALUES (40105, 'I', 30, TO_DATE('2024-04-02', 'YYYY-MM-DD'), NULL);

INSERT INTO DAILYRUNshutinghsu (product_no, action, amount, whendate, status)
VALUES (40105, 'I', -10, TO_DATE('2024-04-02', 'YYYY-MM-DD'), NULL);

INSERT INTO DAILYRUNshutinghsu (product_no, action, amount, whendate, status)
VALUES (40103, 'U', 0, TO_DATE('2024-04-01', 'YYYY-MM-DD'), NULL);

INSERT INTO DAILYRUNshutinghsu (product_no, action, amount, whendate, status)
VALUES (40103, 'D', NULL, TO_DATE('2024-04-02', 'YYYY-MM-DD'), NULL);

INSERT INTO DAILYRUNshutinghsu (product_no, action, amount, whendate, status)
VALUES (50100, 'X', 99, TO_DATE('2024-04-01', 'YYYY-MM-DD'), NULL);

INSERT INTO DAILYRUNshutinghsu (product_no, action, amount, whendate, status)
VALUES (50100, 'D', NULL, TO_DATE('2024-04-02', 'YYYY-MM-DD'), NULL);

-- In the action column 
DECLARE
    v_qty PRODUCTshutinghsu.qty%TYPE;
    v_status VARCHAR2(50);
BEGIN
    FOR i IN (SELECT * FROM DAILYRUNshutinghsu) LOOP
        -- Check "U" update
        IF i.action = 'U' THEN
            BEGIN
                -- Changes the qty to this new value
                SELECT qty INTO v_qty FROM PRODUCTshutinghsu WHERE prod_no = i.product_no;
                UPDATE PRODUCTshutinghsu
                SET qty = i.amount
                WHERE prod_no = i.product_no;
                v_status := 'Updated qty to ' || i.amount; -- assign a value to a variable
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    -- If the product number does not exist, it is created by an insert
                    INSERT INTO PRODUCTshutinghsu (prod_no, qty)
                    VALUES (i.product_no, i.amount);
                    v_status := 'Inserted new product with qty ' || i.amount;
            END;
            
            -- Check "D" update
        ELSIF i.action = 'D' THEN
            BEGIN
                -- delete 
                DELETE FROM PRODUCTshutinghsu
                WHERE prod_no = i.product_no;
                
                -- Check if no rows were affected by the previous SQL statement
                -- 0 means not found in the data table, which means that the ID does not exist in the table
                IF SQL%ROWCOUNT = 0 THEN
                    v_status := 'Delete not done, ID does not exist';
                ELSE
                    v_status := 'Deleted product ' || i.product_no;
                END IF;
            END;
            
         -- Check "I" changed   
        ELSIF i.action = 'I' THEN
            BEGIN
                -- Try increasing or decreasing the qty of an existing product
                SELECT qty INTO v_qty FROM PRODUCTshutinghsu WHERE prod_no = i.product_no;
                IF i.amount > 0 THEN
                    UPDATE PRODUCTshutinghsu
                    SET qty = qty + i.amount
                    WHERE prod_no = i.product_no;
                    v_status := 'Increased qty by ' || i.amount;
                ELSE
                    UPDATE PRODUCTshutinghsu
                    SET qty = qty + i.amount
                    WHERE prod_no = i.product_no;
                    v_status := 'Decreased qty by ' || i.amount;
                END IF;
            EXCEPTION
            -- If product number does not exist 
                WHEN NO_DATA_FOUND THEN
                    -- amount is positive give a status do an insert
                    IF i.amount > 0 THEN
                        INSERT INTO PRODUCTshutinghsu (prod_no, qty)
                        VALUES (i.product_no, i.amount);
                        v_status := 'Inserted new product with qty ' || i.amount;
                    ELSE
                        v_status := 'Insert not done, negative amount for new product';
                    END IF;
            END;
        ELSE
            v_status := 'Incorrect operation code';
        END IF;

        -- Update DAILYRUNshutinghsu's status
        UPDATE DAILYRUNshutinghsu
        SET status = v_status
        WHERE product_no = i.product_no AND whendate = i.whendate;
    END LOOP;
END;
/

-- check the result
Select * from PRODUCTshutinghsu;
Select * from DAILYRUNshutinghsu;

-- demonstrate
SELECT * FROM PRODUCTshutinghsu WHERE prod_no = 40100;
SELECT * FROM DAILYRUNshutinghsu WHERE product_no = 40100;
-- U is for update.
    --	If the product number already exists. The update changes the qty to this new value.
    INSERT INTO DAILYRUNshutinghsu (product_no, action, amount, whendate, status)
    VALUES (40100, 'U', 90, TO_DATE('2024-03-01', 'YYYY-MM-DD'), NULL);  
        -- Check the result
        SELECT * FROM DAILYRUNshutinghsu WHERE product_no = 40100;
    
    -- if the product number does not exist, it is created by an insert.
    INSERT INTO DAILYRUNshutinghsu (product_no, action, amount, whendate, status)
    VALUES (60100, 'U', 100, TO_DATE('2024-03-01', 'YYYY-MM-DD'), NULL);   
        -- Check the result
        SELECT * FROM PRODUCTshutinghsu WHERE prod_no = 60100;
        SELECT * FROM DAILYRUNshutinghsu WHERE product_no = 60100;

COMMIT;