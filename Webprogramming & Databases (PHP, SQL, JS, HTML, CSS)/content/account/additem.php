<?php
include "helpers/admin.php";
$thisPage="userdata";

if (!empty($_POST["name"])) {
	include "helpers/opendb.php";

	$price = clean_input($_POST["price"]);
	$stock = clean_input($_POST["stock"]);
	$category = clean_input($_POST["category"]);
	$name = clean_input($_POST["name"]);
	$legality = clean_input($_POST["legality"]);
	$capacity = clean_input($_POST["capacity"]);
	$speedms = clean_input($_POST["speedms"]);
	$ageyears = clean_input($_POST["ageyears"]);
	$description = clean_input($_POST["description"]);

	$uploaddir = './uploads/';
	$uploadfile = $uploaddir . basename($_FILES['userfile']['name']);

	// actual upload bit
	$success = 1;

	// Check if file already exists
	if (file_exists($uploadfile)) {
		echo "Image file exists already. ";
		$success = 0;
	}
	// Check file size (must be under 5MB)
	if ($_FILES["userfile"]["size"] > 5000000) {
		echo "Image file bigger than 5 MB. ";
		$success = 0;
	}

	$filetype = pathinfo($uploadfile,PATHINFO_EXTENSION);
	if ($filetype != "jpg" && $filetype != "png" && $filetype != "jpeg" 
		&& $filetype != "gif" ) {
		echo "We only accept JPG, JPEG, PNG & GIF files.. ";
		$success = 0;
	}

	if ($success == 0) {
		// give the user back a form with the previous data filled in
		echo "Uploading failed. <br /> <br />";
		print <<<EOT
		<h3> Add item </h3>
		<form enctype="multipart/form-data"  method="post">
			Name: <input type="text" name="name" value="$name" required /> 
			<br /> Category:
			<select name="category" required />
				<option value="$category">previous ($category)</option>
				<option value="big">big</option>
				<option value="dangerous">dangerous</option>
				<option value="useless">useless</option>
				<option value="unreal">unreal</option>
			</select> <br />
			Legality: <input type="number" name="legality" 
				value="$legality" required /> <br />
			Capacity: <input type="number" name="capacity" 
				value="$capacity" required /><br />
			Top Speed: <input type="number" name="speedms" 
				value="$speedms" required /><br />
			Year of construction: <input type="number" name="ageyears" 
				value="$ageyears" required /><br />
			Description: <input type="text" name="description" 
				value="$description" required /><br />
			Price: <input type="text" name ="price" 
				value="$price" required /> <br />
			Stock: <input type="number" name="stock" 
				value="$stock" required /> <br />

			Upload a square image: <input name="userfile" type="file" />
			<br /><br />

			<input type="submit" value="Add item" />
		</form>
EOT;
	} else {
		if (move_uploaded_file($_FILES["userfile"]["tmp_name"],
			$uploadfile)) {
			echo "The file ". basename( $_FILES["userfile"]["name"]) .
				" has been uploaded. This article is now ready to be sold.";
		} else {
			echo " Uploading failed.";
			$success = 0;
		}
	}

	$price = clean_input($_POST["price"]);
	$stock = clean_input($_POST["stock"]);

	$stmt = $db->prepare('INSERT INTO item_store (price, stock)
		VALUES (?, ?);');

	$stmt->bindValue(1, $price, PDO::PARAM_INT);
	$stmt->bindValue(2, $stock, PDO::PARAM_INT);
	$stmt->execute();

	$id = $db->lastInsertId();
	$category = clean_input($_POST["category"]);
	$name = clean_input($_POST["name"]);
	$legality = clean_input($_POST["legality"]);
	$capacity = clean_input($_POST["capacity"]);
	$speedms = clean_input($_POST["speedms"]);
	$ageyears = clean_input($_POST["ageyears"]);
	$description = clean_input($_POST["description"]);

	$stmt = $db->prepare('INSERT INTO item_info
		(id, category, name, legality, capacity, speedms, ageyears,
			description, imglink) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?);');

	$stmt->bindValue(1, $id, PDO::PARAM_INT);
	$stmt->bindValue(2, $category, PDO::PARAM_STR);
	$stmt->bindValue(3, $name, PDO::PARAM_STR);
	$stmt->bindValue(4, $legality, PDO::PARAM_INT);
	$stmt->bindValue(5, $capacity, PDO::PARAM_INT);
	$stmt->bindValue(6, $speedms, PDO::PARAM_INT);
	$stmt->bindValue(7, $ageyears, PDO::PARAM_INT);
	$stmt->bindValue(8, $description, PDO::PARAM_STR);
	$stmt->bindValue(9, $uploadfile, PDO::PARAM_STR);
	if ($success == 0) {
		exit();
	} else {
		$stmt->execute();
		$host = 'https://' . $_SERVER['HTTP_HOST'];
		header("Location: $host/item.php?page=$id.php");
		exit();
	}
} else {
	print <<<EOT
	<form enctype="multipart/form-data"  method="post">
		Name: <input type="text" name="name" required /> (max 20 characters)
		 <br /> Category:
		<select name="category" required />
			<option value="big">big</option>
			<option value="dangerous">dangerous</option>
			<option value="useless">useless</option>
			<option value="unreal">unreal</option>
		</select> <br />
		Legality: <input type="number" name="legality" required /> <br />
		Capacity: <input type="number" name="capacity" required /><br />
		Top Speed: <input type="number" name="speedms" required /><br />
		Year of construction: <input type="number" 
			name="ageyears" required /><br />
		Description: <input type="text" name="description" required /><br />
		Price: <input type="text" name ="price" required /> <br />
		Stock: <input type="number" name="stock" required /> <br />

		Upload a square image: <input name="userfile" type="file" /><br /><br />

		<input type="submit" value="Add item" />
	</form>
EOT;
}
?>
