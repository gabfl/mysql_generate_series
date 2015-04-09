DROP PROCEDURE IF EXISTS generate_series;
DELIMITER $$
CREATE PROCEDURE generate_series (IN n_first BIGINT, IN n_last BIGINT)
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
    
    -- Select result
    SELECT * FROM series_tmp;
END $$
DELIMITER ;
-- CALL generate_series(10, 20);
-- CREATE TEMPORARY TABLE test (a int); INSERT INTO test (a) SELECT series FROM series_tmp;

DROP PROCEDURE IF EXISTS generate_series_n;
DELIMITER $$
CREATE PROCEDURE generate_series_n (IN n_first BIGINT, IN n_last BIGINT, IN n_increment BIGINT)
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
    
    -- Select result
    SELECT * FROM series_tmp;
END $$
DELIMITER ;
-- CALL generate_series_n(10, 20, 2);

DROP PROCEDURE IF EXISTS generate_series_date_minute;
DELIMITER $$
CREATE PROCEDURE generate_series_date_minute (IN n_first DATETIME, IN n_last DATETIME, IN n_increment CHAR(40))
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
    
    -- Select result
    SELECT * FROM series_tmp;
END $$
DELIMITER ;
-- CALL generate_series_date_minute('2014-01-01 00:00:00', '2014-01-01 00:20:00', '1');

DROP PROCEDURE IF EXISTS generate_series_date_hour;
DELIMITER $$
CREATE PROCEDURE generate_series_date_hour (IN n_first DATETIME, IN n_last DATETIME, IN n_increment CHAR(40))
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
    
    -- Select result
    SELECT * FROM series_tmp;
END $$
DELIMITER ;
-- CALL generate_series_date_hour('2014-01-01', '2014-01-02', '1');

DROP PROCEDURE IF EXISTS generate_series_date_day;
DELIMITER $$
CREATE PROCEDURE generate_series_date_day (IN n_first DATETIME, IN n_last DATETIME, IN n_increment CHAR(40))
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
    
    -- Select result
    SELECT * FROM series_tmp;
END $$
DELIMITER ;
-- CALL generate_series_date_day('2014-01-01', '2014-02-01', '1');
