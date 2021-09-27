<?php
include "init.php";

if (isset($_GET['item'])) {
	include("opendb.php");
	$item_id = clean_input($_GET['item']);

	$getit = $db->prepare('SELECT stock FROM item_store WHERE id=?');
	$getit->bindValue(1, $item_id, PDO::PARAM_INT);
	$getit->execute();
	$result = $getit->fetch(PDO::FETCH_ASSOC);
	echo $result['stock'];
} else {
	echo "Please add a ?item=X to the URL.";
}
?>