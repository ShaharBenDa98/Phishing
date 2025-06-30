# Phishing Simulation Tool (Educational Bash Project)

One of the most exciting challenges I tackled during the RTX course at **ThinkCyber LTD** was building this phishing simulation tool, developed entirely in **Bash**.

This project was designed for **educational purposes only**, simulating real-world phishing techniques to help future defenders better understand the attacker’s mindset.

---

## Features

- Website cloning (or use of built-in phishing templates)
- PHP injection to capture credentials
- IP and timestamp logging
- Automatic Apache configuration
- Redirection to the legitimate website
- Optional SSL setup (for custom domain support)
- Short public link generation using an external API

---

## Tools & Technologies

- Bash scripting
- PHP (used for form capture)
- Apache2 (to serve pages)
- curl/API (for URL shortening)
- Optional: SSL with OpenSSL or Certbot

---

## Directory Structure (Simplified)

```
project-root/
├── apache-configs/         # Auto-generated virtual hosts
├── logs/                   # Captured credentials and visitor logs
├── ssl/                    # (Optional) SSL keys and certs
├── templates/              # Prebuilt phishing pages and scripts
│   ├── allegronet/         # Fake login template for Allegronet
│   ├── custom/             # User-defined templates
│   ├── FXP/                # Template for FXP-style login
│   ├── linkedin/           # Template for LinkedIn login
│   ├── salesforce/         # Template for Salesforce login
│   ├── better_harvester_universal.sh  # Script for generic cloning
│   ├── inject_form.sh                # Script for form injection
│   └── wget.txt                      # Download list (optional)
├── phishing.sh            # Main runner script
└── README.md              # This file
```

> You can easily add more templates to the `templates/` folder by copying the structure.

---

## Usage (For Lab Environments Only)

> This tool is intended for use in safe, controlled environments.  
> **Do not use on real networks or targets without proper legal authorization.**

1. Clone the repository or copy it locally.
2. Run the tool as root/sudo:
   ```bash
   sudo bash phishing.sh
   ```
3. Follow the prompts to:
   - Clone a site or choose a template
   - Inject PHP capture code
   - Serve the site with Apache
   - Optionally shorten the URL

4. Captured data will appear in the `logs/` directory.

---

## Credits

- Concept and training by **David Shiffman (דוד שיפמן)**
- Bash scripting by Shahar Ben-David
- Background music for demos generated using **Suno-AI**

---

## Disclaimer

This tool was created solely for educational use during cybersecurity training.  
It must only be used in **authorized lab environments**.  
The author is not responsible for any misuse.

---

## Learn by Simulating the Attacker
Understanding phishing is the first step to preventing it.
