<?php
session_start();

// remove all session variables
session_unset();

// destroy the session
session_destroy();

// redirect to homepage
$host = 'https://' . $_SERVER['HTTP_HOST'];
header("Location: $host");
exit();
?>
