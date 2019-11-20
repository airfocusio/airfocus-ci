FROM docker.pkg.airfocus.dev/airfocus/airfocus-ci-base:latest

ENV SCALA_VERSION="2.13.1"
ENV SBT_VERSION="1.3.3"

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
  wget -q https://piccolo.link/sbt-$SBT_VERSION.tgz && \
  echo "dd9b0b78307d460fc7d4a759e66c15c958a23eab  sbt-$SBT_VERSION.tgz" | sha1sum -c - && \
  tar xf sbt-$SBT_VERSION.tgz && \
  mv sbt /opt/sbt && \
  rm sbt-$SBT_VERSION.tgz
ENV PATH="/opt/sbt/bin:$PATH"
RUN \
  mkdir project && \
  echo "sbt.version=1.3.3" > project/build.properties && sbt sbtVersion && \
  echo "sbt.version=1.2.8" > project/build.properties && sbt sbtVersion && \
  echo "sbt.version=1.1.6" > project/build.properties && sbt sbtVersion && \
  rm -rf project

COPY base/entry.sh /base-entry.sh
COPY scala/entry.sh /entry.sh
ENTRYPOINT ["/entry.sh"]

WORKDIR /workspace
