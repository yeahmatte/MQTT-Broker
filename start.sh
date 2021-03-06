DIR=./mosquitto
if [ -d "$DIR" ]; then
    echo "Mosquitto directory exists"
else
    mkdir $DIR
    echo "Mosquitto directory created"
fi
sudo chown 1883:1883 $DIR -R

DIR=./mosquitto/conf
if [ -d "$DIR" ]; then
    echo "Config directory exists"
else
    mkdir $DIR
    echo "Config directory created"
fi
sudo chown 1883:1883 $DIR -R

DIR=./mosquitto/log
if [ -d "$DIR" ]; then
    echo "Log directory exists"
else
    mkdir $DIR
    echo "Log directory created"
fi
sudo chown 1883:1883 $DIR -R

DIR=./mosquitto/data
if [ -d "$DIR" ]; then
    echo "data directory exists"
else
    mkdir $DIR
    echo "data directory created"
fi
sudo chown 1883:1883 $DIR -R


DIR=./letsencrypt
if [ -d "$DIR" ]; then
    echo "Letsencrypt directory exists"
else
    mkdir $DIR
    echo "Letsencrypt directory created"
fi
sudo chown 1883:1883 $DIR -R

DIR=./letsencrypt/certificates
if [ -d "$DIR" ]; then
    echo "Letsencrypt directory exists"
else
    mkdir $DIR
    echo "Letsencrypt directory created"
fi
sudo chown 1883:1883 $DIR -R

DIR=./scripts
if [ -d "$DIR" ]; then
    echo "Scripts directory exists"
else
    mkdir $DIR
    echo "Scripts directory created"
fi
sudo chown 1883:1883 $DIR -R

# Files
sudo python3 install_tools/start.py

#

DIR=./mosquitto/log
LOGFILE=./mosquitto/log/mosquitto.log
if [ -f "$LOGFILE" ]; then
    echo "$LOGFILE exists"
else
    touch $LOGFILE
fi
sudo chmod o+w $LOGFILE
sudo chown 1883:1883 $DIR -R

# ======== Config ==========

CONFFILE=./mosquitto/conf/mosquitto.conf
if [ -f "$CONFFILE" ]; then
    echo "$CONFFILE exists"
else
    echo "No Configuration File, aborting"
    exit 1
fi

PWDFILE=./mosquitto/conf/passwordfile
if [ -f "$PWDFILE" ]; then
    echo "$PWDFILE exists"
else
    touch $PWDFILE
    echo "$PWDFILE created"
fi

sudo chmod o+w $PWDFILE

DIR=./mosquitto/conf
sudo chown 1883:1883 $DIR -R

# ======== Data ==========
DIR=./mosquitto/data
sudo chown 1883:1883 $DIR -R

CAFILE=./letsencrypt/chain.pem
if [ -f "$CAFILE" ]; then
    rm $CAFILE
fi
curl https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem.txt > ./letsencrypt/chain.pem


#docker-compose pull
docker-compose up -d
#docker-compose up --exit-code-from mqtt-broker
