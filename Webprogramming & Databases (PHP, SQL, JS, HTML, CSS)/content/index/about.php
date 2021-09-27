<?php
// clear the form value variables
function init()
{
	global $address, $name, $message;
	$address = $name = $message = "";
}

// clear the message strings
$address_msg = $sent_msg = "";

// check whether the form has been submitted
if ($_SERVER["REQUEST_METHOD"] == "POST")
{
	$address = clean_input($_POST["email"]);
	$name = clean_input($_POST["name"]);
	$message = $_POST["message"];
	
	if (filter_var($address, FILTER_VALIDATE_EMAIL) === FALSE) {
		$address_msg = '<span class="error">Invalid email address</span>';
	} else {
		$admin_email = "locomotion.contact@gmail.com";
		mail($admin_email, $name . " [Message via contact form]",
		$message, "From: " . $address);
		$sent_msg = 'Your message was sent succesfully.';
		init(); // clear the form
	}
} else {
	// First time: clear the form value variables
	init();
}
?>

<p> Welcome to our Locomotion!
<br /><br /> 
Do you have a complaint, a compliment, or do you think that your 
contribution could improve our site?
Send us an email and we'll try to respond within the next 24 hours. </p>

<div class="inputform">
	<h4>Contact us</h4>
	<form name="contactform"  method="post" 
		onsubmit="return checkform();">
		<input type="text" name="name" placeholder="Your name (required)" 
			value="<?php echo $name ?>" required /> <br />
		<input type="text" name="email" 
			placeholder="Your email adress (required)" 
			value="<?php echo $address ?>" required />
		<?php echo $address_msg; ?> <br />
			
		<textarea name="message" placeholder="Your message, question or 
		suggestion (required)" required>
			<?php echo $message; ?>
		</textarea><br />
		<input type="submit" value="Send message" />
		<br />
		<?php echo $sent_msg; ?> 
	</form>
</div>
<h4>KI24</h4>
KI24 is a hardworking group of dedicated brogrammers/individuals 
striving to make the world a better place one website at a time. In exchange 
for a small fee, we can make YOUR website stupefyingly awesomesauce TOO! 
<br /><br />
Current ninjim: 
<ul>
<li>Jade "The social antenna" Schreuder</li>
<li>Sybren "Master of Syb" Moolhuizen </li>
<li>Deborah "Hockey Stick" Lambregts </li>
<li>Daan "@#*&%$" Marx </li>
<li>Bram "&#60;?php //TODO ?&#62;" Otten </li>
</ul>

Canary announcement: 
we have never been forced to share our data with anyone.
