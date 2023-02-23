#!/bin/bash

set -eo pipefail

function main() {

    if [[ -z "$AUTO_RESTIC_REPO" ]]; then
	echo "Environment variable AUTO_RESTIC_REPO not set."
	exit 1
    fi


    # Check if the repository is initialized, fail if not
    restic -r "$AUTO_RESTIC_REPO" snapshots

    # Create a new backup
    restic -r "$AUTO_RESTIC_REPO" backup \
	   --verbose \
	   --exclude-caches \
	   -e /data/nix \
	   -e "$HOME/.cache/" \
	   -e "$HOME/.cargo/" \
	   -e "$HOME/Downloads/" \
	   -e "$HOME/.mozilla/" \
	   -e "$HOME/.rustup/" \
	   -e "$HOME/.cabal/" \
	   -e "$HOME/.cargo/" \
	   "$HOME" \
	   "/data/content/"
}

main $@
