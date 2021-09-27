<?php
$thisPage="updateitem";
include "helpers/admin.php";

if (!empty($_POST)) {
	include "helpers/opendb.php";

	$uploaddir = './uploads/';
	$uploadfile = $uploaddir . basename($_FILES['userfile']['name']);

	// actual upload bit

	$success = 1;
	$uploaded = 0;

	// Check if file already exists
	if (file_exists($uploadfile)) {
		echo "File exists already. ";
		$success = 0;
	}
	// Check file size
	if ($_FILES["userfile"]["size"] > 5000000) {
		echo "File bigger than 5 MB. ";
		$success = 0;
	}

	$filetype = pathinfo($uploadfile,PATHINFO_EXTENSION);
	if ($filetype != "jpg" && $filetype != "png" && $filetype != "jpeg"
		&& $filetype != "gif" ) {
		echo "We only accept JPG, JPEG, PNG & GIF files.. ";
		$success = 0;
	}

	if ($success == 0) {
		echo " Uploading failed.";
	} else {
		if (move_uploaded_file($_FILES["userfile"]["tmp_name"],
			$uploadfile)) {
			echo "The file ". basename( $_FILES["userfile"]["name"]) .
			" has been uploaded.";
			$uploaded = 1;
			//$uploadfile = "./../../" . basename($_FILES['userfile']['name']);
		} else {
			echo "Uploading failed, or you didn't upload a new image. ";
		}
	}

	$id = clean_input($_POST["id"]);
	$getinfo = $db->prepare('SELECT * FROM item_info WHERE id=?');
	$getinfo->bindValue(1, $id, PDO::PARAM_INT);
	$getinfo->execute();

	$inforow = $getinfo->fetch(PDO::FETCH_ASSOC);

	// Checks whether the forms are empty and if not empty updates the values
	if (!empty($_POST['name'])) {
		$name = clean_input($_POST["name"]);
		$stmt = $db->prepare('UPDATE item_info SET name=? WHERE id=?;');
		$stmt->bindValue(1, $name, PDO::PARAM_STR);
		$stmt->bindValue(2, $id, PDO::PARAM_INT);
		$stmt->execute();
	} 

	if (!empty($_POST['category'])) {
		$category = clean_input($_POST["category"]);
		$stmt = $db->prepare('UPDATE item_info SET category=? WHERE id=?;');
		$stmt->bindValue(1, $category, PDO::PARAM_STR);
		$stmt->bindValue(2, $id, PDO::PARAM_INT);
		$stmt->execute();
	} 

	if (!empty($_POST['legality'])) {
		$legality = clean_input($_POST["legality"]);
		$stmt = $db->prepare('UPDATE item_info SET legality=? WHERE id=?;');
		$stmt->bindValue(1, $legality, PDO::PARAM_INT);
		$stmt->bindValue(2, $id, PDO::PARAM_INT);
		$stmt->execute();
	} 

	if (!empty($_POST['capacity'])) {
		$capacity = clean_input($_POST["capacity"]);
		$stmt = $db->prepare('UPDATE item_info SET capacity=? WHERE id=?;');
		$stmt->bindValue(1, $capacity, PDO::PARAM_INT);
		$stmt->bindValue(2, $id, PDO::PARAM_INT);
		$stmt->execute();
	} 

	if (!empty($_POST['speedms'])) {
		$speedms = clean_input($_POST["speedms"]);
		$stmt = $db->prepare('UPDATE item_info SET speedms=? WHERE id=?;');
		$stmt->bindValue(1, $speedms, PDO::PARAM_INT);
		$stmt->bindValue(2, $id, PDO::PARAM_INT);
		$stmt->execute();
	} 

	if (!empty($_POST['ageyears'])) {
		$ageyears = clean_input($_POST["ageyears"]);
		$stmt = $db->prepare('UPDATE item_info SET ageyears=? WHERE id=?;');
		$stmt->bindValue(1, $ageyears, PDO::PARAM_INT);
		$stmt->bindValue(2, $id, PDO::PARAM_INT);
		$stmt->execute();
	} 

	if (!empty($_POST['description'])) {
		$description = clean_input($_POST["description"]);
		$stmt = $db->prepare('UPDATE item_info SET description=? WHERE id=?;');
		$stmt->bindValue(1, $description, PDO::PARAM_INT);
		$stmt->bindValue(2, $id, PDO::PARAM_INT);
		$stmt->execute();
	} 

	if (!empty($_POST['price'])) {
		$price = clean_input($_POST["price"]);
		$stmt = $db->prepare('UPDATE item_store SET price=? WHERE id=?;');
		$stmt->bindValue(1, $price, PDO::PARAM_INT);
		$stmt->bindValue(2, $id, PDO::PARAM_INT);
		$stmt->execute();
	}

	if (!empty($_POST['stock'])) {
		$stock = clean_input($_POST["stock"]);
		$stmt = $db->prepare('UPDATE item_store SET stock=? WHERE id=?;');
		$stmt->bindValue(1, $stock, PDO::PARAM_INT);
		$stmt->bindValue(2, $id, PDO::PARAM_INT);
		$stmt->execute();
	} 

	if ($uploaded == 1) {
		$stmt = $db->prepare('UPDATE item_info SET imglink=? WHERE id=?;');
		$stmt->bindValue(1, $uploadfile, PDO::PARAM_STR);
		$stmt->bindValue(2, $id, PDO::PARAM_INT);
		$stmt->execute();
	} 

	echo "<br /> <br />Apart from any image-related errors you may see above, ";
	echo "the item was successfully updated!. Redirection in 5. 4. 3. 2. 1.";
	
	$host = 'https://' . $_SERVER['HTTP_HOST'];
	header("Refresh:5; url=$host/item.php?page=$id.php", true, 303);
} else {
	print <<<EOT
	<form enctype="multipart/form-data"  method="post">
		ID (not changeable, see URL on the item's page): 
			<input type="number" name="id" required /> <br />
		Name: <input type="text" name="name" /> (Max 20 charachters)<br />
		Category: <input type="text" name="category"  /> <br />
		Legality: <input type="number" name="legality"  /> <br />
		Capacity: <input type="number" name="capacity"  /><br />
		Top Speed: <input type="number" name="speedms"  /><br />
		Year of construction: <input type="number" name="ageyears"  /><br />
		Description: <input type="text" name="description"  /><br />
		Price: <input type="number" name ="price"  /> <br />
		Stock: <input type="number" name="stock"  /> <br />

		Upload a square image: <input name="userfile" type="file" /> <br />

		<input type="submit" value="Update item" />
	</form>
EOT;
}
?>
