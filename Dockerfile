FROM lsiobase/xenial

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV NODE_ENV=production

# build packages variable
ARG BUILD_DEPENDENCIES="\
	apt-transport-https \
	lsb-release"

RUN \
 echo "**** install build packages ****" && \
 apt-get update && \
 apt-get install -y \
	${BUILD_DEPENDENCIES} && \
 echo "**** install runtime packages ****" && \
 curl -sL http://nsolid-deb.nodesource.com/nsolid_setup_2.x | bash - && \
 apt-get install --no-install-recommends -y \
	bzip2 \
	git \
	libfontconfig \
	nsolid-boron \
	python-software-properties && \
 echo "**** install dillinger ****" && \
 mkdir -p \
	/app/dillinger && \
 curl -o \
 /tmp/dillinger.tar.gz -L \
	https://github.com/joemccann/dillinger/archive/master.tar.gz && \
 tar xf \
 /tmp/dillinger.tar.gz -C \
	/app/dillinger --strip-components=1 && \
 cd /app/dillinger && \
 npm install && \
 echo "**** cleanup ****" && \
 apt-get purge -y --auto-remove \
	${BUILD_DEPENDENCIES} && \
 npm cache clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8080
VOLUME /config
