// an XMLHttpRequest
var xhr = null;

/*
 * Gets stock from database
 */
function checkstock(id) {
	// instantiate XMLHttpRequest object
	try {
		xhr = new XMLHttpRequest();
	} catch (e) {
		xhr = new ActiveXObject("Microsoft.XMLHTTP");
	}

	// handle old browsers
	if (xhr == null) {
		alert("Ajax not supported by your browser!");
		return;
	}

	// construct URL
	var url = "helpers/querystock.php?item=" + id;

	// get quote
	xhr.onreadystatechange = handler;
	xhr.open("GET", url, true);
	xhr.send(null);
}


/*
 * Handles the Ajax response.
 */
function handler() {
	// only handle loaded requests
	var text;
	if (xhr.readyState == 4) {
		if (xhr.status == 200) {
			var stock = parseInt(xhr.responseText);
			if (stock > 0) {
				// print the form here to only allow adding to stock when 
				// there is stock
				text = "Current stock: " + stock;
				text += "<form method=\"post\" action=\"\">";
				text += "<div class=\"cart\">";
				text +=  "<input type=\"number\" min=\"1\" value=\"1\"";
				text += "name=\"amount\" /> ";
				text += "<button type=\"submit\" name = \"loadtruck\">";
				text += "Add to truck</button></div></form>";
			} else {
				text = "Out of stock. Please try again later.";
			}

			
		} else {
			text = "Error retrieving stock, please try again later.";
		}

		document.getElementById("stock").innerHTML = text;
	}
}