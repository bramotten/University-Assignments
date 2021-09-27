<?php
if (isset($_SESSION['authenticated'])) {
	if (!isset($_SESSION['admin']) || $_SESSION['admin'] == 0) {
		echo "You're not logged in with an administrator account. ";
		exit();
	}
} else {
	$host = 'https://' . $_SERVER['HTTP_HOST'];
	header("Location: $host/index.php?page=login.php");
}
?>
