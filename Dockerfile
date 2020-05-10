FROM python:3
LABEL maintainer yeahmatte <yeahmatte@summitmonster.com>

# Set environment variables.
ENV TERM=xterm-color
ENV SHELL=/bin/bash

RUN \
	mkdir /mosquitto && \
	mkdir /mosquitto/log && \
	mkdir /mosquitto/conf && \
	apt-get -y update && \
	apt-get -y upgrade && \
	apt-get -y install bash && \
	apt-get -y install coreutils && \
	apt-get -y install python-pycryptodome && \
	apt-get -y install nano && \
	apt-get -y install ca-certificates && \
	apt-get -y install certbot && \
	apt-get -y install mosquitto && \
	apt-get -y install mosquitto-clients && \
	apt-get -y install sudo && \
	rm -f /var/cache/apk/* && \
	pip install --upgrade pip && \
	pip install pyRFC3339 configobj ConfigArgParse

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
EXPOSE 80

# This will run any scripts found in /scripts/*.sh
# then start Apache
CMD ["/bin/bash","-c","/run.sh"]