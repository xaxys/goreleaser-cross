#!/usr/bin/env bash


# in akash even minor part of the tag indicates release belongs to the MAINNET
# using it as scripts simplifies debugging as well as portability
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

function generate_tags {
	hub="xaxy/$1"

	tag=$(make tag)
	GORELEASER_VERSION=v$GORELEASER_VERSION

	tag_minor=v$("${SCRIPT_DIR}/semver.sh" get major "$tag").$("${SCRIPT_DIR}/semver.sh" get minor "$tag")

	if [[ $("${SCRIPT_DIR}"/is_prerelease.sh "$tag") == true ]]; then
		echo "$hub:$tag.$GORELEASER_VERSION"
		echo "$hub:$tag"
	else
		echo "$hub:latest"
		echo "$hub:$tag-$GORELEASER_VERSION"
		echo "$hub:$tag_minor-$GORELEASER_VERSION"
		echo "$hub:$tag_minor"
		echo "$hub:$tag"
	fi

	exit 0
}

case $1 in
	cross-base)
		generate_tags goreleaser-cross-base
		;;
	cross)
		generate_tags goreleaser-cross
		;;
esac
