create database 2New_SMS;
use 2New_SMS;

-- drop database 2New_SMS;

show tables;
CREATE TABLE Company_Database (
    Stock_Name VARCHAR(255) NOT NULL,
    Price FLOAT NOT NULL CHECK (Price > 0),
    Password INTEGER NOT NULL,
    Qt INT NOT NULL CHECK (Qt >= 0) DEFAULT 0,
    Listed TINYINT(1) NOT NULL,
    PE FLOAT NOT NULL,
    EPS FLOAT NOT NULL,
    ROE FLOAT NOT NULL,
    GSTIN BIGINT NOT NULL, -- Changed from LONG to BIGINT
    Stock_ID INTEGER NOT NULL,
    PRIMARY KEY (GSTIN, Stock_ID)
);

select * from company_database;

CREATE INDEX idx_company_stock_id ON Company_Database (Stock_ID);

INSERT INTO Company_Database (Stock_Name, Price, PE, EPS, ROE, Password, GSTIN, Stock_ID, Listed, Qt)
VALUES 
('Reliance Industries Ltd.', 2400, 20.5, 117, 12.8, 123456, 1234567890, 1, 1, 12500),
('Tata Consultancy Services', 3500, 28.3, 123, 24.1, 654321, 9876543210, 2, 0, 15000),
('Infosys Ltd.', 1600, 25.9, 62, 18.7, 987654, 1357924680, 3, 1, 13000),
('HDFC Bank Ltd.', 1400, 30.2, 46, 15.3, 456789, 2468013579, 4, 0, 16000),
('ICICI Bank Ltd.', 700, 18.6, 38, 11.2, 234567, 1975308642, 5, 0, 14000),
('Bharti Airtel Ltd.', 600, 22.4, 27, 9.8, 876543, 8024691357, 6, 0, 17000),
('Hindustan Unilever Ltd.', 2300, 31.5, 73, 21.6, 345678, 3802465179, 7, 1, 13500),
('State Bank of India', 300, 15.7, 19, 7.5, 567890, 9517530862, 8, 1, 15500),
('Larsen & Toubro Ltd.', 1800, 24.8, 68, 16.2, 901234, 5647382910, 9, 0, 14500),
('Kotak Mahindra Bank Ltd.', 1600, 32.1, 50, 19.4, 789012, 3189276045, 10, 1, 16500),
('Axis Bank Ltd.', 900, 19.5, 46, 12.6, 321456, 9076543218, 11, 0, 12000),
('Wipro Ltd.', 450, 20.3, 22, 8.9, 654123, 6598270431, 12, 1, 18000),
('Maruti Suzuki India Ltd.', 8000, 35.9, 223, 26.8, 987145, 8745129360, 13, 0, 11500),
('Mahindra & Mahindra Ltd.', 900, 22.7, 39, 13.4, 456198, 3456978120, 14, 1, 18500),
('Housing Development Finance', 2800, 29.8, 94, 18.9, 234547, 9268715403, 15, 1, 11000),
('Bajaj Finance Ltd.', 5500, 40.2, 137, 31.6, 876345, 4321876950, 16, 1, 17500),
('Titan Company Ltd.', 1600, 50.8, 31, 22.4, 345278, 2190837465, 17, 0, 10500),
('UltraTech Cement Ltd.', 4800, 28.5, 168, 19.8, 567457, 7891032456, 18, 0, 19000),
('Nestle India Ltd.', 18000, 62.1, 289, 32.7, 901456, 1078945623, 19, 0, 10000),
('Asian Paints Ltd.', 2500, 45.6, 55, 27.9, 789256, 9042513768, 20, 1, 19500),
('HCL Technologies Ltd.', 1200, 23.4, 51, 18.5, 321856, 7830912456, 21, 1, 14500),
('Tech Mahindra Ltd.', 1000, 19.8, 39, 15.6, 654823, 4092571836, 22, 1, 13000),
('Sun Pharmaceutical Industries', 700, 15.6, 45, 10.8, 987568, 1873924056, 23, 0, 16000),
('Power Grid Corporation of India', 200, 10.2, 19, 8.1, 456356, 9301852476, 24, 1, 12500),
('Tata Steel Ltd.', 800, 12.7, 63, 11.2, 234657, 5789410236, 25, 1, 17000);



CREATE TABLE IPO_Apply (
    User_Id INT,
    Stock_ID INT,
    Price FLOAT,
    Qt INT,
    Total_Cost FLOAT AS (Price * Qt),
    PRIMARY KEY (User_ID, Stock_ID),
    FOREIGN KEY (Stock_ID) REFERENCES Company_Database(Stock_ID)
);



DELIMITER $$
CREATE TRIGGER insert_ipo_apply_values
BEFORE INSERT ON IPO_Apply
FOR EACH ROW
BEGIN
    DECLARE company_price FLOAT;
    DECLARE company_qt INT;

    SELECT Price, Qt INTO company_price, company_qt
    FROM Company_Database
    WHERE Stock_ID = NEW.Stock_ID;

    SET NEW.Price = company_price;
    SET NEW.Qt = company_qt;
END$$
DELIMITER ;


INSERT INTO IPO_Apply (User_Id, Stock_ID)
VALUES
    (1234, 1),
    (5678, 2),
    (9012, 3),
    (3456, 4),
    (7890, 5),
    (2345, 6),
    (6789, 7),
    (1236, 8),
    (4567, 9),
    (8901, 10);

select * from ipo_apply;

DELIMITER $$
CREATE PROCEDURE DeleteListedStocksFromIPOApply()
BEGIN
    DELETE ia
    FROM IPO_Apply AS ia
    INNER JOIN Company_Database AS cd ON ia.Stock_ID = cd.Stock_ID
    WHERE cd.Listed = 1;
END$$

DELIMITER ;
CALL DeleteListedStocksFromIPOApply();


select * from IPO_Apply;

    

CREATE TABLE IPO_Admin (
    User_ID INT NOT NULL,
    Stock_ID INT NOT NULL,
    Stock_Name VARCHAR(255) NOT NULL,
    Bid_Price FLOAT(10, 2) NOT NULL,
    Qt INT NOT NULL,
    Status BOOLEAN NOT NULL DEFAULT(0),
    PRIMARY KEY (User_ID, Stock_ID),
    FOREIGN KEY (Stock_ID) REFERENCES Company_Database(Stock_ID),
    FOREIGN KEY (User_ID) REFERENCES IPO_Apply(User_ID)
);



-- INSERT INTO IPO_Admin (User_ID, Stock_ID, Stock_Name, Bid_Price, Qt, Status)
-- SELECT ia.User_ID, ia.Stock_ID, cd.Stock_Name, cd.Price AS Bid_Price, ia.Qt, 0 AS Status
-- FROM IPO_Apply AS ia
-- JOIN Company_Database AS cd ON ia.Stock_ID = cd.Stock_ID;




-- drop trigger UpdateIPOAdminRegularly;

DELIMITER $$
CREATE PROCEDURE UpdateIPOAdminRegularly()
BEGIN
    INSERT INTO IPO_Admin (User_ID, Stock_ID, Stock_Name, Bid_Price, Qt)
    SELECT ia.User_ID, ia.Stock_ID, cd.Stock_Name, ia.Price, ia.Qt
    FROM IPO_Apply AS ia
    JOIN Company_Database AS cd ON ia.Stock_ID = cd.Stock_ID
    WHERE NOT EXISTS (
        SELECT 1 FROM IPO_Admin
        WHERE User_ID = ia.User_ID AND Stock_ID = ia.Stock_ID
    );
END$$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER UpdateIPOAdminAfterInsert
AFTER INSERT ON IPO_Apply
FOR EACH ROW
BEGIN
    CALL UpdateIPOAdminRegularly();
END$$
DELIMITER ;

select * from ipo_apply;

INSERT INTO IPO_Apply (User_Id, Stock_ID)
VALUES (1234, 2);

select * from ipo_admin;



INSERT INTO IPO_Apply (User_Id, Stock_ID)
VALUES (1234, 9);



CREATE TABLE user_database (
    User_Id INTEGER PRIMARY KEY,
    Password INTEGER,
    Portfolio_Id INTEGER UNIQUE,
    PAN INTEGER UNIQUE,
    Phone_Number BIGINT UNIQUE,
    Name VARCHAR(255)
);

INSERT INTO user_database (User_Id, Portfolio_Id, Phone_Number, PAN, Password, Name)
VALUES 
(1234, 12345, 7890123456, 12345, 1234567, 'Priya'),
(5678, 67890, 8123456789, 23456, 2345678, 'Rohan'),
(9012, 23456, 9123456780, 34567, 3456789, 'Aisha'),
(3456, 78901, 7123456790, 45678, 4567890, 'Vikram'),
(7890, 34567, 8123456791, 56789, 5678901, 'Nisha'),
(2345, 90123, 9123456792, 67890, 6789012, 'Siddharth'),
(6789, 45678, 6123456793, 78901, 7890123, 'Pooja'),
(1236, 1234, 7123456794, 89012, 8901234, 'Raj'),
(4567, 56789, 8123456795, 90123, 9012345, 'Neha'),
(8901, 12346, 9123456796, 1234, 123456, 'Arjun'),
(2109, 67891, 6123456797, 13579, 1357924, 'Aarav'),
(8765, 23457, 7123456798, 24680, 2468013, 'Priyanka'),
(5430, 78902, 8123456799, 35791, 246915, 'Ananya'),
(1098, 34568, 9123456701, 46802, 1357926, 'Ravi'),
(7654, 90124, 6123456702, 57914, 2468013, 'Preeti'),
(4321, 45679, 7123456703, 68024, 246917, 'Suresh'),
(9870, 1235, 8123456704, 79135, 1357928, 'Shruti'),
(6543, 56790, 9123456705, 80246, 2468019, 'Deepak'),
(3210, 12347, 6123456706, 91357, 246910, 'Aakash'),
(9876, 67892, 7123456707, 2468, 1357921, 'Riya'),
(5432, 23458, 8123456708, 13578, 2468012, 'Prakash'),
(7891, 78903, 9123456709, 24679, 246913, 'Shreya'),
(2346, 34569, 6123456710, 35792, 1357924, 'Aditya'),
(6781, 90125, 7123456711, 46803, 2468015, 'Sneha');

ALTER TABLE IPO_Apply
ADD CONSTRAINT User_Id_FK
FOREIGN KEY (User_Id) REFERENCES user_database(User_Id) ON DELETE CASCADE;



CREATE TABLE profile_database (
    User_Id INTEGER Primary Key,
    Funds_Available Decimal(10, 2) CHECK (Funds_Available>=0),
    Funds_Invested Decimal(10, 2) CHECK (Funds_Invested>=0),
    Portfolio_Id INTEGER,
    Current_Value Decimal(10, 2) CHECK (Current_Value>=0),
    FOREIGN KEY (User_Id) REFERENCES user_database(User_Id) ON DELETE CASCADE,
    FOREIGN KEY (Portfolio_Id) REFERENCES user_database(Portfolio_Id) ON DELETE CASCADE
    -- Current value ki value portfolio table se derive karni hogi
);


DELIMITER $$
CREATE TRIGGER insert_into_profile_database
AFTER INSERT ON user_database
FOR EACH ROW
BEGIN
    INSERT INTO profile_database (User_Id, Funds_Available, Funds_INvested, Portfolio_Id, Current_Value)
    VALUES (NEW.User_Id,0,0,New.Portfolio_Id,0);
END$$
DELIMITER ;

CREATE TABLE Stocks (
    Stock_Name VARCHAR(255) NOT NULL,
    Latest_Price FLOAT(10,2) NOT NULL,
    PE FLOAT(10,2) NOT NULL,
    EPS FLOAT(10,2) NOT NULL,
    ROE FLOAT(10,2) NOT NULL,
    Stock_ID INT NOT NULL,
    PRIMARY KEY (Stock_ID),
    FOREIGN KEY (Stock_ID) REFERENCES Company_Database(Stock_ID) ON DELETE CASCADE
);


DELIMITER $$

CREATE TRIGGER DeleteNonListedStocksTrigger
AFTER UPDATE ON Company_Database
FOR EACH ROW
BEGIN
    IF NEW.Listed = 0 THEN
        DELETE FROM IPO_Apply WHERE Stock_ID = NEW.Stock_ID;
    END IF;
END$$

DELIMITER ;


INSERT INTO profile_database (User_Id, Funds_Available, Portfolio_ID)
VALUES 
(1234, 36021.97, 12345),
(5678, 36547.87, 67890),
(9012, 20038.56, 23456),
(3456, 39812.52, 78901),
(7890, 22116.09, 34567),
(2345, 37518.09, 90123),
(6789, 27800.2, 45678),
(1236, 27797.86, 1234),
(4567, 12219.44, 56789),
(8901, 11627.54, 12346),
(2109, 7654.03, 67891),
(8765, 4408.78, 23457),
(5430, 20297.06, 78902),
(1098, 31990.58, 34568),
(7654, 13362.04, 90124),
(4321, 16920.67, 45679),
(9870, 3671.46, 1235),
(6543, 22310.14, 56790),
(3210, 29787.05, 12347),
(9876, 11156.34, 67892),
(5432, 4678.32, 23458),
(7891, 22252.28, 78903),
(2346, 35798.71, 34569),
(6781, 22959.01, 90125);

select * from profile_database;


CREATE TABLE Portfolio (
    Qt INT NOT NULL Check(Qt>0),
    Buy_Value FLOAT(10, 2) ,
    Latest_Price FLOAT(10, 2) ,
    EPS FLOAT(10, 2) ,
    PE FLOAT(10, 2) ,
    ROE FLOAT(10, 2) ,
    User_ID INT ,
    Portfolio_ID INT ,
    Stock_ID INT ,
    PRIMARY KEY (User_ID, Stock_ID),
	FOREIGN KEY (Stock_ID) REFERENCES Company_Database(Stock_ID),
    FOREIGN KEY (User_ID) REFERENCES user_database(User_Id),
    FOREIGN KEY (Portfolio_ID) REFERENCES user_database(Portfolio_Id)
-- this will derive values from stocks dataset
);



-- select * from portfolio;


DELIMITER $$
CREATE TRIGGER update_invested_value
AFTER INSERT ON Portfolio
FOR EACH ROW
BEGIN
    DECLARE total_value INTEGER;

    SELECT SUM(Qt * Buy_Value)
    INTO total_value
    FROM Portfolio
    WHERE User_ID = NEW.User_ID;

    UPDATE profile_database
    SET Funds_Invested = total_value
    WHERE User_Id = NEW.User_ID;
END$$
DELIMITER ;



DELIMITER $$
CREATE TRIGGER update_things
AFTER INSERT ON Stocks
FOR EACH ROW
BEGIN

	DECLARE stock_latest_price FLOAT;
    DECLARE stock_eps FLOAT;
    DECLARE stock_pe FLOAT;
    DECLARE stock_roe FLOAT;
    
    
	SELECT Latest_Price, EPS, PE, ROE
    INTO stock_latest_price, stock_eps, stock_pe, stock_roe
    FROM Stocks
    WHERE Stock_ID = NEW.Stock_ID;
    
	UPDATE portfolio 
	SET Latest_Price = stock_latest_price,
    EPS = stock_eps,
    PE = stock_pe,
    ROE = stock_roe
	WHERE Stock_ID = NEW.Stock_ID;

END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE update_portfolio_after_stock_insert(IN new_stock_id INT)
BEGIN
    DECLARE stock_latest_price FLOAT;
    DECLARE stock_eps FLOAT;
    DECLARE stock_pe FLOAT;
    DECLARE stock_roe FLOAT;

    SELECT Latest_Price, EPS, PE, ROE
    INTO stock_latest_price, stock_eps, stock_pe, stock_roe
    FROM Stocks
    WHERE Stock_ID = new_stock_id;

    UPDATE portfolio 
    SET Latest_Price = stock_latest_price,
        EPS = stock_eps,
        PE = stock_pe,
        ROE = stock_roe
    WHERE Stock_ID = new_stock_id;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE DeleteNONListedStocksFromIPOApply()
BEGIN
    DELETE ia
    FROM Stocks AS ia
    INNER JOIN Company_Database AS cd ON ia.Stock_ID = cd.Stock_ID
    WHERE cd.Listed = 0;
END$$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER update_stocks_values
BEFORE INSERT ON Stocks
FOR EACH ROW
BEGIN
    DECLARE company_pe FLOAT;
    DECLARE company_eps FLOAT;
    DECLARE company_roe FLOAT;
    DECLARE company_name VARCHAR(255);

    -- Fetch PE, EPS, ROE, and Stock_Name from Company_Database
    SELECT PE, EPS, ROE, Stock_Name INTO company_pe, company_eps, company_roe, company_name
    FROM Company_Database
    WHERE Stock_ID = NEW.Stock_ID;

    -- Set values in the NEW row
    SET NEW.PE = company_pe;
    SET NEW.EPS = company_eps;
    SET NEW.ROE = company_roe;
    SET NEW.Stock_Name = company_name;
END$$
DELIMITER ;

select * from stocks;



INSERT INTO Portfolio (Qt, Buy_Value, Stock_ID, User_ID, Portfolio_ID)
SELECT t.Qt, t.Buy_Value, t.Stock_ID, t.User_ID, u.Portfolio_ID
FROM (
  SELECT 45 AS Qt, 23.56 AS Buy_Value, 3 AS Stock_ID, 1234 AS User_ID
  UNION ALL
  SELECT 78, 41.23, 23, 5678
  UNION ALL
  SELECT 62, 19.87, 2, 9012
  UNION ALL
  SELECT 36, 15.92, 1, 3456
  UNION ALL
  SELECT 80, 55.73, 8, 7890
  UNION ALL
  SELECT 57, 32.45, 9, 2345
  UNION ALL
  SELECT 69, 28.91, 10, 6789
  UNION ALL
  SELECT 25, 12.76, 9, 1236
  UNION ALL
  SELECT 88, 37.58, 7, 4567
  UNION ALL
  SELECT 49, 24.63, 8, 8901
  UNION ALL
  SELECT 71, 30.12, 23, 2109
  UNION ALL
  SELECT 39, 18.27, 22, 8765
  UNION ALL
  SELECT 83, 42.98, 25, 5430
  UNION ALL
  SELECT 54, 26.75, 6, 1098
  UNION ALL
  SELECT 68, 31.34, 14, 7654
  UNION ALL
  SELECT 43, 21.89, 15, 4321
  UNION ALL
  SELECT 76, 35.67, 16, 9870
) AS t
JOIN User_Database AS u ON t.User_ID = u.User_ID;


INSERT INTO Stocks (Latest_Price, Stock_ID)
VALUES 
(32.98, 1),
(11.76, 2),
(45.32, 3),
(13.45, 4),
(38.21, 5),
(19.87, 6),
(42.56, 7),
(16.78, 8),
(28.34, 9),
(35.67, 10),
(18.92, 11),
(33.45, 12),
(14.78, 13),
(41.23, 14),
(22.56, 15),
(30.89, 16),
(20.45, 17),
(49.32, 18),
(26.78, 19),
(31.45, 20),
(15.89, 21),
(50.21, 22),
(25.67, 23),
(17.32, 24),
(48.76, 25);


CALL DeleteNONListedStocksFromIPOApply();

select * from stocks order by stock_id;


select * from portfolio;



CREATE TABLE Orders (
    Status INT NOT NULL,
    Quantity INT NOT NULL Check(Quantity>0),
    Stock_ID INT NOT NULL,
    Order_Type INT NOT NULL,
    Buy_Sell INT NOT NULL,
    User_ID INT NOT NULL,
    Order_ID INT NOT NULL PRIMARY KEY,
    FOREIGN KEY (Stock_ID) REFERENCES Stocks(Stock_ID) ON DELETE CASCADE,
    FOREIGN KEY (User_Id) REFERENCES user_database(User_Id) ON DELETE CASCADE    
);
-- INSERT INTO Orders VALUES (1, 10, 6, 0, 2, 1234, 2);
select * from portfolio;




DELIMITER $$
CREATE TRIGGER create_portfolio_row
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    IF NEW.Status = 1 AND NEW.Buy_Sell = 1 THEN
        -- Buy order
        -- (Qt, Buy_Value, Stock_ID, User_ID, Portfolio_ID)

        UPDATE Stocks
        Set Latest_price = Latest_price *1.01
        Where Stock_ID = NEW.Stock_ID;
        
        INSERT INTO Portfolio (Qt, User_ID, Stock_ID, Portfolio_ID, Buy_Value, Latest_price, EPS,PE,ROE)
        SELECT NEW.Quantity, NEW.User_ID, NEW.Stock_ID, u.Portfolio_Id, s.Latest_Price/1.01,s.Latest_price, s.EPS, s.PE, s.ROE 
        FROM user_database u
        JOIN Stocks s ON s.Stock_ID = NEW.Stock_ID
        WHERE u.User_Id = NEW.USER_ID;

        -- Update the profile_database table
        UPDATE profile_database
        SET Funds_Available = Funds_Available - (NEW.Quantity * (SELECT Latest_Price FROM Stocks WHERE Stock_ID = NEW.Stock_ID))
        WHERE User_Id = NEW.User_ID;
        
        Update Portfolio
        Set Latest_price = Latest_price *1.01
        Where Stock_ID = NEW.Stock_ID and user_id != NEW.user_id;
        
        call update_current_value_for_all_users();
        call update_latest_price_for_stocks();
        
        
    ELSEIF NEW.Status = 1 AND NEW.Buy_Sell = 2 THEN
        -- Sell order
        UPDATE Portfolio
        SET Qt = Qt - NEW.Quantity
        WHERE User_ID = NEW.User_ID AND Stock_ID = NEW.Stock_ID;

        -- Update the profile_database table
        UPDATE profile_database
        SET Funds_Available = Funds_Available + (NEW.Quantity * (SELECT Latest_Price FROM Stocks WHERE Stock_ID = NEW.Stock_ID))
        WHERE User_Id = NEW.User_ID;
        
		UPDATE Stocks
        Set Latest_price = Latest_price *0.99
        Where Stock_ID = NEW.Stock_ID;
		
        Update Portfolio
        Set Latest_price = Latest_price *0.99
        Where Stock_ID = NEW.Stock_ID;
        
        DELETE FROM Portfolio
        WHERE User_ID = NEW.User_ID AND Stock_ID = NEW.Stock_ID AND Qt = 0;
        
        call update_current_value_for_all_users();
        call update_latest_price_for_stocks();
        
    END IF;
END$$
DELIMITER ;



CREATE TABLE Indices (
    Index_ID VARCHAR(255) NOT NULL,
    Index_Name VARCHAR(255) NOT NULL,
    Price float(10,2) NOT NULL,
    PRIMARY KEY (Index_ID)
);

INSERT INTO Indices (Index_ID, Index_Name, Price)
VALUES 
('20s32f3', 'Nifty 50', 145678.23),
('45e98g7', 'BSE Sensex', 158743.57),
('89d43a2', 'Dow Jones Industrial', 192367.41),
('76b23n5', 'NASDAQ Composite', 174582.69),
('34p78k9', 'S&P 500', 180965.32),
('67q12w8', 'FTSE 100', 136589.74),
('23z87x1', 'DAX', 152364.89),
('90c67v2', 'CAC 40', 129876.45),
('12n76m4', 'Nikkei 225', 167430.56),
('54h09b8', 'Hang Seng Index', 195643.28),
('78i32l6', 'Shanghai Composite', 187234.69),
('21f76t5', 'Bovespa Index', 142879.34),
('43s89h1', 'S&P/ASX 200', 153907.85),
('65r09j2', 'RTS Index', 121543.76);


ALTER TABLE Indices ADD INDEX idx_price (Price);

CREATE TABLE Customer_Index (
    Price_Bought float(10,2) NOT NULL,
    Current_Price Float(10,2) NOT NULL,
    Index_ID VARCHAR(255) NOT NULL,
    User_ID INT NOT NULL,
    PRIMARY KEY (Index_ID),
    FOREIGN KEY (User_Id) REFERENCES user_database(User_Id) ON DELETE CASCADE,
    FOREIGN KEY (Current_Price) REFERENCES Indices(Price) ON DELETE CASCADE 
);


DELIMITER $$
CREATE TRIGGER update_current_price
BEFORE INSERT ON Customer_Index
FOR EACH ROW
BEGIN
    DECLARE index_price FLOAT;

    SELECT Price INTO index_price
    FROM Indices
    WHERE Index_ID = NEW.Index_ID;

    SET NEW.Current_Price = index_price;
END$$
DELIMITER ;

INSERT INTO Customer_Index (Price_Bought, Index_ID, User_ID)
VALUES 
(178934.67, '76b23n5', 1236),
(185467.32, '34p78k9', 4567),
(139876.54, '67q12w8', 8901),
(156789.23, '23z87x1', 2109),
(169543.87, '90c67v2', 8765),
(143267.58, '12n76m4', 5430),
(129876.45, '54h09b8', 1098);

-- below block is to update current value, so just call  update_current_value_for_all_users everytime to update after change in stock prices
DELIMITER $$
CREATE PROCEDURE update_current_value(IN user_id INT)
BEGIN
    DECLARE total_value DECIMAL(15,2);

    SELECT SUM(p.Qt * COALESCE(p.Latest_Price, 0))
    INTO total_value
    FROM Portfolio AS p
    WHERE p.User_ID = user_id;

    UPDATE profile_database AS pd
    SET pd.Current_Value = total_value
    WHERE pd.User_Id = user_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE update_current_value_for_all_users()
BEGIN
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE user_id_value INT;

    DECLARE user_id_cursor CURSOR FOR
        SELECT User_ID FROM user_database;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN user_id_cursor;

    read_loop: LOOP
        FETCH user_id_cursor INTO user_id_value;
        IF done THEN
            LEAVE read_loop;
        END IF;

        CALL update_current_value(user_id_value);
    END LOOP;

    CLOSE user_id_cursor;
END$$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE update_latest_price(IN stock_id INT)
BEGIN
    DECLARE total_value DECIMAL(15,2);

    SELECT Latest_price
    INTO total_value
    FROM Stocks as s
    WHERE s.Stock_ID = stock_id;

    UPDATE portfolio AS pd
    SET pd.Latest_Price = total_value
    WHERE pd.STOCK_ID = stock_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE update_latest_price_for_stocks()
BEGIN
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE stock_id_value INT;

    DECLARE stock_id_cursor CURSOR FOR
        SELECT Stock_id FROM Stocks;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN stock_id_cursor;

    read_loop: LOOP
        FETCH stock_id_cursor INTO stock_id_value;
        IF done THEN
            LEAVE read_loop;
        END IF;

        CALL update_current_value(stock_id_value);
    END LOOP;

    CLOSE stock_id_cursor;
END$$
DELIMITER ;

call update_latest_price_for_stocks();




select * from orders;
-- Inserting sample values into the Orders table
INSERT INTO Orders VALUES (1, 100, 7, 1, 1, 1234, 5);


select * from stocks;
select * from profile_database;
CALL update_current_value_for_all_users();
select * from portfolio;


DELIMITER $$

CREATE PROCEDURE MoveToStocks()
BEGIN
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE userId INT;
    DECLARE stockId INT;
    DECLARE stockName VARCHAR(255);
    DECLARE bidPrice FLOAT(10, 2);
    DECLARE quantity INT;
    DECLARE pid INT;

    DECLARE cursor1 CURSOR FOR
        SELECT User_ID, Stock_ID, Stock_Name, Bid_Price, Qt
        FROM IPO_Admin
        WHERE Status = 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cursor1;

    read_loop: LOOP
        FETCH cursor1 INTO userId, stockId, stockName, bidPrice, quantity;
        IF done THEN
            LEAVE read_loop;
        END IF;

        INSERT INTO Stocks (Stock_ID, Latest_Price)
        VALUES (stockId, bidPrice * 1.1);

        SELECT portfolio_id
        INTO pid
        FROM User_Database
        WHERE user_id = userId;
        
		UPDATE Company_Database
        SET Listed = 1
        WHERE Stock_ID = stockId;

        INSERT INTO Portfolio (Qt, Buy_value, stock_id, user_id, portfolio_id, latest_price)
        VALUES (quantity, bidPrice,stockid, userId, pid, bidPrice * 1.1);
        
        CALL update_portfolio_after_stock_insert(stockid); -- Replace 123 with the actual new stock ID
        CALL update_current_value_for_all_users();


        DELETE FROM IPO_Admin
        WHERE Stock_ID = stockId;

        DELETE FROM IPO_Apply
        WHERE Stock_ID = stockId;
    END LOOP;

    CLOSE cursor1;
END$$

DELIMITER ;


select * from IPO_Admin;
UPDATE IPO_Admin
SET Status = 1
WHERE Stock_ID = 6;

CALL MoveToStocks();

show procedure status
where 'Db' = '2New_SMS';


select * from stocks;

SELECT * FROM company_database WHERE listed = '1' ORDER BY stock_id;

select * from IPO_Admin;

update IPO_Admin
set Status =1 
where Stock_Id = 5;

Call MoveToStocks();
CALL update_current_value_for_all_users();
select * from profile_database;
select * from portfolio;
select * from stocks;


select * from IPO_apply;



insert into IPO_Apply(user_id,stock_id)
values(1234,4);