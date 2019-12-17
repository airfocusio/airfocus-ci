FROM docker.pkg.airfocus.dev/airfocus/airfocus-ci-scala:latest

WORKDIR /tmp

# install atlassian sdk
RUN \
  apt-get update && \
  apt-get install --yes gnupg && \
  sh -c 'echo "deb https://packages.atlassian.com/debian/atlassian-sdk-deb/ stable contrib" >>/etc/apt/sources.list' && \
  wget -qO atlassian-sdk-key https://packages.atlassian.com/api/gpg/key/public && \
  apt-key add atlassian-sdk-key && \
  apt-get update && \
  apt-get install --yes atlassian-plugin-sdk && \
  apt-get clean
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

WORKDIR /workspace
