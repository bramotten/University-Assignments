<?php
$thisPage="userdata";
if (isset($_SESSION['authenticated'])) {
	if (empty($_POST)) {
		include "helpers/opendb.php";
		$id = $_SESSION['id'];

		// get this users data from shipping row
		$get_shipping_info = $db->prepare('SELECT * FROM shipping_info
			WHERE id=?');
		$get_shipping_info->bindValue(1, $id, PDO::PARAM_INT);
		$get_shipping_info->execute();
		$shipping_info_row = $get_shipping_info->fetch(PDO::FETCH_ASSOC);

		// get account info
		$get_account_info = $db->prepare('SELECT * FROM account_info
			WHERE id=?');
		$get_account_info->bindValue(1, $id, PDO::PARAM_INT);
		$get_account_info->execute();
		$account_info_row = $get_account_info->fetch(PDO::FETCH_ASSOC);

		// assign all the columns this user has and use as placeholder later
		$email = $account_info_row['email'];
		$firstname = $shipping_info_row['firstname'];
		$inbetweennames = $shipping_info_row['inbetweennames'];
		$lastname = $shipping_info_row['lastname'];
		$city = $shipping_info_row['city'];
		$country = $shipping_info_row['country'];
		$street = $shipping_info_row['street'];
		$number = $shipping_info_row['number'];
		$letter = $shipping_info_row['letter'];

		print <<<EOT
		<div id="register">
			<h4>Update my info</h4>
			<form  method="post">
				Enter current email and password: <br />
				Email adress: <input type="email" name="email"
					placeholder="$email" required /> <br />
				Password: <input type="password" name="password"
					placeholder="type your password" require /> <br />
				<br /> Now change the fields you want to update. <br />
				First name: <input type="text" name="firstname"
					placeholder="$firstname" /> <br />
				Names inbetween: <input type="text" name="inbetweennames"
					placeholder="$inbetweennames" /> <br />
				Last name: <input type="text" name="lastname"
					placeholder="$lastname" /> <br />
				Street: <input type="text" name="street"
					placeholder="$street" /> <br />
				Number: <input type="number" name="number"
					placeholder="$number" /> <br />
				Letter: <input type="text" name="letter"
					placeholder="$letter" /> <br />
				City: <input type="text" name="city"
					placeholder="$city" /> <br />
				Country: <select name="country">
					<option value="" selected> Unchanged ($country) </option>
					<option value="The Netherlands">The Netherlands</option>
					<option value="DPRK">DPRK</option>
					<option value="Belgium">Belgium</option>
					<option value="France">France</option>
					<option value="Germany">Germany</option>
					<option value="USA">United States of America</option>
				</select><br /><br />
				<input type="submit" value="Date me up" />
			</form>
		</div>
EOT;
	} else {
		// the form has been submitted when getting here
		include("helpers/opendb.php");

		$email = clean_input($_POST['email']);
		$password = clean_input($_POST['password']);
		$success = false;

		// verify email and password
		$login = $db->prepare('SELECT password FROM account_info
				WHERE email=?');
		$login->bindValue(1, $email, PDO::PARAM_STR);
		$login->execute();

		$result = $login->fetch(PDO::FETCH_NUM);
		if ($result) {
			if (password_verify($password, $result[0])) {
				$success = true;

				/*
				// make only the current account changeable, possibly useful

				$getid = $db->prepare('SELECT id FROM account_info
					WHERE email=?');
				$getid->bindValue(1, $email, PDO::PARAM_STR);
				$getid->execute();

				$row = $getid->fetch(PDO::FETCH_ASSOC);
				$id = $row['id'];
				if ($id != $_SESSION['id']) {
					echo "login with your own account please";
					$success = false;
				}
				*/
			}
		}
		if ($success == true) {
			echo "Updated succesfully! <br /> <br />
				This happened: <br /><br />";

			$id = $_SESSION['id'];
			$get_shipping_info = $db->prepare('SELECT * FROM shipping_info 
				WHERE id=?');
			$get_shipping_info->bindValue(1, $id, PDO::PARAM_INT);
			$get_shipping_info->execute();

			$shipping_info_row = $get_shipping_info->fetch(PDO::FETCH_ASSOC);

			// update all changed fields
			// this could have been done in a big UPDATE
			if ($_POST['firstname'] != "") {
				$get_shipping_info = $db->prepare('UPDATE shipping_info 
					SET firstname=? WHERE id=?');
				$get_shipping_info->bindValue(1, 
					clean_input($_POST['firstname']), PDO::PARAM_STR);
				$get_shipping_info->bindValue(2, $id, PDO::PARAM_INT);
				$get_shipping_info->execute();
				echo "First name changed <br />";
			} else {
				echo "First name remained the same <br />";

			}
			if ($_POST['inbetweennames'] != "") {
				$get_shipping_info = $db->prepare('UPDATE shipping_info 
					SET inbetweennames=? WHERE id=?');
				$get_shipping_info->bindValue(1, 
					clean_input($_POST['inbetweennames']), PDO::PARAM_STR);
				$get_shipping_info->bindValue(2, $id, PDO::PARAM_INT);
				$get_shipping_info->execute();
				echo "Names inbetween changed <br />";
			} else {
				echo "Names inbetween remained the same <br />";

			}
			if ($_POST['lastname'] != "") {
				$get_shipping_info = $db->prepare('UPDATE shipping_info 
					SET lastname=? WHERE id=?');
				$get_shipping_info->bindValue(1, 
					clean_input($_POST['lastname']), PDO::PARAM_STR);
				$get_shipping_info->bindValue(2, $id, PDO::PARAM_INT);
				$get_shipping_info->execute();
				echo "Last name changed <br />";
			} else {
				echo "Laste name remained the same <br />";

			}
			if ($_POST['street'] != "") {
				$get_shipping_info = $db->prepare('UPDATE shipping_info 
					SET street=? WHERE id=?');
				$get_shipping_info->bindValue(1, 
					clean_input($_POST['street']), PDO::PARAM_STR);
				$get_shipping_info->bindValue(2, $id, PDO::PARAM_INT);
				$get_shipping_info->execute();
				echo "Street name changed <br />";
			} else {
				echo "Street name remained the same <br />";

			}
			if ($_POST['number'] != "") {
				$get_shipping_info = $db->prepare('UPDATE shipping_info 
					SET number=? WHERE id=?');
				$get_shipping_info->bindValue(1, 
					clean_input($_POST['number']), PDO::PARAM_STR);
				$get_shipping_info->bindValue(2, $id, PDO::PARAM_INT);
				$get_shipping_info->execute();
				echo "Number changed <br />";
			} else {
				echo "Number remained the same <br />";

			}
			if ($_POST['letter'] != "") {
				$get_shipping_info = $db->prepare('UPDATE shipping_info 
					SET letter=? WHERE id=?');
				$get_shipping_info->bindValue(1, 
					clean_input($_POST['letter']), PDO::PARAM_STR);
				$get_shipping_info->bindValue(2, $id, PDO::PARAM_INT);
				$get_shipping_info->execute();
				echo "Letter changed <br />";
			} else {
				echo "Letter remained the same <br />";

			}
			if ($_POST['city'] != "") {
				$get_shipping_info = $db->prepare('UPDATE shipping_info 
					SET city=? WHERE id=?');
				$get_shipping_info->bindValue(1, 
					clean_input($_POST['city']), PDO::PARAM_STR);
				$get_shipping_info->bindValue(2, $id, PDO::PARAM_INT);
				$get_shipping_info->execute();
				echo "City changed <br />";
			} else {
				echo "City remained the same <br />";
			}
			if ($_POST['country'] != "") {
				$get_shipping_info = $db->prepare('UPDATE shipping_info 
					SET country=? WHERE id=?');
				$get_shipping_info->bindValue(1, 
					clean_input($_POST['country']), PDO::PARAM_STR);
				$get_shipping_info->bindValue(2, $id, PDO::PARAM_INT);
				$get_shipping_info->execute();
				echo "Country changed <br />";
			} else {
				echo "Country remained the same <br />";
			}
		} else {
			echo "Wrong password?";

		}
		print <<<EOT
		<br />
		<!-- submitting this form clears POST -->
		<form>
			<input type="submit" value="Return to user data" />
		</form>
EOT;
	}
} else {
	$host = 'https://' . $_SERVER['HTTP_HOST'];
	header("Location: $host/index.php?page=login.php");
}
?>
