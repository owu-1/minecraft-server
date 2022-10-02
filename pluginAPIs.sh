#!/bin/bash

# GitHub Releases
# Usage: github user repo version filenameTest
ghrelease() { echo "Downloading $2...";curl -sLo $2-$3.jar $(curl -s "https://api.github.com/repos/$1/$2/releases/tags/$3" | jq -r --arg filename_test $4 '.assets | .[] | select(.name|test($4)).browser_download_url');}

# Modrinth
# Usage: modrinth project filenameTest
modrinth() { echo "Downloading $1...";curl -sLo $1-$2.jar $(curl -sG "https://api.modrinth.com/v2/project/$1/version" --data-urlencode 'loaders=["bukkit"]&game_versions=["$VERSION"]' | jq -r --arg filename_test $3 '.[] | select(.version_number|test($3)).files[0].url');}

# Jenkins
# Usage: jenkins api project type filenameTest
jenkins() { echo "Downloading $2...";curl -sLo $2-$3.jar "$1/job/$2/$3/artifact/$(curl -s "https://$1/job/$2/$3/api/json" | jq -r --arg filename_test $4 '.artifacts | .[] | select(.fileName|test($4)).relativePath')";}

# Latest GitHub Releases
# Usage: latest_gitrel user repo fileIndex
latest_ghrelease() { echo "Downloading $2...";echo --url $(curl -s "https://api.github.com/repos/$1/$2/releases" | jq -r '.[0].assets['$3'].browser_download_url') | curl -sLo $2.jar --config -;}

# Latest Modrinth
# Usage: latest_modrinth project
latest_modrinth() { echo "Downloading $1...";curl -sLo $1.jar $(curl -s "https://api.modrinth.com/v2/project/$1/version" --data-urlencode 'loaders=["bukkit"]&game_versions=["$VERSION"]' | jq -r '.[0]'.files[0].url);}

# Latest Jenkins
# Usage: latest_jenkins api project filenameTest
latest_jenkins(){ echo "Downloading $2...";local file=$(curl -s "$1/job/$2/lastSuccessfulBuild/api/json" | jq -r --arg filename_test $3 '.artifacts | .[] | select(.fileName|test($3)).relativePath' | cut -d ' ' -f1);curl -sLo $file "$1/job/$2/lastSuccessfulBuild/artifact/$file";}
