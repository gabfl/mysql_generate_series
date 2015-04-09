<?php

// Do not display deprecated errors as mysql_* is deprecated
error_reporting(E_ALL & ~E_DEPRECATED);

// MySQL connection
$link = mysql_connect('MY_HOST', 'MY_USER', 'MY_PASSWORD');
mysql_select_db('MY_DATABASE');

// Drop then create test table
mysql_query("DROP TABLE IF EXISTS test2;") or die("Query fail: ".mysql_error());
mysql_query("CREATE TABLE test2 (a datetime, b text);") or die("Query fail: ".mysql_error());

// Insert data in the test table
mysql_query("INSERT INTO test2 (a, b) VALUES ('2015-09-03 02:00:00', 'Line 1'), ('2015-09-03 14:00:00', 'Line 2');") or die("Query fail: ".mysql_error());

// Generate a series
mysql_query("CALL generate_series_date_hour_no_output('2015-09-03 00:00:00', '2015-09-03 23:00:00', 1);") or die("Query fail: ".mysql_error());

// Fetch content from the test table joined with the series
$result = mysql_query("SELECT series_tmp.series, test2.a, test2.b
FROM series_tmp
LEFT JOIN test2 ON series_tmp.series = test2.a
ORDER BY series_tmp.series;") or die("Query fail: ".mysql_error());

// Display result
echo "<table border='1'>
		<tr>
			<th>series</th>
			<th>a</th>
			<th>b</th>
		</tr>";
while ($row = mysql_fetch_assoc($result)) {
	echo "<tr>
			<td>".$row['series']."</td>
			<td>".$row['a']."</td>
			<td>".$row['b']."</td>
		</tr>";
}
echo "</table>";

// Close connection
mysql_close($link);
?>