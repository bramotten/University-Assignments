<?php
$path = $_SERVER['REQUEST_URI']; // will return full URL
$page = basename($path); // will return something like shop.php?page=big.php
$page = basename($path, '.php'); //will return the string 'shop.php?page=big'
?>
<ul>
	<li><a <?php if($page=='account.php?page=userdata' || $page=='account'): ?> 
		class="currentAside" <?php endif; ?>id="userdata" 
		href="account.php?page=userdata.php"> User Data </a></li>
	<li><a <?php if($page=='account.php?page=changepass'): ?> 
		class="currentAside" <?php endif; ?> id="changepass" 
		href="account.php?page=changepass.php"> Change Password</a></li>
	<li><a <?php if($page=='account.php?page=orders'): ?> class="currentAside" 
		<?php endif; ?> id="orderhis" href="account.php?page=orders.php">
		My orders</a></li>
	<?php if (isset($_SESSION['admin']) &&
		$_SESSION['admin'] == 1) : ?>
		<li></li>
		<li><a <?php if($page=='account.php?page=additem'): ?> 
			class="currentAside" <?php endif; ?>
			href="account.php?page=additem.php">Add item</a></li>
		<li><a <?php if($page=='account.php?page=updateitem'): ?> 
			class="currentAside" <?php endif; ?>
			href="account.php?page=updateitem.php">Change item</a></li>
		<li><a <?php if($page=='account.php?page=allorders'): ?> 
			class="currentAside" <?php endif; ?>
			href="account.php?page=allorders.php">All orders</a></li>
		<li><a <?php if($page=='account.php?page=viewusers'): ?> 
			class="currentAside" <?php endif; ?>
			href="account.php?page=viewusers.php">View users</a></li>
	<?php endif; ?>
	
	<li></li>
	<li><a id="logout" href="helpers/logout.php"> Log me out</a></li>
</ul>