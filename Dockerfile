FROM ubuntu:18.04

ENV DOCKER_VERSION="18.09.9"
ENV GIT_DESCRIBE_SEMVER_VERSION="0.2.4"
ENV SCALA_VERSION="2.13.6"
ENV SBT_VERSION="1.5.3"
ENV NODE_VERSION="14.17.1"

WORKDIR /tmp

# install basic tools
RUN \
  apt-get update && \
  apt-get install --yes git wget curl xz-utils && \
  apt-get clean

# install docker cli
RUN \
  wget -q https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz && \
  sha1sum docker-$DOCKER_VERSION.tgz && \
  echo "1b1516253aa876f77193deb901e53977b3c84476  docker-$DOCKER_VERSION.tgz" | sha1sum -c - && \
  tar xf docker-$DOCKER_VERSION.tgz && \
  mv docker /opt/docker && \
  ln -s /opt/docker/docker /usr/bin/docker && \
  rm docker-$DOCKER_VERSION.tgz

# install git-describe-semver
RUN \
  wget -q https://github.com/choffmeister/git-describe-semver/releases/download/v$GIT_DESCRIBE_SEMVER_VERSION/git-describe-semver-linux-amd64 && \
  sha1sum git-describe-semver-linux-amd64 && \
  echo "a1056bc9b410ba22c926a17ab14795cac4389588  git-describe-semver-linux-amd64" | sha1sum -c - && \
  mkdir /opt/git-describe-semver && \
  mv git-describe-semver-linux-amd64 /opt/git-describe-semver && \
  chmod +x /opt/git-describe-semver/git-describe-semver-linux-amd64 && \
  ln -s /opt/git-describe-semver/git-describe-semver-linux-amd64 /usr/bin/git-describe-semver

# install openjdk, scala, sbt
RUN \
  apt-get update && \
  apt-get install --yes openjdk-8-jdk && \
  apt-get clean
RUN \
  wget -q http://downloads.lightbend.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz && \
  sha1sum scala-$SCALA_VERSION.tgz && \
  echo "b491e0ff053fb4deafc1a34037b9cde2a9cb1e85  scala-$SCALA_VERSION.tgz" | sha1sum -c - && \
  tar xf scala-$SCALA_VERSION.tgz && \
  mv scala-$SCALA_VERSION /opt/scala && \
  rm scala-$SCALA_VERSION.tgz
ENV PATH="/opt/scala/bin:$PATH"
RUN \
  wget -q https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz && \
  sha1sum sbt-$SBT_VERSION.tgz && \
  echo "bede5186a4e01fecb8014031a2535e532ef3b64c  sbt-$SBT_VERSION.tgz" | sha1sum -c - && \
  tar xf sbt-$SBT_VERSION.tgz && \
  mv sbt /opt/sbt && \
  rm sbt-$SBT_VERSION.tgz
ENV PATH="/opt/sbt/bin:$PATH"
RUN \
  mkdir project && \
  echo "sbt.version=$SBT_VERSION" > project/build.properties && sbt sbtVersion && \
  rm -rf project

# install nodejs, npm, yarn
RUN \
  wget -q https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz && \
  sha1sum node-v$NODE_VERSION-linux-x64.tar.xz && \
  echo "64480158581bf04ff3ec91745294253c61ed596a  node-v$NODE_VERSION-linux-x64.tar.xz" | sha1sum -c - && \
  tar xf node-v$NODE_VERSION-linux-x64.tar.xz && \
  mv node-v$NODE_VERSION-linux-x64 /opt/node && \
  rm node-v$NODE_VERSION-linux-x64.tar.xz
ENV PATH="/opt/node/bin:$PATH"
RUN \
  npm install -g npm && \
  npm install -g yarn

WORKDIR /workspace
