# mysql_generate_series: generate_series for MySQL

mysql_generate_series is a MySQL version of PostgreSQL's [generate_series](http://www.postgresql.org/docs/9.4/static/functions-srf.html) functions.

This version is (heavily) adapted from the original by Gabriel Bordeaux and seeks to simplify the method call and make the MySQL version parameters follow the PostgreSQL version insofar as that is possible. 

It offers a single method taking 3 parameters:
* generate_series(start, stop, step): and delivers a series from "start" to "stop" incrementing by "step".

Calling the method generates no output but instead creates a temporary table called `series_tmp` in the current database which can be used in joins and sub-queries in the current session.
 
All parameters are INTEGER or strings which are representative of INTEGER, DATE, DATETIME and INTERVAL depending on the type of series being generated

### INTEGER Series
For integer ranges the three parameters are all INTEGER or string representations of numbers ("strumbers" if you prefer)

either

* CALL generate_series(1, 20, 1);
or
* CALL generate_series('1', '20', '1');

Will create and populate `series_tmp` with INTEGER values from 1 to 20, incrementing by 1.

```sql
mysql> CALL generate_series( 1 , 10 , 1);
Query OK, 0 rows affected (0.05 sec)

mysql> describe series_tmp;
+--------+------------+------+-----+---------+-------+
| Field  | Type       | Null | Key | Default | Extra |
+--------+------------+------+-----+---------+-------+
| series | bigint(20) | NO   | PRI | NULL    |       |
+--------+------------+------+-----+---------+-------+
1 row in set (0.00 sec)

mysql> SELECT * FROM `series_tmp`;
+--------+
| series |
+--------+
|      1 |
|      2 |
|      3 |
|      4 |
|      5 |
|      6 |
|      7 |
|      8 |
|      9 |
|     10 |
+--------+
10 rows in set (0.00 sec)
```

### DATE Series
For date ranges the "start" and "stop" parameters are string representations of dates and "step" represents the INTERVAL

e.g.

* CALL generate_series('2018-01-01','2018-12-31','INTERVAL 1 DAY');

```sql
mysql> CALL generate_series('2018-01-01','2018-12-31','INTERVAL 1 MONTH');
Query OK, 0 rows affected (0.08 sec)

mysql> describe series_tmp;
+--------+------+------+-----+---------+-------+
| Field  | Type | Null | Key | Default | Extra |
+--------+------+------+-----+---------+-------+
| series | date | NO   | PRI | NULL    |       |
+--------+------+------+-----+---------+-------+
1 row in set (0.00 sec)

mysql> SELECT * FROM `series_tmp`;
+------------+
| series     |
+------------+
| 2018-01-01 |
| 2018-02-01 |
| 2018-03-01 |
| 2018-04-01 |
| 2018-05-01 |
| 2018-06-01 |
| 2018-07-01 |
| 2018-08-01 |
| 2018-09-01 |
| 2018-10-01 |
| 2018-11-01 |
| 2018-12-01 |
+------------+
12 rows in set (0.00 sec)
```


### DATETIME Series
For datetime ranges the "start" and "stop" parameters are datetimes and "step" represents the INTERVAL.

e.g.

* CALL generate_series('2018-01-01 00:00:00', '2018-01-01 23:59:59', 'INTERVAL 1 SECOND');

```sql
mysql> CALL generate_series('2018-01-01 00:00:00', '2018-01-01 23:59:00', 'INTERVAL 1 MINUTE');
Query OK, 0 rows affected (0.07 sec)

mysql> describe series_tmp;
+--------+----------+------+-----+---------+-------+
| Field  | Type     | Null | Key | Default | Extra |
+--------+----------+------+-----+---------+-------+
| series | datetime | NO   | PRI | NULL    |       |
+--------+----------+------+-----+---------+-------+
1 row in set (0.01 sec)

mysql> SELECT * FROM `series_tmp`;
+---------------------+
| series              |
+---------------------+
| 2018-01-01 00:00:00 |
| 2018-01-01 00:01:00 |
| 2018-01-01 00:02:00 |
| 2018-01-01 00:03:00 |
| 2018-01-01 00:04:00 |
| 2018-01-01 00:05:00 |
| 2018-01-01 00:06:00 |
| 2018-01-01 00:07:00 |
| 2018-01-01 00:08:00 |
...
| 2018-01-01 23:56:00 |
| 2018-01-01 23:57:00 |
| 2018-01-01 23:58:00 |
| 2018-01-01 23:59:00 |
+---------------------+
1440 rows in set (0.00 sec)
```

### INTERVALS
The following INTERVAL types are supported:

* SECOND
* MINUTE
* HOUR
* DAY
* WEEK
* MONTH
* YEAR


### Installation

* Install the methods from [sql/generate_series.sql](sql/generate_series.sql)


### Inserting in a table from a series

MySQL does not support functions returning table so the procedure must be run before the data can be used from `series_tmp`.

The following example shows how to insert multiple rows in MySQL tables easily:

```sql
-- Create a test table
mysql> CREATE TABLE test (a int, b text);
Query OK, 0 rows affected (0.01 sec)

-- Generate a series from 1 to 10
mysql> CALL generate_series(1, 10, 1);
Query OK, 0 rows affected (0.00 sec)

-- Insert all the rows from the series into the test table
mysql> INSERT INTO test (a, b) SELECT series, 'This is a test' FROM `series_tmp`;
Query OK, 10 rows affected (0.00 sec)
Records: 10  Duplicates: 0  Warnings: 0

-- Display the test table content
mysql> SELECT * FROM test;
+------+----------------+
| a    | b              |
+------+----------------+
|    1 | This is a test |
|    2 | This is a test |
|    3 | This is a test |
|    4 | This is a test |
|    5 | This is a test |
|    6 | This is a test |
|    7 | This is a test |
|    8 | This is a test |
|    9 | This is a test |
|   10 | This is a test |
+------+----------------+
10 rows in set (0.00 sec)
```

### Querying in a table using a series

As for inserts, MySQL does not allow using a stored procedure directly in a SELECT query.

We can again use mysql_generate_series's temporary table `series_tmp` to use the series with a JOIN in a SELECT query

This example demonstrates how to display all hours from a date and their eventual associated row in another table:

```sql
-- Create test table
mysql> CREATE TABLE test2 (a datetime, b text);
Query OK, 0 rows affected (0.03 sec)

-- Insert 2 lines
mysql> INSERT INTO test2 (a, b) VALUES ('2015-09-03 02:00:00', 'Line 1'),
    ->                                 ('2015-09-03 14:00:00', 'Line 2');
Query OK, 2 rows affected (0.00 sec)
Records: 2  Duplicates: 0  Warnings: 0

-- Generate a series of each hour of the day
mysql> CALL generate_series('2015-09-03 00:00:00', '2015-09-03 23:00:00', 'INTERVAL 1 HOUR');
Query OK, 0 rows affected (0.00 sec)

-- Select "test2" content
mysql> SELECT * FROM test2;
+---------------------+--------+
| a                   | b      |
+---------------------+--------+
| 2015-09-03 02:00:00 | Line 1 |
| 2015-09-03 14:00:00 | Line 2 |
+---------------------+--------+
2 rows in set (0.00 sec)

-- Select "test2" content with all hours of the day
mysql> SELECT series_tmp.series, test2.a, test2.b
    -> FROM series_tmp
    -> LEFT JOIN test2 ON series_tmp.series = test2.a
    -> ORDER BY series_tmp.series;
+---------------------+---------------------+--------+
| series              | a                   | b      |
+---------------------+---------------------+--------+
| 2015-09-03 00:00:00 | NULL                | NULL   |
| 2015-09-03 01:00:00 | NULL                | NULL   |
| 2015-09-03 02:00:00 | 2015-09-03 02:00:00 | Line 1 |
| 2015-09-03 03:00:00 | NULL                | NULL   |
| 2015-09-03 04:00:00 | NULL                | NULL   |
| 2015-09-03 05:00:00 | NULL                | NULL   |
| 2015-09-03 06:00:00 | NULL                | NULL   |
| 2015-09-03 07:00:00 | NULL                | NULL   |
| 2015-09-03 08:00:00 | NULL                | NULL   |
| 2015-09-03 09:00:00 | NULL                | NULL   |
| 2015-09-03 10:00:00 | NULL                | NULL   |
| 2015-09-03 11:00:00 | NULL                | NULL   |
| 2015-09-03 12:00:00 | NULL                | NULL   |
| 2015-09-03 13:00:00 | NULL                | NULL   |
| 2015-09-03 14:00:00 | 2015-09-03 14:00:00 | Line 2 |
| 2015-09-03 15:00:00 | NULL                | NULL   |
| 2015-09-03 16:00:00 | NULL                | NULL   |
| 2015-09-03 17:00:00 | NULL                | NULL   |
| 2015-09-03 18:00:00 | NULL                | NULL   |
| 2015-09-03 19:00:00 | NULL                | NULL   |
| 2015-09-03 20:00:00 | NULL                | NULL   |
| 2015-09-03 21:00:00 | NULL                | NULL   |
| 2015-09-03 22:00:00 | NULL                | NULL   |
| 2015-09-03 23:00:00 | NULL                | NULL   |
+---------------------+---------------------+--------+
24 rows in set (0.00 sec)
```

### Tips and tricks

 * The temporary table used to store results `series_tmp` is dropped and recreated on each call to generate_series(). As a temporary table, `series_tmp` will only be available within the current session and to the current user. It will also automatically dropped when the connection is closed.

### Authors

**Gabriel Bordeaux**

+ [Website](http://www.gab.lc/) 
+ [Twitter](https://twitter.com/gabrielbordeaux)

**Paul Campbell**
+ [Website](http://www.animalcarpet.com/)
