#!/usr/bin/env bash

apt-get update > /dev/null
apt-get install -y python-software-properties

# Mongo
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.0.list

# Add postgres
POSTGRES_KEY_URL="https://www.postgresql.org/media/keys/ACCC4CF8.asc"
curl $POSTGRES_KEY_URL | apt-key add -
add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main"

# Add Java
add-apt-repository ppa:webupd8team/java
apt-get update > /dev/null
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

apt-get install -y \
  oracle-java8-installer \
  git \
  postgresql-9.4 \
  mongodb-org \
  redis-server


# Add leinigen
LEIN_URL="https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein"
LEIN_BIN=/usr/local/bin/lein
curl --silent --output $LEIN_BIN $LEIN_URL
chmod 755 $LEIN_BIN

apt-get autoremove -y

