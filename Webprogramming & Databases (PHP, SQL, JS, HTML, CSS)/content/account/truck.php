<?php
if (isset($_SESSION['authenticated'])) {
   include("helpers/opendb.php");
   if (isset($_POST['clear'])) {
		$clear= $db->prepare('DELETE FROM cart WHERE account_id = ?;');
		$clear->bindValue(1, $_SESSION['id'], PDO::PARAM_INT);
		$clear->execute();
		echo "Your truck has been emptied. ";
	} else if (isset($_POST['buy'])) {
		$date = date('Y-m-d H:i:s');
		$totalprice = 0;

		// get the next available order ID,
		// can't use autoincrement because multiple items will
		// take multiple rows
		$getlastid = $db->prepare('SELECT MAX(id) FROM order_status');
		$getlastid->execute();
		$maxId = (integer) $getlastid->fetch(PDO::FETCH_COLUMN);
		$nextid = $maxId + 1;

		// get the cart of this user
		$check = $db->prepare('SELECT * FROM cart WHERE account_id = ?;');
		$check->bindValue(1, $_SESSION['id'], PDO::PARAM_INT);
		$check->execute();
		
		// add the items on it to order_info
		while ($itemrow = $check->fetch(PDO::FETCH_ASSOC)) {
			$account_id = $itemrow['account_id'];
			$item_id = $itemrow['item_id'];
			$amount = $itemrow['amount'];

			$info = $db->prepare('INSERT INTO order_info
				(account_id, item_id, date, order_id) VALUES (?, ?, ?, ?);');
			$info->bindValue(1, $account_id, PDO::PARAM_INT);
			$info->bindValue(2, $item_id, PDO::PARAM_INT);
			$info->bindValue(3, $date, PDO::PARAM_STR);
			$info->bindValue(4, $nextid, PDO::PARAM_INT);

			$iteminfo = $db->prepare('SELECT * FROM item_store
				WHERE id = ?;');
			$iteminfo->bindValue(1, $item_id, PDO::PARAM_INT);
			$iteminfo->execute();
			$inforow = $iteminfo->fetch(PDO::FETCH_ASSOC);

			$price = $inforow['price'];
			$stock = $inforow['stock'];
			if ($stock < $amount) {
				$itemname = $db->prepare('SELECT name FROM item_info
				WHERE id = ?;');
				$itemname->bindValue(1, $item_id, PDO::PARAM_INT);
				$itemname->execute();
				$namerow = $itemname->fetch(PDO::FETCH_ASSOC);

				echo "Sorry, you're buying more of item " .
				 	$namerow['name'] . " than we have in stock`right now.";
				exit();
			} else {
				// subtract from stock in the database
				$newstock = $stock - $amount;
				$stmt = $db->prepare('UPDATE item_store SET stock=?
					WHERE id=?;');
				$stmt->bindValue(1, $newstock, PDO::PARAM_INT);
				$stmt->bindValue(2, $item_id, PDO::PARAM_INT);
				$stmt->execute();

				for ($i = 0; $i < $amount; $i++) {
					$info->execute();
					$totalprice = $totalprice + $price;
				}
			}
		}

		// create order status, skipping the payment thing for now
		$status = $db->prepare('INSERT INTO order_status (id, price, paid)
			VALUES (?, ?, ?);');
		$status->bindValue(1, $nextid, PDO::PARAM_INT);
		$status->bindValue(2, $totalprice, PDO::PARAM_INT);
		$status->bindValue(3, 1, PDO::PARAM_INT);
		$status->execute();

		$clear= $db->prepare('DELETE FROM cart WHERE account_id = ?;');
		$clear->bindValue(1, $_SESSION['id'], PDO::PARAM_INT);
		$clear->execute();
		echo "<br />Done. Your order ID is " . $nextid .
			". Thank you for shopping at LocoMotion!";

		// redirect to the user's orders
		$host = 'https://' . $_SERVER['HTTP_HOST'];
		header("Location: $host/account.php?page=orders.php");

	} else {

		// this is where the user gets shown their cart, before pressing buts
		$check= $db->prepare('SELECT * FROM cart WHERE account_id = ?;');
		$check->bindValue(1, $_SESSION['id'], PDO::PARAM_INT);
		$check->execute();

		$counter = 0;
		$totalprice = 0;
		$data = $check->fetchAll();
		foreach($data as $cartrow) {
			if ($counter == 0) {
				print <<<EOT
				<table id='orderstable' width= "100%" class="orders"
					cellpadding="5" cellspacing="5">
				<thead>
				<tr>

					<th>Item ID</th>
					<th>Item name</th>
					<th>Amount</th>
					<th>Price (per item)</th>
				</tr>
				</thead>
				<tbody>
EOT;
			}
			$counter = $counter + 1;
			echo "<tr>";
			$itemid = $cartrow['item_id'];
			echo "<td>" . $itemid . "</td>";

			echo "<td>";
			$stmt= $db->prepare('SELECT name FROM item_info WHERE id = ?;');
			$stmt->bindValue(1, $cartrow['item_id'], PDO::PARAM_INT);
			$stmt->execute();
			$itemrow = $stmt->fetch(PDO::FETCH_ASSOC);
			echo "<a href=\"item.php?page=" . $itemid . ".php\">";
			echo $itemrow['name'] . "</a></td>";

			$stmt= $db->prepare('SELECT * FROM item_store WHERE id = ?;');
			$stmt->bindValue(1, $cartrow['item_id'], PDO::PARAM_INT);
			$stmt->execute();
			$stockrow = $stmt->fetch(PDO::FETCH_ASSOC);

			echo "<td>";
    		echo $cartrow['amount'];
			echo "</td>";

			echo "<td>";
			$multiprice = $stockrow['price'] * $cartrow['amount'];
			echo "€" . $multiprice . ",-";
			echo " (" . $stockrow['price'] . ")";
			echo "</td>";
			$totalprice = $totalprice + $multiprice;

			echo "<td>";
			echo "<form method='post' action=''>";
			echo "<button type='submit' name='$itemid'>Remove item</button>";
			echo "</form>";

			// the remove button gets the id of the row it is in
			// to know which item to remove from the database
			if (isset($_POST[$itemid])){
				$stmt= $db->prepare('DELETE FROM cart WHERE item_id = ?
					AND account_id = ?;');
				$stmt->bindValue(1, $itemid, PDO::PARAM_INT);
				$stmt->bindValue(2, $cartrow['account_id'], PDO::PARAM_STR);
				$stmt->execute();
				unset($_POST[$itemid]);
				header("Refresh:0");
			}

			echo "</td></tr>";
		}

		if ($counter == 0) {
			echo "Your truck is empty. <br />";
		} else {
			print <<<EOT
			</tbody></table><br />
			Total price = €$totalprice,-
			<form method="post" >
				<br />
				<button type="submit" name="buy">Buy all of this</button>
				<button type="submit" name="clear">Unload all of this</button>
			</form>
EOT;
		}
	}
} else {
	$host = 'https://' . $_SERVER['HTTP_HOST'];
	header("Location: $host/index.php?page=login.php");
}
?>
