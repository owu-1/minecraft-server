#!/bin/bash

# GitHub Releases
# Usage: github user repo version filenameTest
ghrelease() {
    local user=$1
    local repo=$2
    local version=$3
    local filename_test=$4
    echo "Downloading $repo..."
    curl --progress-bar -Lo $repo-$version.jar $(curl -s "https://api.github.com/repos/$user/$repo/releases/tags/$version" | jq -r --arg filename_test $filename_test '.assets | .[] | select(.name|test($filename_test)).browser_download_url')
}

# Modrinth
# Usage: modrinth project filenameTest
modrinth() {
    local project=$1
    local filename_test=$2
    echo "Downloading $project..."
    curl --progress-bar -Lo $project-$filename_test.jar $(curl -s "https://api.modrinth.com/v2/project/$project/version?loaders=[%22$LOADER%22]&game_versions=[%22$VERSION%22]" | jq -r --arg filename_test $filename_test '.[] | select(.version_number|test($filename_test)).files[0].url')
}

# Jenkins
# Usage: jenkins api project type filenameTest
jenkins() {
    local api=$1
    local job=$2
    local build=$3
    local filename_test=$4
    file=$(curl -s "https://$api/job/$job/$build/api/json" | jq -r --arg filename_test $filename_test '.artifacts | .[] | select(.fileName|test($filename_test)).relativePath')
    echo "Downloading $job..."
    curl --progress-bar -Lo $job-$build.jar "https://$api/job/$job/$build/artifact/$file"
}

# Latest GitHub Releases
# Usage: latest_gitrel user repo fileIndex
latest_ghrelease() {
    local user=$1
    local repo=$2
    local index=$3
    echo "Downloading $repo..."
    echo --url $(curl -s "https://api.github.com/repos/$user/$repo/releases" | jq -r '.[0].assets['$index'].browser_download_url') | curl --progress-bar -Lo $repo.jar --config -
}

# Latest Modrinth
# Usage: latest_modrinth project
latest_modrinth() {
    local project=$1
    echo "Downloading $project..."
    curl --progress-bar -Lo $project.jar $(curl -s "https://api.modrinth.com/v2/project/$project/version" --data-urlencode 'loaders=["$LOADER"]&game_versions=["$VERSION"]' | jq -r '.[0]'.files[0].url)
}

# Latest Jenkins
# Usage: latest_jenkins api project filenameTest
latest_jenkins() {
    local api=$1
    local job=$2
    local build=$3
    local filename_test=$4
    echo "Downloading $job..."
    local file=$(curl -s "$api/job/$job/lastSuccessfulBuild/api/json" | jq -r --arg filename_test $filename_test '.artifacts | .[] | select(.fileName|test($filename_test)).relativePath' | cut -d ' ' -f1)
    curl --progress-bar -Lo $file "$1/job/$2/lastSuccessfulBuild/artifact/$file"
}
