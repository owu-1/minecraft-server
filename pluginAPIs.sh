#!/bin/bash

jenkins() {
    local jenkins_server=$1
    local job=$2
    local build=$3
    local filename_test=$4
    relative_path=$(curl -s "https://$jenkins_server/job/$job/$build/api/json" | jq -r --arg filename_test ${filename_test} '.artifacts | .[] | select(.fileName|test($filename_test)).relativePath')
    echo "Downloading ${job}..."
    curl -sL "$jenkins_server/job/$job/$build/artifact/$relative_path" -o ${job}-${build}.jar
}

github() {
    local owner=$1
    local repo=$2
    local tag=$3
    local filename_test=$4
    echo "Downloading ${repo}..."
    curl -sL "$(curl -s "https://api.github.com/repos/$owner/$repo/releases/tags/$tag" | jq -r --arg filename_test $filename_test '.assets | .[] | select(.name|test($filename_test)).browser_download_url')" -o ${repo}-${tag}.jar
}

modrinth() {
    local project_id=$1
    local version=$2
    local filename_test=$3
    echo "Downloading ${project_id}..."
    curl -sL "${curl -sG "https://api.modrinth.com/v2/project/$project_id/version" --data-urlencode 'loaders=["bukkit"]' | jq -r --arg filename_test $filename_test '.[] | select(.version_number|test($filename_test)).files[0].url'}" -o ${project_id}-${version}.jar
}
