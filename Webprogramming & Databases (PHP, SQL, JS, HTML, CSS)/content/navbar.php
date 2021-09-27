<?php
$path = $_SERVER['REQUEST_URI']; // will return, for example, 
https://agile095.science.uva.nl/shop.php?page=big.php
$page = basename($path); // will return shop.php?page=big.php
$page = basename($path, '.php'); // will return the string 'shop.php?page=big'
?>

<div class="navcont">
	<div class="home">
		<a href="index.php"><img id="home" src="assets/logo.png" 
			alt="Locomotion"></a>
	</div>
	<ul class="categories">
		<!-- the link of the page that is currently active
		gets to belong to .currentNav for highlighting. -->
		<li><a <?php if($page=='shop.php?page=big'): ?> 
			class="currentNav" <?php endif; ?> 
			href="shop.php?page=big.php">Big</a></li>
		<li><a <?php if($page=='shop.php?page=dangerous'): ?> 
			class="currentNav" <?php endif; ?> 
			href="shop.php?page=dangerous.php">Dangerous</a></li>
		<li><a <?php if($page=='shop.php?page=useless'): ?> 
			class="currentNav" <?php endif; ?> 
			href="shop.php?page=useless.php">Useless</a></li>
		<li><a <?php if($page=='shop.php?page=unreal'): ?> 
			class="currentNav" <?php endif; ?> 
			href="shop.php?page=unreal.php">Unreal</a></li>
	</ul>
	
	<!-- logged in users will be able to access their account
	from the next section of the navigation bar/header, non-logged
	in users will be able to log in or register. -->
	<ul class="login">
		<?php if (isset($_SESSION['authenticated'])) : ?>
			<li><a <?php //if (substr($page, 0, 6) == "account") : ?> 
			<?php if($page=='account' || 
				$page=='account.php?page=userdata' || 
				$page=='account.php?page=changepass' || 
				$page=='account.php?page=orders' || 
				$page=='account.php?page=additem' || 
				$page=='account.php?page=updateitem' || 
				$page=='account.php?page=admorders' ): ?>
				class="currentNav" 
				<?php endif; ?> href="account.php">Account</a></li>
			<li><a <?php if($page=='account.php?page=truck'): ?> 
				class="currentNav" <?php endif; ?> 
				href="account.php?page=truck.php">Truck</a></li>
		<?php else : ?>
			<li><a <?php if($page=='index.php?page=login'): ?> 
				class="currentNav" <?php endif; ?> 
				href="index.php?page=login.php">Log in</a></li>
			<li><a <?php if($page=='index.php?page=register'): ?> 
				class="currentNav" <?php endif; ?> 
				href="index.php?page=register.php">Register</a></li>
		<?php endif; ?>
	</ul>
</div>
