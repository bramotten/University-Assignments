<?PHP 
// TODO: one dir higher
if (file_exists("../../mysql_config_loco.xml")) {
    $dbconf = simplexml_load_file("../../mysql_config_loco.xml");
} else {
    // this is for reaching the xml from the helpers folder
    $dbconf = simplexml_load_file("../../../mysql_config_loco.xml");
}
if ($dbconf === FALSE) {
    die("Error parsing XML file. Check the location it should be at first.");
}
else {            
        // connect to DB using data from the XML
        $db = new PDO("mysql:host=$dbconf->mysql_host;
            dbname=$dbconf->mysql_database;charset=utf8",
            "$dbconf->mysql_username","$dbconf->mysql_password") 
            or die('Error connecting to mysql server');
}
?>