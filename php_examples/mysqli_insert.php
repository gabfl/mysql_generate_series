<?php

// MySQL connection
$link = mysqli_connect('MY_HOST', 'MY_USER', 'MY_PASSWORD');
mysqli_select_db($link, 'MY_DATABASE');

// Drop then create test table
mysqli_query($link, "DROP TABLE IF EXISTS test;") or die("Query fail: ".mysqli_error($link));
mysqli_query($link, "CREATE TABLE test (a int, b text);") or die("Query fail: ".mysqli_error($link));

// Generate a series
mysqli_query($link, "CALL generate_series_no_output(1, 10);") or die("Query fail: ".mysqli_error($link));

// Insert all the rows from the series into the test table
mysqli_query($link, "INSERT INTO test (a, b) SELECT series, 'This is a test' FROM series_tmp") or die("Query fail: ".mysqli_error($link));

// Fetch content from the test table
$result = mysqli_query($link, "SELECT a, b FROM test;") or die("Query fail: ".mysqli_error($link));

// Display result
echo "<table border='1'>
		<tr>
			<th>a</th>
			<th>b</th>
		</tr>";
while ($row = mysqli_fetch_assoc($result)) {
	echo "<tr>
			<td>".$row['a']."</td>
			<td>".$row['b']."</td>
		</tr>";
}
echo "</table>";

// Close connection
mysqli_close($link);
?>