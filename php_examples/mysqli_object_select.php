<?php

// MySQL connection
$mysqli = new mysqli('MY_HOST', 'MY_USER', 'MY_PASSWORD');
$mysqli->select_db('MY_DATABASE');

// Drop then create test table
$mysqli->query("DROP TABLE IF EXISTS test2;") or die("Query fail: ".$mysqli->error);
$mysqli->query("CREATE TABLE test2 (a datetime, b text);") or die("Query fail: ".$mysqli->error);

// Insert data in the test table
$mysqli->query("INSERT INTO test2 (a, b) VALUES ('2015-09-03 02:00:00', 'Line 1'), ('2015-09-03 14:00:00', 'Line 2');") or die("Query fail: ".$mysqli->error);

// Generate a series
$mysqli->query("CALL generate_series_date_hour_no_output('2015-09-03 00:00:00', '2015-09-03 23:00:00', 1);") or die("Query fail: ".$mysqli->error);

// Fetch content from the test table joined with the series
$result = $mysqli->query("SELECT series_tmp.series, test2.a, test2.b
FROM series_tmp
LEFT JOIN test2 ON series_tmp.series = test2.a
ORDER BY series_tmp.series;") or die("Query fail: ".$mysqli->error);

// Display result
echo "<table border='1'>
		<tr>
			<th>series</th>
			<th>a</th>
			<th>b</th>
		</tr>";
while ($row = $result->fetch_object()) {
	echo "<tr>
			<td>".$row->series."</td>
			<td>".$row->a."</td>
			<td>".$row->b."</td>
		</tr>";
}
echo "</table>";

// Close connection
$mysqli->close();
?>