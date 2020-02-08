FROM docker.pkg.airfocus.dev/airfocus/airfocus-ci-base:latest

ENV NODE_VERSION="12.15.0"

# install nodejs, npm, yarn
RUN \
  wget -q https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz && \
  echo "81cb697bf54fa1f7b083082a0462f4079a626da0  node-v$NODE_VERSION-linux-x64.tar.xz" | sha1sum -c - && \
  tar xf node-v$NODE_VERSION-linux-x64.tar.xz && \
  mv node-v$NODE_VERSION-linux-x64 /opt/node && \
  rm node-v$NODE_VERSION-linux-x64.tar.xz
ENV PATH="/opt/node/bin:$PATH"
RUN \
  npm install -g yarn

COPY base/entry.sh /base-entry.sh
COPY node/entry.sh /entry.sh
ENTRYPOINT ["/entry.sh"]

WORKDIR /workspace
