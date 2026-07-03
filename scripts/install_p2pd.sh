#!/bin/bash

set -euo pipefail

LIBP2P_DAEMON_VERSION=v0.9.2
PROJECT_NAME=go-libp2p-daemon
LIBP2P_DAEMON_REPO=github.com/libp2p/$PROJECT_NAME

go version
go env
rm -rf $PROJECT_NAME
git clone https://$LIBP2P_DAEMON_REPO
cd $PROJECT_NAME
git checkout $LIBP2P_DAEMON_VERSION
go install ./...
