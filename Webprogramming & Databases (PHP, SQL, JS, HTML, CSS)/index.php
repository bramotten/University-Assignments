<!-- force HTTPS, start session, load input cleaner -->
<?php include "helpers/init.php"; ?>

<!DOCTYPE html>
<html lang="en-us">

<head>
	<meta charset="UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge" />

	<title>Locomotion</title>
	<link rel="shortcut icon" href="assets/icon.ico" type="image/x-icon" />
	<meta name="description" content="Buy crazy vehicles" />
	<meta name="keywords" content="Awesome, tanks, rockets" />

	<link rel="stylesheet" type="text/css" href="css/main.css" />
	<link rel="stylesheet" type="text/css" href="css/home.css" />
	<script type="text/javascript" src="js/register.js"></script>
	<script type="application/javascript" src="js/aboutus.js"></script>
	<noscript>Your browser does not support JavaScript!</noscript>
</head>

<body>
	<div class="wrapper">
		<div class="nav">
			<?PHP include "content/navbar.php" ?>
		</div>
		<div class="aside">
			<?php include "content/aside.php"; ?>
		</div>
		<div class="content" id="content">
		<!-- index.php is used by many pages that can be specified
		in the URL. The default content is the home content. -->
			<?php
	if (isset($_GET['page'])) {
		$page = "content/index/" . clean_input($_GET['page']);
	} else {
		$page = "content/index/home.php";
	}
	if (file_exists($page)) {
		include $page;
	} else {
		// because $_GET['page'] is used for loading content, an error in the 
		// URL would cause cryptic errors to be the content instead. A fix:
		echo "
			<h3>Sort of a 404: page content not found.</h3>
			Check the URL. If you didn't do anything with it yourself, 
			we're really very sorry.
		";
	}
	?>
		</div>
		<div class="footer">
			<?php include "content/footer.php"; ?>
		</div>
	</div>
</body>

</html>