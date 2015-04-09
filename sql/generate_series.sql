-- 
-- Base stored procedures
-- 

DROP PROCEDURE IF EXISTS generate_series_base;
DELIMITER $$
CREATE PROCEDURE generate_series_base (IN n_first BIGINT, IN n_last BIGINT)
BEGIN
    -- Create tmp table
    DROP TEMPORARY TABLE IF EXISTS series_tmp;
    CREATE TEMPORARY TABLE series_tmp (
        series bigint
    ) engine = memory;
    
    WHILE n_first <= n_last DO
        -- Insert in tmp table
        INSERT INTO series_tmp (series) VALUES (n_first);

        -- Increment value by one
        SET n_first = n_first + 1; 
    END WHILE;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS generate_series_n_base;
DELIMITER $$
CREATE PROCEDURE generate_series_n_base (IN n_first BIGINT, IN n_last BIGINT, IN n_increment BIGINT)
BEGIN
    -- Create tmp table
    DROP TEMPORARY TABLE IF EXISTS series_tmp;
    CREATE TEMPORARY TABLE series_tmp (
        series bigint
    ) engine = memory;
    
    WHILE n_first <= n_last DO
        -- Insert in tmp table
        INSERT INTO series_tmp (series) VALUES (n_first);

        -- Increment value by one
        SET n_first = n_first + n_increment; 
    END WHILE;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS generate_series_date_minute_base;
DELIMITER $$
CREATE PROCEDURE generate_series_date_minute_base (IN n_first DATETIME, IN n_last DATETIME, IN n_increment CHAR(40))
BEGIN
    -- Create tmp table
    DROP TEMPORARY TABLE IF EXISTS series_tmp;
    CREATE TEMPORARY TABLE series_tmp (
        series DATETIME
    ) engine = memory;
    
    WHILE n_first  <= n_last DO
        -- Insert in tmp table
        INSERT INTO series_tmp (series) VALUES (n_first);

        -- Increment value by one
        SELECT DATE_ADD(n_first, INTERVAL +n_increment minute) INTO n_first;
    END WHILE;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS generate_series_date_hour_base;
DELIMITER $$
CREATE PROCEDURE generate_series_date_hour_base (IN n_first DATETIME, IN n_last DATETIME, IN n_increment CHAR(40))
BEGIN
    -- Create tmp table
    DROP TEMPORARY TABLE IF EXISTS series_tmp;
    CREATE TEMPORARY TABLE series_tmp (
        series DATETIME
    ) engine = memory;
    
    WHILE n_first  <= n_last DO
        -- Insert in tmp table
        INSERT INTO series_tmp (series) VALUES (n_first);

        -- Increment value by one
        SELECT DATE_ADD(n_first, INTERVAL +n_increment hour) INTO n_first;
    END WHILE;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS generate_series_date_day_base;
DELIMITER $$
CREATE PROCEDURE generate_series_date_day_base (IN n_first DATETIME, IN n_last DATETIME, IN n_increment CHAR(40))
BEGIN
    -- Create tmp table
    DROP TEMPORARY TABLE IF EXISTS series_tmp;
    CREATE TEMPORARY TABLE series_tmp (
        series DATETIME
    ) engine = memory;
    
    WHILE n_first  <= n_last DO
        -- Insert in tmp table
        INSERT INTO series_tmp (series) VALUES (n_first);

        -- Increment value by one
        SELECT DATE_ADD(n_first, INTERVAL +n_increment day) INTO n_first;
    END WHILE;
END $$
DELIMITER ;

-- 
-- Stored procedure with no output
-- 

DROP PROCEDURE IF EXISTS generate_series_no_output;
DELIMITER $$
CREATE PROCEDURE generate_series_no_output (IN n_first BIGINT, IN n_last BIGINT)
BEGIN
    -- Call base stored procedure
    CALL generate_series_base(n_first, n_last);
END $$
DELIMITER ;
-- CALL generate_series_no_output(10, 20);
-- SELECT * FROM series_tmp;

DROP PROCEDURE IF EXISTS generate_series_n_no_output;
DELIMITER $$
CREATE PROCEDURE generate_series_n_no_output (IN n_first BIGINT, IN n_last BIGINT, IN n_increment BIGINT)
BEGIN
    -- Call base stored procedure
    CALL generate_series_n_base(n_first, n_last, n_increment);
END $$
DELIMITER ;
-- CALL generate_series_n_no_output(10, 20, 2);
-- SELECT * FROM series_tmp;

DROP PROCEDURE IF EXISTS generate_series_date_minute_no_output;
DELIMITER $$
CREATE PROCEDURE generate_series_date_minute_no_output (IN n_first DATETIME, IN n_last DATETIME, IN n_increment CHAR(40))
BEGIN
    -- Call base stored procedure
    CALL generate_series_date_minute_base(n_first, n_last, n_increment);
END $$
DELIMITER ;
-- CALL generate_series_date_minute_no_output('2014-01-01 00:00:00', '2014-01-01 00:20:00', '1');
-- SELECT * FROM series_tmp;

DROP PROCEDURE IF EXISTS generate_series_date_hour_no_output;
DELIMITER $$
CREATE PROCEDURE generate_series_date_hour_no_output (IN n_first DATETIME, IN n_last DATETIME, IN n_increment CHAR(40))
BEGIN
    -- Call base stored procedure
    CALL generate_series_date_hour_base(n_first, n_last, n_increment);
END $$
DELIMITER ;
-- CALL generate_series_date_hour_no_output('2014-01-01', '2014-01-02', '1');
-- SELECT * FROM series_tmp;

DROP PROCEDURE IF EXISTS generate_series_date_day_no_output;
DELIMITER $$
CREATE PROCEDURE generate_series_date_day_no_output (IN n_first DATETIME, IN n_last DATETIME, IN n_increment CHAR(40))
BEGIN
    -- Call base stored procedure
    CALL generate_series_date_day_base(n_first, n_last, n_increment);
END $$
DELIMITER ;
-- CALL generate_series_date_day_no_output('2014-01-01', '2014-02-01', '1');
-- SELECT * FROM series_tmp;

-- 
-- Stored procedure with regular output
-- 

DROP PROCEDURE IF EXISTS generate_series;
DELIMITER $$
CREATE PROCEDURE generate_series (IN n_first BIGINT, IN n_last BIGINT)
BEGIN
    -- Call base stored procedure
    CALL generate_series_base(n_first, n_last);
    
    -- Output
    SELECT * FROM series_tmp;
END $$
DELIMITER ;
-- CALL generate_series(10, 20);

DROP PROCEDURE IF EXISTS generate_series_n;
DELIMITER $$
CREATE PROCEDURE generate_series_n (IN n_first BIGINT, IN n_last BIGINT, IN n_increment BIGINT)
BEGIN
    -- Call base stored procedure
    CALL generate_series_n_base(n_first, n_last, n_increment);
    
    -- Output
    SELECT * FROM series_tmp;
END $$
DELIMITER ;
-- CALL generate_series_n(10, 20, 2);

DROP PROCEDURE IF EXISTS generate_series_date_minute;
DELIMITER $$
CREATE PROCEDURE generate_series_date_minute (IN n_first DATETIME, IN n_last DATETIME, IN n_increment CHAR(40))
BEGIN
    -- Call base stored procedure
    CALL generate_series_date_minute_base(n_first, n_last, n_increment);
    
    -- Output
    SELECT * FROM series_tmp;
END $$
DELIMITER ;
-- CALL generate_series_date_minute('2014-01-01 00:00:00', '2014-01-01 00:20:00', '1');

DROP PROCEDURE IF EXISTS generate_series_date_hour;
DELIMITER $$
CREATE PROCEDURE generate_series_date_hour (IN n_first DATETIME, IN n_last DATETIME, IN n_increment CHAR(40))
BEGIN
    -- Call base stored procedure
    CALL generate_series_date_hour_base(n_first, n_last, n_increment);
    
    -- Output
    SELECT * FROM series_tmp;
END $$
DELIMITER ;
-- CALL generate_series_date_hour('2014-01-01', '2014-01-02', '1');

DROP PROCEDURE IF EXISTS generate_series_date_day;
DELIMITER $$
CREATE PROCEDURE generate_series_date_day (IN n_first DATETIME, IN n_last DATETIME, IN n_increment CHAR(40))
BEGIN
    -- Call base stored procedure
    CALL generate_series_date_day_base(n_first, n_last, n_increment);
    
    -- Output
    SELECT * FROM series_tmp;
END $$
DELIMITER ;
-- CALL generate_series_date_day('2014-01-01', '2014-02-01', '1');
