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

# Latest GitHub Releases
# Usage: latest_gitrel user repo fileIndex
latest_ghrelease() {
    local user=$1
    local repo=$2
    local index=$3
    url=$(curl -s "https://api.github.com/repos/$user/$repo/releases" | jq -r '.[0].assets['"$index"'].browser_download_url')
    download "$url" "$repo.jar"
}

# Latest Modrinth
# Usage: latest_modrinth project
latest_modrinth() {
    local project=$1
    url=$(curl -s "https://api.modrinth.com/v2/project/$project/version" --data-urlencode 'loaders=["$LOADER"]&game_versions=["$VERSION"]' | jq -r '.[0]'.files[0].url)
    download "$url" "$project.jar"
}

# Latest Jenkins
# Usage: latest_jenkins api project filenameTest
latest_jenkins() {
    local api=$1
    local job=$2
    local build=$3
    local filename_test=$4
    relative_path=$(curl -s "$api/job/$job/lastSuccessfulBuild/api/json" | jq -r --arg filename_test "$filename_test" '.artifacts | .[] | select(.fileName|test($filename_test)).relativePath' | cut -d ' ' -f1)
    download "$1/job/$2/lastSuccessfulBuild/artifact/$relative_path" "$job.jar"
}
