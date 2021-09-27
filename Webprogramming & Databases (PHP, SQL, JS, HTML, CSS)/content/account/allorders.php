<?php
// first check if the current user is an admin
include "helpers/admin.php";
include "helpers/opendb.php";

if (!empty($_POST)) {
	// order ID and status to be changed are one $
	$idstatus = explode(";", $_POST['status']);
	$id = clean_input($idstatus[0]);
	$status = clean_input($idstatus[1]);

	// flip the bit representing the selected status
	$query = "UPDATE order_status SET " . $status . "=" .
		$status . " ^ 1 WHERE id=" . $id . ";";
	$stmt = $db->prepare($query);
	$stmt->execute();

	echo "Order " . $id . " now has its " . $status .
		" status flipped. <br /> <br />";
}
?>

<!-- draw the beggining of the table once -->
<table width= "100%" class="orders" cellpadding="5" cellspacing="5">
	<thead>
		<tr>
			<th>Order ID</th>
			<th>Customer ID</th>
			<th>Items</th>
			<th>Price (€)</th>
			<th>Date</th>
			<th>Status</th>
			<th>Change</th>
		</tr>
	</thead>
	<tbody>
		<?php
		// should select all from order_status, TODO
		// because order_info contains multiple rows per order
		$stmt= $db->prepare('SELECT * FROM order_info;');
		$stmt->execute();
		$lastorder_id = 0;

		$data = $stmt->fetchAll();
		foreach($data as $orderrow) {
			$order_id = $orderrow['order_id']; // only print each ID once
			if ($order_id != $lastorder_id) {
				echo "<tr>";
				echo "<td>" . $order_id . "</td>";
				echo "<td>" . $orderrow['account_id'] . "</td>";

				// this is going to be the items column
				echo "<td>";
				$stmt= $db->prepare('SELECT item_id FROM order_info
					WHERE order_id = ?;');
				$stmt->bindValue(1, $order_id, PDO::PARAM_INT);
				$stmt->execute();
				$allitems = $stmt->fetchAll();
				$first = true;
				foreach($allitems as $itemdata) {

					// seperate items with a ,, but don't start with one
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
				$stmt= $db->prepare('SELECT * FROM order_status
					WHERE id = ?;');
				$stmt->bindValue(1, $order_id, PDO::PARAM_INT);
				$stmt->execute();
				$statusrow = $stmt->fetch(PDO::FETCH_ASSOC);

				echo "<td>" . $statusrow['price'] . "</td>";
				echo "<td>" . $orderrow['date'] . "</td>";

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

				echo "<td>" . "
				<form action=\"\" method=\"POST\">
					<select name=\"status\" onchange=\"this.form.submit()\">
						<option selected>No change</option>
						<option value=\" " . $order_id .
							";paid\">Paid</option>
						<option value=\" " . $order_id .
							";delivered\">Delivered</option>
						<option value=\" " . $order_id .
							";shipped\">Shipped</option>
						<option value=\" " . $order_id .
							";cancelled\">Cancelled</option>
						<option value=\" " . $order_id .
							";unknown\">Unknown</option>
					</select>
				</form>
				" . "</td>";

				echo "</tr>";
			}
		}
		?>
	</tbody>
</table>
