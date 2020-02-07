FROM docker.pkg.airfocus.dev/airfocus/airfocus-ci-node:latest

ENV PULUMI_VERSION="1.10.1"

WORKDIR /tmp

# install curl
RUN \
  apt-get update && \
  apt-get install --yes curl && \
  apt-get clean

# install pulumi
RUN wget -q https://get.pulumi.com/releases/sdk/pulumi-v${PULUMI_VERSION}-linux-x64.tar.gz \
 && tar xf pulumi-v${PULUMI_VERSION}-linux-x64.tar.gz \
 && mv pulumi/* /usr/bin \
 && rm pulumi-v${PULUMI_VERSION}-linux-x64.tar.gz

COPY base/entry.sh /base-entry.sh
COPY pulumi/entry.sh /entry.sh
ENTRYPOINT ["/entry.sh"]

WORKDIR /
