#!/bin/bash
set -e

cd ${CI_WORKSPACE:-.}

export VERSION=$( (git describe --tags 2>/dev/null || echo "v0.0.0-0-g$(git describe --always 2>/dev/null)") | sed s/^v// | sed s/-g/.g/ )-SNAPSHOT
if [ ! "$(echo ${CI_COMMIT_REF} | sed 's#refs/tags/\(.*\)#\1#')" = "${CI_COMMIT_REF}" ]; then
  export VERSION=$(git describe --tags | sed s/^v//)
fi

echo $VERSION
