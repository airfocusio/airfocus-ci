#!/bin/bash
set -e
source /base-entry.sh

export GITHUB_REPO="${PLUGIN_GITHUB_REPO:-airfocusio/airfocus-deployment}"
export GITHUB_USER="${PLUGIN_GITHUB_USER:-airfocusbot}"
export GITHUB_ACCESS_TOKEN="${PLUGIN_GITHUB_ACCESS_TOKEN}"
export PULUMI_ACCESS_TOKEN="${PLUGIN_PULUMI_ACCESS_TOKEN}"
export PULUMI_CONFIG_KEYS="${PLUGIN_PULUMI_CONFIG_KEYS}"
export PULUMI_DIRECTORY="${PLUGIN_PULUMI_DIRECTORY:-application}"

function prepare {
  # create temporary directory
  TEMP_DIR="$(mktemp -d)"
  cd "${TEMP_DIR}"

  # create new branch from old base branch
  echo "Checking out repository..."
  export GIT_BRANCH_BASE="master"
  export GIT_BRANCH_NEXT="deployment/$(date '+%Y%m%d%H%M%S')"
  git clone -b "${GIT_BRANCH_BASE}" --single-branch --depth=1 "https://${GITHUB_USER}:${GITHUB_ACCESS_TOKEN}@github.com/${GITHUB_REPO}.git" .
  git config user.name "${GITHUB_USER}"
  git config user.email "${GITHUB_USER}@github"
  git checkout -B "${GIT_BRANCH_NEXT}"

  # update docker tags
  echo "Updating docker tags..."
  cd "${PULUMI_DIRECTORY}"
  pulumi login
  pulumi stack select ${PUBLISH}
  for KEY in $(echo ${PULUMI_CONFIG_KEYS} | tr ',' '\n'); do
    pulumi config set ${KEY} ${VERSION}
  done
  git diff -U0 | cat
  git add .
  git commit -m "[${CI_REPO_NAME}] ${CI_COMMIT_MESSAGE}"
}

if [ "${PUBLISH}" == "production" ]; then
  prepare
  echo "Creating pull request..."
  git push origin "${GIT_BRANCH_NEXT}" -f
  curl -X POST "https://api.github.com/repos/${GITHUB_REPO}/pulls" \
    --fail \
    --silent \
    --output /dev/null \
    -u "${GITHUB_USER}:${GITHUB_ACCESS_TOKEN}" \
    -d @- << EOF
{
  "title": "[${CI_REPO_NAME}] ${CI_COMMIT_MESSAGE}",
  "body": "",
  "head": "${GIT_BRANCH_NEXT}",
  "base": "${GIT_BRANCH_BASE}"
}
EOF
elif [ "${PUBLISH}" == "staging" ]; then
  prepare
  echo "Pushing..."
  git push origin "${GIT_BRANCH_NEXT}:${GIT_BRANCH_BASE}"
else
  echo "Skipping"
fi
