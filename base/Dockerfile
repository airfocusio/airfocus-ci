FROM ubuntu:18.04

ENV DOCKER_VERSION="18.06.3-ce"

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

COPY base/version.sh /usr/bin/version
