<?php
include "helpers/init.php";
if (isset($_GET['page'])) {
	include("helpers/opendb.php");

	// get all items from this category
	$pagename = clean_input($_GET['page']);
	$category = preg_replace('/\\.[^.\\s]{3,4}$/', '', $pagename);

	$getitem = $db->prepare('SELECT * FROM item_info WHERE category=?');
	$getitem->bindValue(1, $category, PDO::PARAM_INT);
	$getitem->execute();
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
</head>

<body>
	<div class="wrapper">
		<div class="nav">
			<?php include "content/navbar.php"; ?>
		</div>
		<div class="aside">
			<?php include "content/aside.php"; ?>
		</div>
		<div class="content" id="content">
			<div class="shop">
				<ul>
					<?php
					// catch URL errors
					$notfoundtext = "<h3>This may be a sort of 404:
							page content not found.</h3>Check the URL.
							If you didn't do anything with it yourself,
							we're really very sorry.";
					if (!isset($pagename)) {
						echo $notfoundtext;
					} else if ($pagename != "big.php" &&
						$pagename != "dangerous.php" &&
						$pagename != "useless.php" &&
						$pagename != "unreal.php") {
						echo $notfoundtext;
					} else {
						$counter = 0;
						while($itemrow = $getitem->fetch(PDO::FETCH_ASSOC)) {

							// cycle through all items, adding to list
							$counter += 1;
							$name = $itemrow['name'];
							$imglink = $itemrow['imglink'];
							$id = $itemrow['id'];

							$getprice = $db->prepare('SELECT * FROM item_store
								WHERE id=?');
							$getprice->bindValue(1, $id, PDO::PARAM_INT);
							$getprice->execute();
							$result = $getprice->fetch(PDO::FETCH_ASSOC);
							$price = $result['price'];

							echo "<li class=\"block\">";
							echo "<a href=\"item.php?page=" . $id . ".php\">";
							if (file_exists($imglink)) {
								echo "<img src=\"" . $imglink . "\" alt=\"" 
									. $name . "\" />";
							} else {
								echo "<img src=\"assets/altimg.jpg\" alt=\"" 
									. $name .  "\" />";
							}
							echo "<span>" . $name . "<br />";
							echo "€" . $price . ",-</span></a>";
							echo "</li>";
						}

						if ($counter == 0) {
							echo "This is a valid but empty category.";
						}
					}
					?>
				</ul>
			</div>
		</div>
		<div class="footer">
			<?php include "content/footer.php"; ?>
		</div>
	</div>
</body>

</html>
