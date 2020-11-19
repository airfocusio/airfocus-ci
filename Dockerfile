FROM ubuntu:18.04

ENV DOCKER_VERSION="18.06.3-ce"
ENV GIT_DESCRIBE_SEMVER_VERSION="0.2.0"
ENV SCALA_VERSION="2.13.1"
ENV SBT_VERSION="1.4.3"
ENV NODE_VERSION="12.15.0"

WORKDIR /tmp

# install basic tools
RUN \
  apt-get update && \
  apt-get install --yes git wget xz-utils && \
  apt-get clean

# install docker cli
RUN \
  wget -q https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz && \
  echo "79a983a41275bd7a660a42935504f5c1ff7a5858  docker-$DOCKER_VERSION.tgz" | sha1sum -c - && \
  tar xf docker-$DOCKER_VERSION.tgz && \
  mv docker /opt/docker && \
  ln -s /opt/docker/docker /usr/bin/docker && \
  rm docker-$DOCKER_VERSION.tgz

# install git-describe-semver
RUN \
  wget -q https://github.com/choffmeister/git-describe-semver/releases/download/v$GIT_DESCRIBE_SEMVER_VERSION/git-describe-semver-linux-amd64 && \
  echo "9dd6ca2e030eb82a91c6ecf86d5795ba7e8181a6  git-describe-semver-linux-amd64" | sha1sum -c - && \
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
  echo "6edff6445fffb71ba0342e9515b3c89645aec790  scala-$SCALA_VERSION.tgz" | sha1sum -c - && \
  tar xf scala-$SCALA_VERSION.tgz && \
  mv scala-$SCALA_VERSION /opt/scala && \
  rm scala-$SCALA_VERSION.tgz
ENV PATH="/opt/scala/bin:$PATH"
RUN \
  wget -q https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz && \
  echo "a0cc73e1aea4572486d7a1d4ce2ca07b4f3af5e1  sbt-$SBT_VERSION.tgz" | sha1sum -c - && \
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
  echo "81cb697bf54fa1f7b083082a0462f4079a626da0  node-v$NODE_VERSION-linux-x64.tar.xz" | sha1sum -c - && \
  tar xf node-v$NODE_VERSION-linux-x64.tar.xz && \
  mv node-v$NODE_VERSION-linux-x64 /opt/node && \
  rm node-v$NODE_VERSION-linux-x64.tar.xz
ENV PATH="/opt/node/bin:$PATH"
RUN \
  npm install -g yarn

WORKDIR /workspace
