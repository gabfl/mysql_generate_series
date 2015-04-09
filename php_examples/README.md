# mysql_generate_series: PHP examples

All PHP examples use the "_no_output" version of each stored procedure.

For example, for "generate_series(first, last)", we will use "generate_series_no_output(first, last)" so that the stored procedure does not generate any output that could generate an error in PHP.

### PHP example using mysql_* (Original deprecated extension)

* INSERT rows in a table [mysql_insert.php](mysql_insert.php)
* SELECT rows from a table [mysql_select.php](mysql_select.php)

### PHP example using mysqli_* (Improved extension, procedural interface)

* INSERT rows in a table [mysqli_insert.php](mysqli_insert.php)
* SELECT rows from a table [mysqli_select.php](mysqli_select.php)

### PHP example using mysqli->* (Improved extension, object-oriented interface)

* INSERT rows in a table [mysqli_object_insert.php](mysqli_object_insert.php)
* SELECT rows from a table [mysqli_object_select.php](mysqli_object_select.php)
