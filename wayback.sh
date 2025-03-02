#!/bin/bash

while true; do
    # Prompt for the domain name.
    read -p "Enter the domain (e.g., example.com): " domain

    # Create a folder to store results
    folder_name="${domain}_all_files"
    mkdir -p "$folder_name"

    echo "Fetching all URLs from the Wayback Machine (Timeout after ~3 minutes)..."

    # Set a timeout limit (e.g., 3 minutes = 180 seconds)
    curl -m 180 -G "https://web.archive.org/cdx/search/cdx" \
        --data-urlencode "url=*.$domain/*" \
        --data-urlencode "collapse=urlkey" \
        --data-urlencode "output=text" \
        --data-urlencode "fl=original" \
        -o "$folder_name/all_urls.txt"

    echo "Fetching URLs with specific file extensions..."

    curl "https://web.archive.org/cdx/search/cdx?url=*.$domain/*&collapse=urlkey&output=text&fl=original&filter=original:.*\.(xls|xml|xlsx|json|sql|doc|docx|pptx|git|zip|tar\.gz|tgz|bak|7z|rar|log|cache|secret|db|backup|yml|gz|config|csv|yaml|md|md5|exe|dll|bin|ini|bat|sh|tar|deb|rpm|iso|img|env|apk|msi|dmg|tmp|crt|pem|key|pub|asc)$" \
        -o "$folder_name/filtered_urls.txt"

    echo "Done! Results saved to:"
    echo "  - $folder_name/all_urls.txt"
    echo "  - $folder_name/filtered_urls.txt"

    # Manual checking prompt
    echo "Dishant, please check manually."
    cat "$folder_name/filtered_urls.txt"

    # Ask for confirmation to delete the folder
    read -p "Checking done? Do you want to delete the folder (yes/no): " confirm_delete

    if [[ "$confirm_delete" == "yes" ]]; then
        rm -rf "$folder_name"
        echo "Folder deleted."
    else
        echo "Folder kept."
    fi

    # Ask if user wants to run the tool again
    read -p "Do you want to run the tool again? (yes/no): " rerun

    if [[ "$rerun" != "yes" ]]; then
        echo "Exiting the tool. Goodbye!"
        break
    fi
done
