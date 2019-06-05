FROM lsiobase/ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG DILLINGER_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

RUN \
 echo "**** install build env ****" && \
 apt-get update && \
 apt-get install -y \
        git \
        gnupg \
	libfontconfig && \
 curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
 echo 'deb https://deb.nodesource.com/node_12.x bionic main' \
	> /etc/apt/sources.list.d/nodesource.list && \
 apt-get update && \
 apt-get install -y \
	nodejs && \
 echo "**** install dillinger ****" && \
 mkdir -p \
	/app/dillinger && \
 if [ -z ${DILLINGER_VERSION+x} ]; then \
	DILLINGER_VERSION=$(git ls-remote --tags https://github.com/joemccann/dillinger.git \
	| grep -v '{}' | tail -n 1 | awk -F / '{print $3}'); \
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
 rm -rf \
	/root \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/* && \
 mkdir -p \
	/root

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8080
VOLUME /config
