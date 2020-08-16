FROM ubuntu:18.04

ENV DOCKER_VERSION="18.06.3-ce"
ENV GIT_DESCRIBE_SEMVER_VERSION="0.2.0"

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

COPY base/version.sh /usr/bin/version
