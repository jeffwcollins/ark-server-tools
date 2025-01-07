FROM	cm2network/steamcmd:root
LABEL	MAINTAINER="https://github.com/jeffwcollins/"

ARG	ARK_TOOLS_VERSION="1.6.64"
#ARG	IMAGE_VERSION="dev"

#ENV	IMAGE_VERSION="${IMAGE_VERSION}"
ENV	ARK_TOOLS_DIR="${ARK_SERVER_VOLUME}/arkmanager"
ENV	SESSION_NAME="Dockerized ARK Server with Ark Server Tools" \
	SERVER_MAP="TheIsland" \
	SERVER_PASSWORD="YouShallNotPass" \
	ADMIN_PASSWORD="Th155houldD3f1n3tlyB3Chang3d" \
	MAX_PLAYERS="20" \
	GAME_MOD_IDS="" \
	GAME_CLIENT_PORT="7779" \
	UDP_SOCKET_PORT="7780" \
	SERVER_LIST_PORT="27017" \
	RCON_PORT="27022" \
	ENABLE_CROSSPLAY="false" \
	DISABLE_BATTLEYE="false" \
	UPDATE_ON_START="false" \
	BACKUP_ON_STOP="false" \
	PRE_UPDATE_BACKUP="true" \
	WARN_ON_STOP="true" \
	ARK_TOOLS_VERSION="${ARK_TOOLS_VERSION}" \
	ARK_SERVER_VOLUME="/app" \
	TEMPLATE_DIRECTORY="/conf.d" \
	STEAM_HOME="/home/${USER}" \
	STEAM_USER="${USER}" \
	STEAM_LOGIN="anonymous"

RUN	set -x && \
	apt-get update && \
	apt-get install -y perl-modules \
                               curl \
                               lsof \
                               libc6-i386 \
                               lib32gcc-s1 \
                               bzip2 \
                               gosu \
                               cron \
	&& \
	curl -L "https://github.com/arkmanager/ark-server-tools/archive/v${ARK_TOOLS_VERSION}.tar.gz" \
	            | tar -xvzf - -C /tmp/ && \
	bash -c "cd /tmp/ark-server-tools-${ARK_TOOLS_VERSION}/tools && bash -x install.sh ${USER}" && \
	ln -s /usr/local/bin/arkmanager /usr/bin/arkmanager && \
	install -d -o ${USER} ${ARK_SERVER_VOLUME} && \
	su ${USER} -c "bash -x ${STEAMCMDDIR}/steamcmd.sh +login anonymous +quit" && \
	apt-get -qq autoclean && apt-get -qq autoremove && apt-get -qq clean && \
	rm -rf /tmp/* /var/cache/*

COPY	bin/    /
COPY	conf.d  ${TEMPLATE_DIRECTORY}

EXPOSE	${GAME_CLIENT_PORT}/udp ${UDP_SOCKET_PORT}/udp ${SERVER_LIST_PORT}/udp ${RCON_PORT}/tcp

VOLUME	["${ARK_SERVER_VOLUME}"]

WORKDIR	${ARK_SERVER_VOLUME}

ENTRYPOINT	["/docker-entrypoint.sh"]

CMD	[]
