#!/bin/bash
set -e

cd ${CI_WORKSPACE:-.}

export VERSION=$( (git describe --tags 2>/dev/null || echo "v0.0.0-0-g$(git describe --always 2>/dev/null)") | sed s/^v// | sed s/-g/.g/ )-SNAPSHOT
if [ "$(echo ${CI_COMMIT_REF} | sed 's#refs/heads/\(.*\)#\1#')" = "staging" ]; then
  export PUBLISH=staging
fi
if [ ! "$(echo ${CI_COMMIT_REF} | sed 's#refs/tags/\(.*\)#\1#')" = "${CI_COMMIT_REF}" ]; then
  export VERSION=$(git describe --tags | sed s/^v//)
  export PUBLISH=production
fi

mkdir -p ~/.docker
echo "{\"auths\":{\"docker.pkg.airfocus.dev\":{\"auth\":\"$(echo -n api:${PLUGIN_REGISTRY_TOKEN} | base64)\"}}}" > ~/.docker/config.json
