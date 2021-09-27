<?php
include "helpers/init.php";

if (isset($_GET['page'])) {
	include("helpers/opendb.php");

	// select data corresponding to this item from the database
	$pagename = clean_input($_GET['page']);

	$item_id = preg_replace('/\\.[^.\\s]{3,4}$/', '', $pagename);
	$getinfo = $db->prepare('SELECT * FROM item_info WHERE id=?');
	$getinfo->bindValue(1, $item_id, PDO::PARAM_INT);
	$getinfo->execute();

	$inforow = $getinfo->fetch(PDO::FETCH_ASSOC);
	$name = $inforow['name'];

	// or acknowledge this item doesn't exist
	if ($name == "") {
		$noitem = true;
	}

	$category = $inforow['category'];
	$legality = $inforow['legality'];
	$capacity = $inforow['capacity'];
	$speedms = $inforow['speedms'];
	$ageyears = $inforow['ageyears'];
	$description = $inforow['description'];
	$imglink = $inforow['imglink'];

	$getstore = $db->prepare('SELECT * FROM item_store WHERE id=?');
	$getstore->bindValue(1, $item_id, PDO::PARAM_INT);
	$getstore->execute();

	$storerow = $getstore->fetch(PDO::FETCH_ASSOC);
	$price = $storerow['price'];
	$stock = $storerow['stock'];

	// add to cart/truck
	if (isset($_POST['loadtruck'])) {
		if (isset($_SESSION['authenticated'])) {

			$check= $db->prepare('SELECT * FROM cart WHERE (account_id = ?
				AND item_id = ?);');
			$check->bindValue(1, $_SESSION['id'], PDO::PARAM_INT);
			$check->bindValue(2, $item_id, PDO::PARAM_INT);
			$check->execute();
			$itemrow = $check->fetch(PDO::FETCH_ASSOC);

			// if this item is already in the truck/cart, only update
			$amount = clean_input($_POST['amount']);
			if ($itemrow) {
				$incre= $db->prepare('UPDATE cart SET amount = amount + ?
					WHERE id=?;');
				$incre->bindValue(1, $amount, PDO::PARAM_INT);
				$incre->bindValue(2, $itemrow['id'], PDO::PARAM_INT);
				$incre->execute();
			} else {
				$add = $db->prepare('INSERT INTO cart
					(account_id, item_id, amount) VALUES (?, ?, ?);');
				$add->bindValue(1, $_SESSION['id'], PDO::PARAM_INT);
				$add->bindValue(2, $item_id, PDO::PARAM_INT);
				$add->bindValue(3, $amount, PDO::PARAM_INT);
				$add->execute();
			}

			// update date on the items in this person's cart,
			date_default_timezone_set('UTC');
			$dateup = $db->prepare('UPDATE cart SET date = ?
				WHERE account_id = ?;');
			$dateup->bindValue(1, date("Y-m-d"), PDO::PARAM_STR);
			$dateup->bindValue(2, $_SESSION['id'], PDO::PARAM_INT);
			$dateup->execute();

		} else {
			// link back to login
			$host = 'https://' . $_SERVER['HTTP_HOST'];
			header("Location: $host/index.php?page=login.php");
		}
	} else if (isset($_POST['remove'])) {
		include "helpers/admin.php";
		$del = $db->prepare('DELETE FROM item_info WHERE id=?;');
		$del->bindValue(1, $item_id, PDO::PARAM_INT);
		$del->execute();

		// redirect to the category
		$host = 'https://' . $_SERVER['HTTP_HOST'];
		header("Location: $host/shop.php?page=$category.php");
	}
}
?>

<!DOCTYPE html>
<html lang="en-us">

<head>
	<meta charset="UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge" />

	<title>Shop Locomotion</title>
	<link rel="shortcut icon" href="assets/icon.ico" type="image/x-icon" />
	<meta name="description" content="Buy crazy vehicles" />
	<meta name="keywords" content="Awesome, tanks, rockets" />

	<link rel="stylesheet" type="text/css" href="css/main.css" />
	<link rel="stylesheet" type="text/css" href="css/item.css" />
	<script type="application/javascript" src="js/itemstock.js"></script>
	<script>
		window.onload = function () {
			checkstock(<?php echo $item_id; ?>);
		}
	</script>
	<noscript>Your browser does not support JavaScript!</noscript>
</head>

<body>
	<div class="wrapper">
		<div class="nav">
			<?PHP include "content/navbar.php"; ?>
		</div>
		<div class="aside">
			<?php include "content/aside.php"; ?>
		</div>
		<div class="content" id="content">
			<?php if (isset($noitem)) : ?>
			<h3>Sort of a 404: page content not found.</h3>
			Check the URL. If you didn't do anything with it yourself,
			we're really very sorry.
			<?php else : ?>
			<div class="singleitem">
				<h2 id="producttitle"><?php echo $name; ?></h2>
				<div class="productpic">
					<img src="<?php
						if (file_exists($imglink)) {
							echo $imglink;
						} else {
							echo "assets/altimg.jpg";
						}
					?>" alt="picture of <?php echo $name; ?>" /> <br />
				</div>
				<div class="right">
					<div class="productspecs">
					<h3> Specifications </h3>
					<div class="specs">
						<table>
						<tr>
							<td> Legality</td>
							<td> <?php echo $legality ?>% </td>
						</tr>
						<tr>
							<td> Vehicle capacity</td>
							<td> <?php echo $capacity ?> persons</td>
						</tr>
						<tr>
							<td> Top speed</td>
							<td> <?php echo $speedms ?> m/s </td>
						</tr>
						<tr>
							<td> Year of construction </td>
							<td> <?php echo $ageyears ?> A.D </td>
						</tr>
						</table>
					</div>
					<br />
					<div class="productinfo">
						<?php echo $description ?>
					</div>
					<h4 id="productprice">€<?php echo $price; ?>,-</h4>
					<h5><div id="stock">
						Please check the stock with the button below.
					</div></h5>
					<form onsubmit="checkstock(<?php echo $item_id; ?>);
						return false;">
						<input type="submit" value="Refresh stock" />
					</form>
					</div>
				</div>
			</div>
			<?php if (isset($_SESSION['admin']) &&
				$_SESSION['admin'] == 1) : ?>
				<form  method="post">
					<button type="submit" name = "remove">
						Remove item </button>
				</form>
			<?php endif; ?>
			<?php endif; ?>
		</div>

		<div class="footer">
			<?php include "content/footer.php"; ?>
		</div>
	</div>
</body>

</html>
