<?php 
if (@$_SERVER['HTTPS'] !== 'on')
{
	$redirect = 'https://' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'];
	header("Location: " . $redirect, true, 301);
	exit();
}

session_start();

function clean_input($input)
{
	$input = trim($input);             // strip whitespace
	$input = stripslashes($input);     // remove slashes
	$input = htmlspecialchars($input); // escape HTML input
	return $input;
}
?>