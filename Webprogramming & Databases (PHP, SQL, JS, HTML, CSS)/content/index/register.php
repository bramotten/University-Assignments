<?PHP
$firstname = "First name (required)";

// all the HTML fields that should be required are, so just one check is enough.
if (!empty($_POST["email"])) {
	include("helpers/opendb.php");
	$retry = 0;

	$email = clean_input($_POST['email']);
	$password = clean_input($_POST['password']);
	$hash = password_hash($password, PASSWORD_DEFAULT);
	$firstname = clean_input($_POST['firstname']);
	$inbetweennames = clean_input($_POST['inbetweennames']);
	$lastname = clean_input($_POST['lastname']);
	$city = clean_input($_POST['city']);
	$country = clean_input($_POST['country']);
	$street = clean_input($_POST['street']);
	$number = clean_input($_POST['number']);
	$letter = clean_input($_POST['letter']);

	if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
		echo "You slipped through our first check, but PHP says that's not 
			a valid email adress.";
		$retry = 1;
	}

	$create_account = $db->prepare('INSERT INTO account_info 
		(email, password) VALUES (?, ?);');
	$create_account->bindValue(1, $email, PDO::PARAM_STR);
	$create_account->bindValue(2, $hash, PDO::PARAM_STR);
	$create_account->execute();

	/* return a pretty readable error to the user, so he/she/it knows
	why account creation failed if it did. (Usually a duplicate email.) */ 
	$error_array = $create_account->errorInfo();
	if ($error_array[2] != "") {
		echo $error_array[2];
		$retry = 1;
	}

	if ($retry == 1) {
		// give the user a form with the previous data filled in
		print <<<EOT
			<h4>Register</h4>
			<form name= "registerform"  method="post" 
				onsubmit="return checkform();">
				<input type="email" name="email" value="$email" required /> 
				<br /> <input id="pw" type="password" name="password" 
					placeholder="Choose a password to login (required)" 
					required /> <br />
				<input id="fn" type="text" name="firstname" 
					value="$firstname" required /> <br />
				<input id="ib" type="text" name="inbetweennames" 
					value="$inbetweennames" placeholder="Names inbetween"/> 
				<br /><input id="ln" type="text" name="lastname" 
					value="$lastname" required /> <br />
				<input id="st" type="text" name="street" 
					value="$street" required /> <br />
				<input id="nr" type="number" name="number" 
					value="$number" placeholder="Housenumber" min="1" /> <br />
				<input id="ad" type="text" name="letter" value="$letter" 
					placeholder="Letter" /> 
				<br /> <input id="ct" type="text" name="city" 
					value="$city" required /> <br />
				<select name="country" value="$country" required > <br />
					<option value="The Netherlands">The Netherlands</option>
					<option value="DPRK">DPRK</option>
					<option value="Belgium">Belgium</option>
					<option value="France">France</option>
					<option value="Germany">Germany</option>
					<option value="USA">United States of America</option>
				</select>
				<br />
				<input type="submit" value="Create account" />
				<!--<input type="reset" value="Empty form" />-->
			</form>
EOT;
	} else {
		// everything has gone well up to here
		$id = $db->lastInsertId();
		$create_shipping_info = $db->prepare('INSERT INTO shipping_info 
			(id, firstname, inbetweennames, lastname, city, country, 
			street, number, letter) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);');
		$create_shipping_info->bindValue(1, $id, PDO::PARAM_INT);
		$create_shipping_info->bindValue(2, $firstname, PDO::PARAM_STR);
		$create_shipping_info->bindValue(3, $inbetweennames, PDO::PARAM_STR);
		$create_shipping_info->bindValue(4, $lastname, PDO::PARAM_STR);
		$create_shipping_info->bindValue(5, $city, PDO::PARAM_STR);
		$create_shipping_info->bindValue(6, $country, PDO::PARAM_STR);
		$create_shipping_info->bindValue(7, $street, PDO::PARAM_STR);
		$create_shipping_info->bindValue(8, $number, PDO::PARAM_INT);
		$create_shipping_info->bindValue(9, $letter, PDO::PARAM_STR);
		$create_shipping_info->execute();
		echo "Thanks. You can <a href=\"index.php?page=login.php\">
			log in </a> now.";
	}
} else {
	// this is the page the user gets the first time he/she/it visits register
	print <<<EOT
	<script src="js/register.js" type="text/javascript"></script>
	<h4>Register</h4>
	<form name= "registerform"  method="post" 
		onsubmit="return checkform();">
		<input type="email" name="email" 
			placeholder="Your email adress (required)" required /> <br />
		<input id="pw" type="password" name="password" 
			placeholder="Choose a password to login (required)" required /> 
		<br /> <input id="fn" type="text" name="firstname" 
			placeholder="First name (required)" required /> <br />
		<input id="ib" type="text" name="inbetweennames" 
			placeholder="Names inbetween" /> <br />
		<input id="ln" type="text" name="lastname" 
			placeholder="Last name (required)" required /> <br />
		<input id="st" type="text" name="street" 
			placeholder="Street (required)" required /> <br />
		<input id="nr" type="number" name="number" 
			placeholder="Housenumber" min="1" /> <br />
		<input id="ad" type="text" name="letter" 
			placeholder="Letter/addition" /> <br />
		<input id="ct" type="text" name="city" 
			placeholder="City (required)" required /> <br />
		<select name="country" required > 
			<option value="The Netherlands">The Netherlands</option>
			<option value="DPRK">DPRK</option>
			<option value="Belgium">Belgium</option>
			<option value="France">France</option>
			<option value="Germany">Germany</option>
			<option value="USA">United States of America</option>
		</select>
		<br /> <br />
		<input type="submit" value="Create account" />
		<!--<input type="reset" value="Empty form" />-->
	</form>
EOT;
}
?>
