FILE=./mosquitto
if [ -d "$FILE" ]; then
    echo "Mosquitto directory exists"
else
    mkdir $FILE
    echo "Mosquitto directory created"
fi

# ======== CERTIFICATES ==========

FILE=./mosquitto/certs
if [ -d "$FILE" ]; then
    echo "$FILE directory exists"
else
    mkdir $FILE
    echo "$FILE directory created"
fi

# generate-certificates.sh

CACERT_DEST=./mosquitto/certs/ca.crt
CACERT_OUTPUT=./Certificates/output/ca.crt
if [ -f "$CACERT_DEST" ]; then
    chk1=`cksum $CACERT_DEST | awk -F" " '{print $1}'`
    chk2=`cksum $CACERT_OUTPUT | awk -F" " '{print $1}'`
    if [ $chk1 -eq $chk2 ]
    then
      echo "$CACERT_DEST Already up to date"
    else
      echo "Different file in output, copy to $CACERT_DEST"
      cp $CACERT_OUTPUT $CACERT_DEST
    fi
else
  echo "No CA Certificate in config folder"
  if [ -f $CACERT_OUTPUT ]; then
    echo "$CACERT_OUTPUT output exist, copying from output"
    cp $CACERT_OUTPUT $CACERT_DEST
  else
      echo "No certificate generated, aborting"
      exit 1
  fi
fi

SERVERCERT_DEST=./mosquitto/certs/server.crt
SERVERCERT_OUTPUT=./Certificates/output/server.crt
if [ -f "$SERVERCERT_DEST" ]; then
    chk1=`cksum $SERVERCERT_DEST | awk -F" " '{print $1}'`
    chk2=`cksum $SERVERCERT_OUTPUT | awk -F" " '{print $1}'`
    if [ $chk1 -eq $chk2 ]
    then
      echo "$SERVERCERT_DEST Already up to date"
    else
      echo "Different file in output, copy to $SERVERCERT_DEST"
      cp $SERVERCERT_OUTPUT $SERVERCERT_DEST
    fi
else
  echo "No SERVER Certificate in config folder"
  if [ -f $SERVERCERT_OUTPUT ]; then
    echo "$SERVERCERT_OUTPUT output exist, copying from output"
    cp $SERVERCERT_OUTPUT $SERVERCERT_DEST
  else
      echo "No Certificate generated, aborting"
      exit 1
  fi
fi

SERVERKEY_DEST=./mosquitto/certs/server.key
SERVERKEY_OUTPUT=./Certificates/output/server.key
if [ -f "$SERVERKEY_DEST" ]; then
    chk1=`cksum $SERVERKEY_DEST | awk -F" " '{print $1}'`
    chk2=`cksum $SERVERKEY_OUTPUT | awk -F" " '{print $1}'`
    if [ $chk1 -eq $chk2 ]
    then
      echo "$SERVERKEY_DEST Already up to date"
    else
      echo "Different file in output, copy to $SERVERKEY_DEST"
      cp $SERVERKEY_OUTPUT $SERVERKEY_DEST
    fi
else
  echo "No SERVER KEY in config folder"
  if [ -f $SERVERKEY_OUTPUT ]; then
    echo "$SERVERKEY_OUTPUT output exist, copying from output"
    cp $SERVERKEY_OUTPUT $SERVERKEY_DEST
  else
      echo "No key generated, aborting"
      exit 1
  fi
fi

DIR=./mosquitto/certs
sudo chown 1883:1883 $DIR -R

# ======== Log file ==========

DIR=./mosquitto/log
if [ -d "$DIR" ]; then
    echo "$DIR directory exists"
else
    mkdir $DIR
    echo "$DIR directory created"
fi

LOGFILE=./mosquitto/log/mosquitto.log
if [ -f "$LOGFILE" ]; then
    echo "$LOGFILE exists"
else
    touch $LOGFILE
fi
sudo chmod o+w $LOGFILE
sudo chown 1883:1883 $DIR -R

# ======== Config ==========

CONFFILE=./mosquitto/config/mosquitto.conf
if [ -f "$CONFFILE" ]; then
    echo "$CONFFILE exists"
else
    echo "No Configuration File, aborting"
    exit 1
fi

PWDFILE=./mosquitto/config/password_file
if [ -f "$PWDFILE" ]; then
    echo "$PWDFILE exists"
else
    touch $PWDFILE
    echo "$PWDFILE created"
fi

sudo chmod o+w $PWDFILE

DIR=./mosquitto/config
sudo chown 1883:1883 $DIR -R

# ======== Data ==========
DIR=./mosquitto/data
sudo chown 1883:1883 $DIR -R


#docker-compose pull
docker-compose up -d
#docker-compose up --exit-code-from mqtt-broker
