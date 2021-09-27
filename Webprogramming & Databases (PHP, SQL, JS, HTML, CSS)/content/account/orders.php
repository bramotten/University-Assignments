<?php

if (isset($_SESSION['authenticated'])) {
	include("helpers/opendb.php");

} else {
	$host = 'https://' . $_SERVER['HTTP_HOST'];
	header("Location: $host/index.php?page=login.php");
}
?>

<table id='orderstable' width= "100%" class="orders" 
	cellpadding="5" cellspacing="5">
	<thead>
		<tr>
			<th>Order ID</th>
			<th>Items</th>
			<th>Price</th>
			<th>Date</th>
			<th>Status</th>
		</tr>
	</thead>
	<tbody>
		<?php
		$id = $_SESSION['id'];
		$stmt= $db->prepare('SELECT * FROM order_info WHERE account_id = ?;');
		$stmt->bindValue(1, $id, PDO::PARAM_INT);
		$stmt->execute();
		$lastorder_id = 0;

		$data = $stmt->fetchAll();
		foreach($data as $inforow) {
			$order_id = $inforow['order_id'];
			if ($order_id != $lastorder_id) {
				echo "<tr>";
				echo "<td>" . $order_id . "</td>";

				echo "<td>";
				$stmt= $db->prepare('SELECT item_id FROM order_info 
					WHERE order_id = ?;');
				$stmt->bindValue(1, $order_id, PDO::PARAM_INT);
				$stmt->execute();
				$allitems = $stmt->fetchAll();
				$first = true;
				foreach($allitems as $itemdata) {
					if ($first) {
						$first = false;
					} else {
						echo ", ";
					}
					$stmt= $db->prepare('SELECT name FROM item_info 
						WHERE id = ?;');
					$stmt->bindValue(1, $itemdata['item_id'], PDO::PARAM_INT);
					$stmt->execute();
					$itemrow = $stmt->fetch(PDO::FETCH_ASSOC);
					echo $itemrow['name'];
				}
				echo "</td>";
				$lastorder_id = $order_id;
				$stmt= $db->prepare('SELECT * FROM order_status WHERE id = ?;');
				$stmt->bindValue(1, $order_id, PDO::PARAM_INT);
				$stmt->execute();
				$statusrow = $stmt->fetch(PDO::FETCH_ASSOC);

				echo "<td>€" . $statusrow['price'] . ",-</td>";
				echo "<td>" . $inforow['date'] . "</td>";

				echo "<td>";
				if ($statusrow['unknown'] == 1) {
					echo "unknown";
				} else {
					$first = true;
					if ($statusrow['paid'] == 1) {
						if ($first) {
							$first = false;
						} else {
							echo ", ";
						}
						echo "paid";
					}
					if ($statusrow['cancelled'] == 1) {
						if ($first) {
							$first = false;
						} else {
							echo ", ";
						}
						echo "cancelled";
					}
					if ($statusrow['shipped'] == 1) {
						if ($first) {
							$first = false;
						} else {
							echo ", ";
						}
						echo "shipped";
					}
					if ($statusrow['delivered'] == 1) {
						if ($first) {
							$first = false;
						} else {
							echo ", ";
						}
						echo "delivered";
					}
				}

				echo "</td>";
				echo "</tr>";
			}
		}
		?>
	</tbody>
</table>
