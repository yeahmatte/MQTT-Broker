FROM python:3
LABEL maintainer yeahmatte <yeahmatte@summitmonster.com>

# Set environment variables.
ENV TERM=xterm-color
ENV SHELL=/bin/bash


RUN	mkdir /mosquitto
RUN	mkdir /mosquitto/log
RUN	mkdir /mosquitto/conf
RUN	mkdir /mosquitto/data
RUN	mkdir /etc/letsencrypt


RUN	apt-get -y update
RUN	apt-get -y upgrade
RUN	apt-get -y install bash
RUN	apt-get -y install coreutils
RUN	apt-get -y install python-pycryptodome
RUN	apt-get -y install nano
RUN	apt-get -y install ca-certificates
RUN	apt-get -y install certbot
RUN	apt-get -y install mosquitto
RUN	apt-get -y install mosquitto-clients
RUN	apt-get -y install sudo
RUN	rm -f /var/cache/apk/*
RUN	pip install --upgrade pip
RUN	pip install pyRFC3339 configobj ConfigArgParse

COPY ./containerfiles/run.sh /run.sh
COPY ./containerfiles/certbot.sh /certbot.sh
COPY ./containerfiles/restart.sh /restart.sh
COPY ./containerfiles/croncert.sh /etc/periodic/weekly/croncert.sh
RUN \
	chmod +x /run.sh && \
	chmod +x /certbot.sh && \
	chmod +x /restart.sh && \
	chmod +x /etc/periodic/weekly/croncert.sh

EXPOSE 1883
EXPOSE 8883
EXPOSE 8083
EXPOSE 80

# This will run any scripts found in /scripts/*.sh
# then start Apache
CMD ["/bin/bash","-c","/run.sh"]
