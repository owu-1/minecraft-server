#!/bin/bash

# Download a file
# $1 - url
# $2 - filename
download() {
    echo "Downloading $2"
    curl -L "$1" -o "$2" --progress-bar 
}

# Download an asset from a github release
# https://docs.github.com/en/rest/releases/releases#get-a-release-by-tag-name
# $1 - owner: The account owner of the repository
# $2 - repo: The name of the repository
# $3 - tag: The release tag
# $4 - pattern: A regex pattern matching the filename of the asset
ghrelease() {
    url=$(curl -s "https://api.github.com/repos/$1/$2/releases/tags/$3" | jq -r --arg pattern "$4" '.assets | .[] | select(.name|test($pattern)).browser_download_url')
    download "$url" "$2-$3.jar"
}

# Download a file from a Modrinth project version
# https://docs.modrinth.com/api-spec/#tag/versions/operation/getProjectVersions
# $1 - id: The ID or slug of the project
# $2 - version
# $3 - pattern: A regex pattern matching the version number
modrinth() {
    url=$(curl -s "https://api.modrinth.com/v2/project/$1/version" | jq -r --arg pattern "$3" '.[] | select(.version_number|test($2)).files[0].url')
    download "$url" "$1-$2.jar"
}

# Download an artifact from a Jenkins build
# $1 - jenkins_server: The Jenkin server's domain name
# $2 - job: The project name
# $3 - build: The build number or description
# $4 - pattern: A regex pattern matching the filename
jenkins() {
    build_url="https://$1/job/$2/$3"
    relative_path=$(curl -s "$build_url/api/json" | jq -r --arg pattern "$4" '.artifacts | .[] | select(.fileName|test($pattern)).relativePath')
    download "$build_url/artifact/$relative_path" "$2-$3.jar" 
}
