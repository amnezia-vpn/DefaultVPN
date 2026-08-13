#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)

for source_list in \
    "$repo_root/client/ios/networkextension/CMakeLists.txt" \
    "$repo_root/client/macos/networkextension/CMakeLists.txt"
do
    for swift_source in \
        NetworkPathRetentionPolicy.swift \
        HandshakeFreshnessEvaluator.swift
    do
        expected="\${WG_APPLE_SOURCE_DIR}/WireGuardKit/$swift_source"
        if ! grep -Fq "$expected" "$source_list"; then
            echo "missing $expected in $source_list" >&2
            exit 1
        fi
    done
done
