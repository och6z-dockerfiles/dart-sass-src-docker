ARG DEBIAN_VERSION

FROM debian:${DEBIAN_VERSION}

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    apt-transport-https \
    gnupg \
    && apt-get purge -y && apt-get autoremove -y && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*

RUN sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' \
    && sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list' \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    dart \
    && apt-get purge -y && apt-get autoremove -y && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*

ENV PATH "$PATH:/usr/lib/dart/bin"

RUN echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> ~/.profile

ARG DARTSASS_VERSION
ARG DARTSASS_DOWNLOAD_URL=https://github.com/sass/dart-sass/archive/${DARTSASS_VERSION}.tar.gz
ENV DARTSASS_DOWNLOAD_URL ${DARTSASS_DOWNLOAD_URL}

RUN wget --output-document=dart-sass.tar.gz ${DARTSASS_DOWNLOAD_URL} \
    && mkdir --parents /usr/src/dart-sass \
    && tar -xzf dart-sass.tar.gz --directory=/usr/src/dart-sass --strip-components=1 \
    && rm dart-sass.tar.gz \
    && cd /usr/src/dart-sass/ && pub get

ENTRYPOINT ["/bin/bash", "-c"]
