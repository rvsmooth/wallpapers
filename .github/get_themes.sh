#!/bin/bash
set -e
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

mkdir assets
cd assets

function __download_assets() {
	URL="${WEB}/p/$1/loadFiles"
	curl -I "$URL"
	curl -Lfs "$URL" |
		jq -r '.files as $f | ($f | map(.updated_timestamp[:10]) | max) as $d |
		$f[] | select(.updated_timestamp[:10] == $d and
	        (.url | test("\\.(tar(\\.gz|\\.xz|\\.bz2)?|zip|7z|rar)$"))) | .url' |
		perl -pe 's/%([0-9A-Fa-f]{2})/chr(hex($1))/ge' |
		xargs -n 1 wget -nc --wait=15 --random-wait

}

keys=("${!asset[@]}")
for key in ${keys[@]}; do
	file="${asset[$key]}"
	echo "Downloading $files"
	__download_assets $file
done
