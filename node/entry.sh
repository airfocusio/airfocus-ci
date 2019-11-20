#!/bin/bash
set -e
source /base-entry.sh

echo -e "//npm.pkg.airfocus.dev/:_authToken=${PLUGIN_REGISTRY_TOKEN}\nunsafe-perm = true" > ~/.npmrc
cd ${PLUGIN_CWD:-.}

if [ "${PLUGIN_ACTION:-install}" = "install" ]; then
  npm install
fi

if [ "${PLUGIN_ACTION:-lint}" = "lint" ]; then
  npm run lint
fi

if [ "${PLUGIN_ACTION:-test}" = "test" ]; then
  npm run test -- --passWithNoTests
fi

if [ "${PLUGIN_ACTION:-publish}" = "publish" ]; then
  echo "Version: ${VERSION}"
  echo "Publish: ${PUBLISH}"
  if [ "${PUBLISH}" = "production" ]; then
    npm version ${VERSION}
    npm publish --tag latest
  elif [ "${PUBLISH}" = "staging" ]; then
    npm version ${VERSION}
    npm publish --tag staging
  else
    echo "Skipping"
  fi
fi
