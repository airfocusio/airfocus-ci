#!/bin/bash
set -e
source /base-entry.sh

mkdir -p ~/.sbt
echo -e "realm=pkgdist\nhost=maven.pkg.airfocus.dev\nuser=api\npassword=${PLUGIN_REGISTRY_TOKEN}" > ~/.sbt/.credentials-airfocus-maven
echo -e "realm=pkgdist\nhost=docs.pkg.airfocus.dev\nuser=api\npassword=${PLUGIN_REGISTRY_TOKEN}" > ~/.sbt/.credentials-airfocus-docs
export SBT_OPTS="-Dsbt.global.base=${CI_WORKSPACE:-.}/.sbt -Dsbt.ivy.home=${CI_WORKSPACE:-.}/.ivy2 ${SBT_OPTS}"

if [ "${PLUGIN_ACTION:-compile}" = "compile" ]; then
  sbt test:compile
fi

if [ "${PLUGIN_ACTION:-lint}" = "lint" ]; then
  sbt scalafmtCheckAll scalafmtSbtCheck
fi

if [ "${PLUGIN_ACTION:-test}" = "test" ]; then
  sbt -Dmongodb.uri=mongodb://mongodb:27017 test
  sbt packageSite
fi

if [ "${PLUGIN_ACTION:-publish}" = "publish" ]; then
  echo "Version: ${VERSION}"
  echo "Publish: ${PUBLISH}"
  if [ "${PUBLISH}" = "production" ]; then
    export DOCKER_TAG="latest"
    sbt docker:publish
    sbt impl/httpPushSite
  elif [ "${PUBLISH}" = "staging" ]; then
    export DOCKER_TAG="staging"
    sbt docker:publish
  else
    echo "Skipping"
  fi
fi
