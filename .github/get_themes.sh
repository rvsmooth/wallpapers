#!/bin/bash
set -x
WEB="https://www.gnome-look.org"
declare -A asset

asset["Graphite-GTK-Theme"]="1598493"
asset["Everforest-GTK-Theme"]="1695467"
asset["Gruvbox-GTK-Theme"]="1681313"
asset["Catppuccin-GTK-Theme"]="1715554"
asset["Dracula-GTK-Theme"]="1687249"
asset["Nordic-GTK-Theme"]="1267246"
asset["Tokyonight-GTK-Theme"]="1681315"
asset["Bibata-Modern-Ice"]="1681315"
asset["Bibata-Modern-Classic"]="1914825"
asset["Papirus-Icon-Theme"]="1166289"
asset["Kora-Icon-Theme"]="1256209"

__download_assets() {
	URL="${WEB}/p/$1/loadFiles"
	curl -I "$URL"
	curl -Lfs "$URL" |
		jq -r --arg version "$(curl -Lfs $URL | jq -r '.files | .[0] | .version')" '.files | .[] | select(.version==$version) | .url' |
		perl -pe 's/\%(\w\w)/chr hex $1/ge' | xargs wget
}

mkdir assets
cd assets

for files in ${!asset[@]}; do
	file="${asset[$files]}"
	echo "Downloading $files"
	__download_assets $file
	sleep 1
done
