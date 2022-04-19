FROM ghcr.io/linuxserver/baseimage-alpine:3.15

# set version label
ARG BUILD_DATE
ARG VERSION
ARG DILLINGER_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

RUN \
 echo "**** install build env ****" && \
  apk add -U --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    curl \
    jq \
    npm && \
  echo "**** install dillinger ****" && \
  mkdir -p \
    /app/dillinger && \
  if [ -z ${DILLINGER_VERSION+x} ]; then \
    DILLINGER_VERSION=$(curl -sX GET "https://api.github.com/repos/joemccann/dillinger/tags" \
    | jq -r '.[0].name'); \
  fi && \
  curl -o \
  /tmp/dillinger.tar.gz -L \
    "https://github.com/joemccann/dillinger/archive/${DILLINGER_VERSION}.tar.gz" && \
  tar -xzf \
  /tmp/dillinger.tar.gz -C \
    /app/dillinger/ --strip-components=1 && \
  echo "**** install node modules ****" && \
  npm config set unsafe-perm true && \
  npm install --production \
    --prefix /app/dillinger && \
  echo "**** clean up ****" && \
  npm cache clean --force && \
  rm -rf \
    /root/* \
    /tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8080
VOLUME /config
