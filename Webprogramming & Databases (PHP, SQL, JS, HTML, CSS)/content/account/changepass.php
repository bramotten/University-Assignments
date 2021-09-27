<?php
$thisPage="changepass";
if(isset($_SESSION['authenticated'])) {
	if(empty($_POST['password'])) {
		$email = $_SESSION['email'];
		print <<<EOT
		<div id="changepass">
			<h3>Change my password</h3>
			<form  method="post">
				Enter email: <input type="text" name="email"
					value="$email" /> <br />
				Enter current password: <input type="password" 
					name="password" /> <br /><br />
				 Enter new password: <input type="password"
					name="newpassword" /> <br />
				Enter new password again: <input type="password"
					name="newpassword2" /> <br /> <br />
				<input type="submit" value="Change my password" />
			</form>
		</div>
EOT;

	} else {
			
		// check if the new password is of the right length
		$newpass = clean_input($_POST['newpassword']);
		if (strlen($newpass) < 6 || strlen($newpass) > 127) {
			echo "Please choose a password with a length between 
				6 and 128 characters.";
				header("Refresh: 3");
				exit();
		}
		
		include("helpers/opendb.php");

		// get the email from POST, meaning you could change the
		// passwords off other accounts
		$email = clean_input($_POST['email']);
		$password = clean_input($_POST['password']);
		$hash = password_hash($password, PASSWORD_DEFAULT);
		$success = false;

		$login = $db->prepare('SELECT * FROM account_info
			WHERE email=?');
		$login->bindValue(1, $email, PDO::PARAM_STR);
		$login->execute();

		$result = $login->fetch(PDO::FETCH_ASSOC);
		if ($result) {
			if (password_verify($password, $result['password'])) {
				$success = true;
				$id = $result['id'];
			} else {
				echo "Wrong old password.";
				header("Refresh: 3");
			}
		}
		if ($success == true) {
			if ($newpass == clean_input($_POST['newpassword2'])) {
				$change_pass = $db->prepare('UPDATE account_info
					SET password=? WHERE id=?');
				$change_pass->bindValue(1,
					password_hash($newpass, PASSWORD_DEFAULT),
					PDO::PARAM_STR);
				$change_pass->bindValue(2, $id, PDO::PARAM_INT);
				$change_pass->execute();
				echo "Password changed!";
			} else {
				echo "The new passwords do not match, try again.";
				header("Refresh: 3");
			}
		}
		
	}
}
?>
