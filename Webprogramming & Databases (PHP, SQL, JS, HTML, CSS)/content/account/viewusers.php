<?php
// first check if the current user is an admin
include "helpers/admin.php";
include "helpers/opendb.php";
?>

<table width= "100%" class="orders" cellpadding="5" cellspacing="5">
	<thead>
		<tr>
			<th>User id</th>
			<th>Name</th>
			<th>Email</th>
			<th>Adress</th>
			<th>city</th>
		</tr>
	</thead>
	<tbody>
<?php
//get user id
$stmt = $db->prepare('SELECT * FROM account_info;');
$stmt->execute();
$data = $stmt->fetchAll();
foreach ($data as $userrow) {
	//column for user id
	$user_id = $userrow['id'];
	echo "<tr>";
	echo "<td>" . $user_id . "</td>";
	//column for user first and last name
	echo "<td>";
	$stmt= $db->prepare('SELECT firstname FROM shipping_info
		WHERE id = ?;');
	$stmt->bindValue(1, $user_id, PDO::PARAM_INT);
	$stmt->execute();
	$userrow = $stmt->fetch(PDO::FETCH_ASSOC);
	echo $userrow['firstname'];
	echo " ";
	$stmt= $db->prepare('SELECT lastname FROM shipping_info
		WHERE id = ?;');
	$stmt->bindValue(1, $user_id, PDO::PARAM_STR);
	$stmt->execute();
	$userrow = $stmt->fetch(PDO::FETCH_ASSOC);
	echo $userrow['lastname'];
	echo "</td>";
	//column for user email
	echo "<td>";
	$stmt= $db->prepare('SELECT email FROM account_info where id = ?;');
	$stmt->bindValue(1, $user_id, PDO::PARAM_STR);
	$stmt->execute();
	$userrow = $stmt->fetch(PDO::FETCH_ASSOC);
	echo $userrow['email'];
	echo "</td><td>";
	$stmt= $db->prepare('SELECT street FROM shipping_info where id = ?;');
	$stmt->bindValue(1, $user_id, PDO::PARAM_STR);
	$stmt->execute();
	$userrow = $stmt->fetch(PDO::FETCH_ASSOC);
	echo $userrow['street'];
	echo " ";
	$stmt= $db->prepare('SELECT number FROM shipping_info where id = ?;');
	$stmt->bindValue(1, $user_id, PDO::PARAM_STR);
	$stmt->execute();
	$userrow = $stmt->fetch(PDO::FETCH_ASSOC);
	echo $userrow['number'] . "</td>";
	//columnn for user city
	echo "<td>";
	$stmt= $db->prepare('SELECT city FROM shipping_info where id = ?;');
	$stmt->bindValue(1, $user_id, PDO::PARAM_STR);
	$stmt->execute();
	$userrow = $stmt->fetch(PDO::FETCH_ASSOC);
	echo $userrow['city'];
	echo "</td>";

	echo "<td>";
	$stmt= $db->prepare('SELECT admin FROM account_info
		WHERE id = ?;');
	$stmt->bindValue(1, $user_id, PDO::PARAM_INT);
	$stmt->execute();
	$admin = $stmt->fetch(PDO::FETCH_ASSOC);
	$makeadmin = $user_id;
	$makepleb = $user_id;
	if ($admin['admin'] == 0) {

		echo "<form method='post' action=''>";
		echo "<button type='submit' name='$makeadmin' 
			style='width: 90px;'>Make admin</button>";
		echo "</form>";
	}
	if (isset($_POST[$makeadmin])) {
		$stmt=$db->prepare('UPDATE account_info SET admin="1" WHERE id = ?;');
		$stmt->bindvalue(1, $user_id, PDO::PARAM_INT);
		$stmt->execute();
		unset($_POST[$makeadmin]);
	}
}
	echo "</td></tr>";


echo "</tbody></table>";
?>
