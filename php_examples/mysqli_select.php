<?php

// MySQL connection
$link = mysqli_connect('MY_HOST', 'MY_USER', 'MY_PASSWORD');
mysqli_select_db($link, 'MY_DATABASE');

// Drop then create test table
mysqli_query($link, "DROP TABLE IF EXISTS test2;") or die("Query fail: ".mysqli_error());
mysqli_query($link, "CREATE TABLE test2 (a datetime, b text);") or die("Query fail: ".mysqli_error());

// Insert data in the test table
mysqli_query($link, "INSERT INTO test2 (a, b) VALUES ('2015-09-03 02:00:00', 'Line 1'), ('2015-09-03 14:00:00', 'Line 2');") or die("Query fail: ".mysqli_error());

// Generate a series
mysqli_query($link, "CALL generate_series_date_hour_no_output('2015-09-03 00:00:00', '2015-09-03 23:00:00', 1);") or die("Query fail: ".mysqli_error());

// Fetch content from the test table joined with the series
$result = mysqli_query($link, "SELECT series_tmp.series, test2.a, test2.b
FROM series_tmp
LEFT JOIN test2 ON series_tmp.series = test2.a
ORDER BY series_tmp.series;") or die("Query fail: ".mysqli_error());

// Display result
echo "<table border='1'>
		<tr>
			<th>series</th>
			<th>a</th>
			<th>b</th>
		</tr>";
while ($row = mysqli_fetch_assoc($result)) {
	echo "<tr>
			<td>".$row['series']."</td>
			<td>".$row['a']."</td>
			<td>".$row['b']."</td>
		</tr>";
}
echo "</table>";

// Close connection
mysqli_close($link);
?>