#!/bin/bash

# Usage: download url filename
download() {
    echo "Downloading $2"
    curl -L "$1" -o "$2" --progress-bar 
}

# GitHub Releases
# Usage: github user repo version filenameTest
ghrelease() {
    local user=$1
    local repo=$2
    local version=$3
    local filename_test=$4
    url=$(curl -s "https://api.github.com/repos/$user/$repo/releases/tags/$version" | jq -r --arg filename_test "$filename_test" '.assets | .[] | select(.name|test($filename_test)).browser_download_url')
    download "$url" "$repo-$version.jar"
}

# Modrinth
# Usage: modrinth project filenameTest
modrinth() {
    local project=$1
    local filename_test=$2
    url=$(curl -s "https://api.modrinth.com/v2/project/$project/version?loaders=[%22$LOADER%22]&game_versions=[%22$VERSION%22]" | jq -r --arg filename_test "$filename_test" '.[] | select(.version_number|test($filename_test)).files[0].url')
    download "$url" "$project-$filename_test.jar"
}

# Jenkins
# Usage: jenkins api project type filenameTest
jenkins() {
    local api=$1
    local job=$2
    local build=$3
    local filename_test=$4
    relative_path=$(curl -s "https://$api/job/$job/$build/api/json" | jq -r --arg filename_test "$filename_test" '.artifacts | .[] | select(.fileName|test($filename_test)).relativePath')
    download "https://$api/job/$job/$build/artifact/$relative_path" "$job-$build.jar" 
}
