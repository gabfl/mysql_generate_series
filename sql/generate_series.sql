DELIMITER $$

DROP PROCEDURE IF EXISTS generate_series $$
CREATE PROCEDURE generate_series(_start VARCHAR(20), _stop VARCHAR(20), _step VARCHAR(40))
BEGIN
    -- establish range type being produced 
    -- establish step increment
    -- call appropriate generation function

  DECLARE _typecheck VARCHAR(8);
  DECLARE _interval  VARCHAR(20);
  -- we don't know the type of these vars till runtime
  SET @start = @stop = @step = NULL;
  DROP TEMPORARY TABLE IF EXISTS series_tmp;

  -- All parameters are required
  IF LENGTH(CAST(_start AS UNSIGNED) + 0) = LENGTH(_start) THEN
    SET _typecheck = 'INTEGER';
    SET @start = CAST(_start AS UNSIGNED);
    SET @stop  = CAST(_stop AS UNSIGNED);
    SET @step  = CAST(_step AS UNSIGNED);
  ELSE
    SET _typecheck = 'DATETIME';

    IF LENGTH(_start) = 10 THEN
      SET @start = CAST(_start AS DATE);
      SET @stop  = CAST(_stop AS DATE);
    ELSE
      SET @start = CAST(_start AS DATETIME);
      SET @stop  = CAST(_stop AS DATETIME);
    END IF;

    IF _step REGEXP 'INTERVAL [0-9]+ (SECOND|MINUTE|HOUR|DAY|WEEK|MONTH|YEAR)' = 1 THEN
       SET _interval = SUBSTRING_INDEX(_step, ' ', -1); 
       SET @step = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(_step, ' ', 2), ' ', -1) AS UNSIGNED);
     ELSE
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = '\'step\' parameter should be in the form INTERVAL n SECOND|MINUTE|HOUR|DAY|WEEK|MONTH|YEAR';
    END IF;
  END IF;

  IF _typecheck = 'INTEGER' THEN
    CREATE TEMPORARY TABLE series_tmp (
      series BIGINT PRIMARY KEY
    ) ENGINE = MEMORY;

    WHILE @start <= @stop DO
      -- Insert in tmp table
      INSERT INTO series_tmp (series) VALUES (@start);
      -- Increment value by step
      SET @start = @start + @step;
    END WHILE;
  ELSE
    IF LENGTH(@start) = 10 THEN
      CREATE TEMPORARY TABLE series_tmp(
        series DATE PRIMARY KEY
      ) ENGINE = MEMORY;
    ELSE
      CREATE TEMPORARY TABLE series_tmp(
        series DATETIME PRIMARY KEY
      ) ENGINE = MEMORY;
    END IF;

    WHILE @start <= @stop DO
      INSERT INTO series_tmp (series) VALUES (@start);

      CASE UPPER(_interval)
        WHEN 'SECOND' THEN
          SET @start = DATE_ADD(@start, INTERVAL @step SECOND);
        WHEN 'MINUTE' THEN
          SET @start = DATE_ADD(@start, INTERVAL @step MINUTE);
        WHEN 'HOUR' THEN
          SET @start = DATE_ADD(@start, INTERVAL @step HOUR);
        WHEN 'DAY' THEN
          SET @start = DATE_ADD(@start, INTERVAL @step DAY);
        WHEN 'WEEK' THEN
          SET @start = DATE_ADD(@start, INTERVAL @step WEEK);
        WHEN 'MONTH' THEN
          SET @start = DATE_ADD(@start, INTERVAL @step MONTH);
        WHEN 'YEAR' THEN
          SET @start = DATE_ADD(@start, INTERVAL @step YEAR);
        END CASE;
     END WHILE;
  END IF;

END $$

DELIMITER ;