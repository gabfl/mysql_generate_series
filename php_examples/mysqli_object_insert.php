<?php

// MySQL connection
$mysqli = new mysqli('MY_HOST', 'MY_USER', 'MY_PASSWORD');
$mysqli->select_db('MY_DATABASE');

// Drop then create test table
$mysqli->query("DROP TABLE IF EXISTS test;") or die("Query fail: ".$mysqli->error);
$mysqli->query("CREATE TABLE test (a int, b text);") or die("Query fail: ".$mysqli->error);

// Generate a series
$mysqli->query("CALL generate_series_no_output(1, 10);") or die("Query fail: ".$mysqli->error);

// Insert all the rows from the series into the test table
$mysqli->query("INSERT INTO test (a, b) SELECT series, 'This is a test' FROM series_tmp") or die("Query fail: ".$mysqli->error);

// Fetch content from the test table
$result = $mysqli->query("SELECT a, b FROM test;") or die("Query fail: ".$mysqli->error);

// Display result
echo "<table border='1'>
		<tr>
			<th>a</th>
			<th>b</th>
		</tr>";
while ($row = $result->fetch_object()) {
	echo "<tr>
			<td>".$row->a."</td>
			<td>".$row->b."</td>
		</tr>";
}
echo "</table>";

// Close connection
$mysqli->close();
?>