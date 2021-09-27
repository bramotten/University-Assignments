<!--All upcoming complicated looking inline PHP is there to detect
	the current page and highlight the link to the page the user 
	is currently on. -->

<ul>
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
	
	<li></li>

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
	
	<li></li>
	
	<li><a <?php if($page=='index.php?page=about'): ?> 
		class="currentNav" <?php endif; ?> 
		href="index.php?page=about.php">About us</a></li>
</ul>
