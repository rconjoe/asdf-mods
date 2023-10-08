#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/charmbracelet/mods"
TOOL_NAME="mods"
TOOL_TEST="mods --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if mods is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# Change this function if mods has other means of determining installable versions.
	list_github_tags
}

download_release() {
  local version="$1"
  local filename="$2"


	local platform
  case "$(uname -s)" in
    Linux*) platform=Linux ;;
    Darwin*) platform=Darwin ;;
  esac

  echo $platform;

	local arch
  case "$(uname -m)" in
    aarch64) arch=aarch64 ;;
    x86_64) arch=x86_64 ;;
    arm64) arch=arm64 ;;
  esac

  echo $arch;

  echo >&2 "* Downloading mods release $version for $platform with architecture $arch..."

  url="$GH_REPO/releases/download/v$version/mods_${version}_${platform}_${arch}.tar.gz"
  curl "${curl_opts[@]}" -o "$filename.tar.gz" -C - "$url" >&/dev/null && echo ".tar.gz" && return

  fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-mods supports release installs only"
  fi

  local release_file="$install_path/mods-$version"
  (
    mkdir -p "$install_path/bin"
    local ext=$(download_release "$version" "$release_file")

    case "$ext" in
      tar.gz) tar -xzf "$release_file.$ext" --directory "$install_path/bin" || fail "Could not extract $release_file.$ext" ;;
      zip) unzip "$release_file.$ext" -d "$install_path/bin" || fail "Could not extract $release_file.$ext" ;;
    esac

    rm "$release_file.$ext"

    local tool_cmd
    tool_cmd="mods"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "mods $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing mods $version."
  )
}
