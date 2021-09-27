<?php

if (!empty($_POST['email'])) {
	include("helpers/opendb.php"); // location relative to index.php

	$email = clean_input($_POST['email']);
	$password = clean_input($_POST['password']);
	$success = false;

	$check_account = $db->prepare('SELECT * FROM account_info WHERE email=?');
	$check_account->bindValue(1, $email, PDO::PARAM_STR);
	$check_account->execute();

	$result = $check_account->fetch(PDO::FETCH_ASSOC);
	if ($result) {
		// this means the account exists, but we won't tell the user

		// verify if input matches corresponding hash in database
		if (password_verify($password, $result['password'])) {
			$success = true;

			// get the ID belonging to this email
			$getid = $db->prepare('SELECT id FROM account_info WHERE email=?');
			$getid->bindValue(1, $email, PDO::PARAM_STR);
			$getid->execute();

			$row = $getid->fetch(PDO::FETCH_ASSOC);
			$id = $row['id'];

			/*
			// Check if a newer hashing algorithm is available.


			if (password_needs_rehash($result['password'], PASSWORD_DEFAULT)) {
				// 	If so, create a new hash, and replace the old one
				$newHash = password_hash($_POST['password'], PASSWORD_DEFAULT);

				$stmt = $db->prepare('INSERT INTO account_info 
					(email, password) VALUES ( ?, ? )');
				$stmt->bindValue(1, $_POST["email"], PDO::PARAM_STR);
				$stmt->bindValue(2, $newHash, PDO::PARAM_STR);
				$stmt->execute();
				// it looks like the old account is left alone,
			}
			*/
		}
	}

	if ($success) {
		$_SESSION['authenticated'] = 1;
		$_SESSION['email'] = $email;
		$_SESSION['id'] = $id;
		$_SESSION['admin'] = $result['admin'];
		$host = 'https://' . $_SERVER['HTTP_HOST'];
		header("Location: $host");
	}
	else {
		echo "Incorrect email adress and/or password.";
	}
}

/* display login form, whether a login failed or not does not matter. */
print <<<EOT
<div id="register" class="inputform">
	<h4>Log in</h4>
	<form name= "loginform"  method="post">
		<input placeholder="Email adress" type="email" 
		name="email" required /> 
		<br />
		<input placeholder="password" type="password" 
		name="password" required /> 
		<br /> <br />
		<input type="submit" value="Log in" />
	</form>
	<br />
	Or <a href="index.php?page=register.php">register here. </a>
</div>
EOT;

?>
