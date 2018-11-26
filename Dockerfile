FROM resin/rpi-raspbian:stretch
LABEL maintainer="steve@bargelt.com"

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y wget && apt-get install apt-transport-https

RUN wget -q http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key 
RUN apt-key add mosquitto-repo.gpg.key
RUN wget -q -O /etc/apt/sources.list.d/mosquitto-stretch.list http://repo.mosquitto.org/debian/mosquitto-stretch.list
RUN apt-get update && apt-get install -y mosquitto && rm -rf /var/lib/apt/lists/* 

RUN mkdir -p /mosquitto/config /mosquitto/data /mosquitto/log && \
	  chown -R mosquitto:mosquitto /mosquitto

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
RUN chown -R mosquitto:mosquitto /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/mosquitto", "-c", "/mosquitto/config/mosquitto.conf"]