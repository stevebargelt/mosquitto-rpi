# mosquitto-rpi - [![Build Status](https://travis-ci.org/stevebargelt/mosquitto-rpi.svg?branch=master)](https://travis-ci.org/stevebargelt/mosquitto-rpi)

Twitter: [@stevebargelt](http://www.twitter.com/stevebargelt)

## docker-compose usage

An example of using an external and internal Mosquitto MQTT broker:

```
version: '3.1'
services:
  mqtt-ext:
    image: stevebargelt/mosquitto-rpi
    restart: always
    ports: 
      - "8083:8083"
      - "8883:8883"
    volumes:
        - /etc/letsencrypt:/etc/letsencrypt
        - /home/pi/homeassistant/mosquitto-ext.conf:/mosquitto/config/mosquitto.conf
        - /etc/ssl/certs/DST_Root_CA_X3.pem:/mosquitto/DST_Root_CA_X3.pem
        - /home/pi/homeassistant/pwfile:/etc/mosquitto/pwfile
        - /mosquitto/data
        - /mosquitto/log
  mqtt-int:
    image: stevebargelt/mosquitto-rpi
    restart: always
    depends_on:
      - mqtt-ext
    ports: 
      - "1883:1883"
    volumes:
        - /home/pi/homeassistant/mosquitto-int.conf:/mosquitto/config/mosquitto.conf
        - /etc/ssl/certs/DST_Root_CA_X3.pem:/mosquitto/DST_Root_CA_X3.pem
        - /mosquitto/data
        - /mosquitto/log
```

## Config File Examples

External (mosquitto-ext.conf)

```
persistence true
persistence_location /mosquitto/data/
log_dest file /mosquitto/log/mosquitto-ext.log

allow_anonymous false
password_file /etc/mosquitto/pwfile

listener 8883
cafile /mosquitto/DST_Root_CA_X3.pem
certfile /etc/letsencrypt/live/<YOUR URL>/fullchain.pem
keyfile /etc/letsencrypt/live/<YOUR URL>/privkey.pem

listener 8083
protocol websockets
cafile /mosquitto/DST_Root_CA_X3.pem
certfile /etc/letsencrypt/live/<YOUR URL>/fullchain.pem
keyfile /etc/letsencrypt/live/<YOUR URL>/privkey.pem
```

Internal (mosquitto-int.conf)

```
persistence true
persistence_location /mosquitto/data/
log_dest file /mosquitto/log/mosquitto-int.log

# Bridge to ext
connection mosquitto-ext
bridge_cafile <PATH_TO/DST_Root_CA_X3.pem>
bridge_insecure false
address DOMAIN_OR_IP_ADDRESS:8383
start_type automatic
remote_username !test
remote_password !test
notifications true
try_private true
topic owntracks/# in
```