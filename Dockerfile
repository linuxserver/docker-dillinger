FROM lsiobase/xenial
MAINTAINER sparklyballs

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV NODE_ENV=production

# build packages variable
ARG BUILD_DEPENDENCIES="\
	apt-transport-https \
	lsb-release"

# install build packages
RUN \
 apt-get update && \
 apt-get install -y \
	${BUILD_DEPENDENCIES} && \

# install runtime packages
 curl -sL http://nsolid-deb.nodesource.com/nsolid_setup_2.x | bash - && \
 apt-get install --no-install-recommends -y \
	bzip2 \
	git \
	libfontconfig \
	nsolid-boron \
	python-software-properties && \

# install dillinger
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

# uninstall build packages
 apt-get purge -y --auto-remove \
	${BUILD_DEPENDENCIES} && \

# cleanup
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
