#! /usr/bin/env bash
set -e

# Params:
# $1: configuration name (hosts folder name)
# $2: Optional nix cache proxy
# TODO: Migrate to nix flakes once promoted from experimental to stable

PROXY=${2:-""}
if [ "$PROXY" != "" ]; then
    PROXY="--option http-connections 0 --option substituters $PROXY"
fi

# Modified from https://gist.github.com/gdamjan/8158b57379932fd0e07ce6d83399b71f
set -o xtrace
nix-channel --add https://nixos.org/channels/nixos-22.05 nixpkgs
nix-channel --list
nix-channel --update

# Install nixos-generators: https://github.com/nix-community/nixos-generators
nix-env $PROXY -f https://github.com/nix-community/nixos-generators/archive/master.tar.gz -i

nixos-generate --configuration "/homeworld/hosts/$1/configuration.nix" --system x86_64-linux --format qcow --out-link workdir $PROXY

cp workdir/nixos.qcow2 "/homeworld/$1.qcow2"