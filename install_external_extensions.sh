#!/bin/bash

# Fill with vscode extension URLs
links=(
    "https://marketplace.visualstudio.com/items?itemName=SimonHo.kanagawa-paper"
    "https://marketplace.visualstudio.com/items?itemName=huytd.nord-light"
    "https://marketplace.visualstudio.com/items?itemName=sainnhe.everforest"
    "https://marketplace.visualstudio.com/items?itemName=loilo.snazzy-light"
)

extract_author() {
    echo "$1" | grep -oP '"PublisherName":\s*"\K[^"]*'
}

extract_extension_name() {
    echo "$1" | grep -oP '"ExtensionName":\s*"\K[^"]*'
}

extract_version() {
    echo "$1" | grep -oP '"Version":\s*"\K[^"]*'
}

extract_unique_identifier() {
    echo "$1" | grep -oP '"UniqueIdentifierValue":\s*"\K[^"]*'
}

download_and_install() {
    local mainpage_url="$1"
    local webpage=$(curl -s "$mainpage_url")
    local author=$(extract_author "$webpage")
    local extension_name=$(extract_extension_name "$webpage")
    local version=$(extract_version "$webpage")
    local unique_id=$(extract_unique_identifier "$webpage")
    local filename="${unique_id}-${version}.vsix"
    local url="https://marketplace.visualstudio.com/_apis/public/gallery/publishers/${author}/vsextensions/${extension_name}/${version}/vspackage"
    
    echo "Downloading and installing ${filename} from '${url}'"
    curl "$url" --compressed -o "$filename"
    codium --install-extension "$filename"
    rm "$filename"
}

# Main
cd "$(dirname "$0")"
for link in "${links[@]}"; do
    download_and_install "$link"
done
