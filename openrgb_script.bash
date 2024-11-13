#!/usr/bin/env bash

# wget https://openrgb.org/releases/release_0.9/OpenRGB_0.9_x86_64_b5f46e3.AppImage
# wget https://openrgb.org/releases/release_0.9/openrgb-udev-install.sh
# apt install install -y fuse
# chmod +x openrgb-udev-install.sh
# ./openrgb-udev-install.sh
# chmod +x OpenRGB_0.9_x86_64_b5f46e3.AppImage

# mv ./OpenRGB_0.9_x86_64_b5f46e3.AppImage /usr/bin/
# echo 'alias OpenRGB="/usr/bin/OpenRGB_0.9_x86_64_b5f46e3.AppImage"' >> /home/.bashrc


set -o errexit -o pipefail -o nounset


required_executables=(
	"fusermount"
    "udevadm"
    "wget"
)

missing_executables=()
for executable in "${required_executables[@]}"; do
    if ! [[ -x "$(command -v "${executable}")" ]]; then
        missing_executables+=("${executable}")
    fi
done
if (("${#missing_executables[@]}")); then
    missing_string="$(printf ", \"%s\"" "${missing_executables[@]}")"
    logerror "Required executable(s) ${missing_string:2} not in path, exiting"
    exit 1
fi

# chmod +x OpenRGB_0.9_x86_64_b5f46e3.AppImage

target_dir="/usr/local/bin"
target_filename="OpenRGB"
if ! [[ -d ${target_dir} ]]; do
	echo "Cannot install OpenRGB:  No ${target_dir} directory" 1>&2
    exit 1
fi

if [[ -e "${target_dir}/${target_filename}" ]]; do
	echo "Cannot install OpenRGB:  Target output file exists:  ${target_dir}/${target_filename}"
    exit 1
fi

workdir="$(mktemp --directory --tmpdir openrgb_installer.XXXXXXXX)"

# Download udev rules file
curl https://openrgb.org/releases/release_0.9/60-openrgb.rules -o "${workdir}/60-openrgb.rules"
curl https://openrgb.org/releases/release_0.9/OpenRGB_0.9_x86_64_b5f46e3.AppImage -o "${wordir}/OpenRGB_0.9_x86_64_b5f46e3.AppImage"

sudo apt install install -y fuse

# Move udev rules file to udev rules directory
sudo install --owner=root --group=root --mode=644 ${workdir}/60-openrgb.rules /usr/lib/udev/rules.d

sudo install --owner=root --group=root --mode=755 ${workdir}/OpenRGB_0.9_x86_64_b5f46e3.AppImage "${target_dir}/${target_filename}"
# echo 'alias OpenRGB="/usr/bin/OpenRGB_0.9_x86_64_b5f46e3.AppImage"' >> /home/.bashrc 

# Reload the rules
sudo udevadm control --reload-rules
sudo udevadm trigger





























