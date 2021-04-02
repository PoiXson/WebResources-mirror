#!/bin/bash



repo_bootstrap="https://github.com/twbs/bootstrap.git"
repo_bootstrap_icons="https://github.com/twbs/icons.git"
repo_bootswatch="https://github.com/thomaspark/bootswatch.git"
repo_jquery="https://github.com/jquery/jquery.git"

version_bootstrap="v4.6.0"
version_bootstrap_icons="v1.4.0"
version_bootswatch="v4.6.0"
version_jquery="3.6.0"



source /usr/bin/pxn/scripts/common.sh  || exit 1



PWD=$(\pwd)
if [ -z $PWD ]; then
	echo
	failure "Failed to find current working directory"
	echo
	exit 1
fi



function DisplayHelp() {
	echo -e "${COLOR_BROWN}Usage:${COLOR_RESET}"
	echo    "  resource-dl [options] <packages>"
	echo
	echo -e "${COLOR_BROWN}Packages:${COLOR_RESET}"
	echo -e "  ${COLOR_GREEN}bootstrap${COLOR_RESET}"
	echo -e "  ${COLOR_GREEN}bootstrap-icons${COLOR_RESET}"
	echo -e "  ${COLOR_GREEN}bootswatch${COLOR_RESET}"
	echo -e "  ${COLOR_GREEN}jquery${COLOR_RESET}"
	echo
	echo -e "${COLOR_BROWN}Options:${COLOR_RESET}"
	echo -e "  ${COLOR_GREEN}-a, --all${COLOR_RESET}              Download all available packages"
	echo -e "  ${COLOR_GREEN}-d, --dest${COLOR_RESET}             Destination for downloaded files"
	echo                                "                           example: public/static/"
	echo
	echo -e "  ${COLOR_GREEN}-h, --help${COLOR_RESET}             Display this help message and exit"
	echo
	exit 1
}



function dl_bootstrap() {
	title "Bootstrap $version_bootstrap"
	DEST="$1"
	if [ -z $DEST ]; then
		failure "Destination not set"; exit 1
	fi
	[[ ! -d "$DEST/bootstrap/css" ]] && \mkdir -pv "$DEST/bootstrap/css"
	[[ ! -d "$DEST/bootstrap/js"  ]] && \mkdir -pv "$DEST/bootstrap/js"
	temp_dir=$( \mktemp -d )
	if [ -z temp_dir ]; then
		failure "Failed to make a temp dir"; exit 1
	fi
	echo "Using temp dir: $temp_dir"
	\pushd "$temp_dir" >/dev/null || exit 1
		\git clone --depth=1 -c advice.detachedHead=false \
			-b "$version_bootstrap"  "$repo_bootstrap"  "bootstrap" \
				|| exit 1
	\popd >/dev/null
	\install -m 0664 \
		"$temp_dir/bootstrap/dist/css/bootstrap.css"            \
		"$temp_dir/bootstrap/dist/css/bootstrap.min.css"        \
		"$temp_dir/bootstrap/dist/css/bootstrap-reboot.css"     \
		"$temp_dir/bootstrap/dist/css/bootstrap-reboot.min.css" \
		"$temp_dir/bootstrap/dist/css/bootstrap-grid.css"       \
		"$temp_dir/bootstrap/dist/css/bootstrap-grid.min.css"   \
		"$DEST/bootstrap/css/" \
			|| exit 1
	\install -m 0664 \
		"$temp_dir/bootstrap/dist/js/bootstrap.js"            \
		"$temp_dir/bootstrap/dist/js/bootstrap.min.js"        \
		"$temp_dir/bootstrap/dist/js/bootstrap.bundle.js"     \
		"$temp_dir/bootstrap/dist/js/bootstrap.bundle.min.js" \
		"$DEST/bootstrap/js/" \
			|| exit 1
	echo "Removing temp files.."
	\rm -Rf --preserve-root  "$temp_dir"
	echo
}



function dl_bootstrap_icons() {
	title "Bootstrap-Icons $version_bootstrap_icons"
	DEST="$1"
	if [ -z $DEST ]; then
		failure "Destination not set"; exit 1
	fi
	[[ ! -d "$DEST/bootstrap-icons/fonts" ]] && \mkdir -pv "$DEST/bootstrap-icons/fonts"
	[[ ! -d "$DEST/bootstrap-icons/icons" ]] && \mkdir -pv "$DEST/bootstrap-icons/icons"
	temp_dir=$( \mktemp -d )
	if [ -z temp_dir ]; then
		failure "Failed to make a temp dir"; exit 1
	fi
	echo "Using temp dir: $temp_dir"
	\pushd "$temp_dir" >/dev/null || exit 1
		\git clone --depth=1 -c advice.detachedHead=false \
			-b "$version_bootstrap_icons"  "$repo_bootstrap_icons"  "bootstrap-icons" \
				|| exit 1
	\popd >/dev/null
	\install -m 0664 \
		"$temp_dir/bootstrap-icons/font/bootstrap-icons.css" \
		"$DEST/bootstrap-icons/" \
			|| exit 1
	\install -m 0664 \
		"$temp_dir/bootstrap-icons/font/fonts/bootstrap-icons.woff"  \
		"$temp_dir/bootstrap-icons/font/fonts/bootstrap-icons.woff2" \
		"$DEST/bootstrap-icons/fonts" \
			|| exit 1
	\install -m 0664 \
		"$temp_dir/bootstrap-icons/icons/"*".svg" \
		"$DEST/bootstrap-icons/icons/" \
			|| exit 1
	echo "Removing temp files.."
	\rm -Rf --preserve-root  "$temp_dir"
	echo
}



function dl_bootswatch() {
	title "Bootswatch $version_bootswatch"
	DEST="$1"
	if [ -z $DEST ]; then
		failure "Destination not set"; exit 1
	fi
	[[ ! -d "$DEST/bootswatch" ]] && \mkdir -pv "$DEST/bootswatch"
	temp_dir=$( \mktemp -d )
	if [ -z temp_dir ]; then
		failure "Failed to make a temp dir"; exit 1
	fi
	echo "Using temp dir: $temp_dir"
	\pushd "$temp_dir" >/dev/null || exit 1
		\git clone --depth=1 -c advice.detachedHead=false \
			-b "$version_bootswatch"  "$repo_bootswatch"  "bootswatch" \
				|| exit 1
	\popd >/dev/null
	THEMES=$( \ls -1 "$temp_dir/bootswatch/dist/" )
	for ENTRY in $THEMES; do
		[[ ! -d "$DEST/bootswatch/$ENTRY/" ]] && \mkdir -pv "$DEST/bootswatch/$ENTRY/"
		\install -m 0664 \
			"$temp_dir/bootswatch/dist/$ENTRY/bootstrap.css"     \
			"$temp_dir/bootswatch/dist/$ENTRY/bootstrap.min.css" \
			"$DEST/bootswatch/$ENTRY/" \
				|| exit 1
	done
	echo "Removing temp files.."
	\rm -Rf --preserve-root  "$temp_dir"
	echo
}



function dl_jquery() {
	title "jQuery $version_jquery"
	DEST="$1"
	if [ -z $DEST ]; then
		failure "Destination not set"; exit 1
	fi
	[[ ! -d "$DEST/jquery" ]] && \mkdir -pv "$DEST/jquery"
	temp_dir=$( \mktemp -d )
	if [ -z temp_dir ]; then
		failure "Failed to make a temp dir"; exit 1
	fi
	echo "Using temp dir: $temp_dir"
	\pushd "$temp_dir" >/dev/null || exit 1
		\git clone --depth=1 -c advice.detachedHead=false \
			-b "$version_jquery"  "$repo_jquery"  "jquery" \
				|| exit 1
	\popd >/dev/null
	\install -m 0664 \
		"$temp_dir/jquery/dist/jquery.js"     \
		"$temp_dir/jquery/dist/jquery.min.js" \
		"$DEST/jquery/" \
			|| exit 1
	echo "Removing temp files.."
	\rm -Rf --preserve-root  "$temp_dir"
	echo
}



# parse args
echo
if [ $# -eq 0 ]; then
	DisplayHelp
	exit 1
fi
DL_ALL=$NO
DL_PACKAGES=''
DEST=''
while [ $# -gt 0 ]; do
	case "$1" in
	# all packages
	-a|--all)
		DL_ALL=$YES
	;;
	# destination
	-d|--dest|--destination)
		shift
		DEST="$1"
	;;
	# display help
	-h|--help)
		DisplayHelp
		exit 1
	;;
	-*)
		echo
		failure "Unknown argument: $1"
		echo
		DisplayHelp
		exit 1
	;;
	*)
		DL_PACKAGES="$DL_PACKAGES $1"
	;;
	esac
	\shift
done



if [ -z $DEST ]; then
	DEST="public/static/"
#	echo
#	failure "Destination not set"
#	echo
#	exit 1
fi
if [[ "$DEST" != "/"* ]]; then
	DEST="$PWD/$DEST"
fi
if [[ "$DEST" != *"/" ]]; then
	DEST="$DEST/"
fi
echo -e "Destination: ${COLOR_BROWN}${DEST}${COLOR_RESET}"
echo



if [[ $DL_ALL -eq $YES ]]; then
	DL_PACKAGES="bootstrap bootstrap-icons bootswatch jquery"
fi
if [[ -z $DL_PACKAGES ]]; then
	echo
	failure "No packages selected to download"
	echo
	exit 1
fi



for PACKAGE in $DL_PACKAGES; do
	case "$PACKAGE" in
	bootstrap)
		dl_bootstrap "$DEST"
	;;
	bootstrap-icons)
		dl_bootstrap_icons "$DEST"
	;;
	bootswatch)
		dl_bootswatch "$DEST"
	;;
	jquery)
		dl_jquery "$DEST"
	;;
	*)
		echo
		failure "Unknown package: $PACKAGE"
		echo
		exit 1
	;;
	esac
done



echo -e " ${COLOR_BROWN}Finished${COLOR_RESET}"
echo
exit 0
