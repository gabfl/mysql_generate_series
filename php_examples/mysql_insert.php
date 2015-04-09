<?php

// Do not display deprecated errors as mysql_* is deprecated
error_reporting(E_ALL & ~E_DEPRECATED);

// MySQL connection
$link = mysql_connect('MY_HOST', 'MY_USER', 'MY_PASSWORD');
mysql_select_db('MY_DATABASE');

// Drop then create test table
mysql_query("DROP TABLE IF EXISTS test;") or die("Query fail: ".mysql_error());
mysql_query("CREATE TABLE test (a int, b text);") or die("Query fail: ".mysql_error());

// Generate a series
mysql_query("CALL generate_series_no_output(1, 10);") or die("Query fail: ".mysql_error());

// Insert all the rows from the series into the test table
mysql_query("INSERT INTO test (a, b) SELECT series, 'This is a test' FROM series_tmp") or die("Query fail: ".mysql_error());

// Fetch content from the test table
$result = mysql_query("SELECT a, b FROM test;") or die("Query fail: ".mysql_error());

// Display result
echo "<table border='1'>
		<tr>
			<th>a</th>
			<th>b</th>
		</tr>";
while ($row = mysql_fetch_assoc($result)) {
	echo "<tr>
			<td>".$row['a']."</td>
			<td>".$row['b']."</td>
		</tr>";
}
echo "</table>";

// Close connection
mysql_close($link);
?>