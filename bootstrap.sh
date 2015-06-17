#!/usr/bin/env bash
set -xe

RABBIT_KEY_URL="https://www.rabbitmq.com/rabbitmq-signing-key-public.asc"
POSTGRES_KEY_URL="https://www.postgresql.org/media/keys/ACCC4CF8.asc"
LEIN_URL="https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein"
LEIN_BIN=/usr/local/bin/lein

# Add keys
curl --silent $POSTGRES_KEY_URL | apt-key add -

gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7F0CEB10
gpg --export --armor 7F0CEB10  | apt-key add -

apt-get update #> /dev/null
apt-get install -y python-software-properties

# Add repositories
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.0.list
add-apt-repository "deb http://ftp.heanet.ie/pub/ubuntu/ trusty  main"
add-apt-repository "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse"
add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main"
add-apt-repository ppa:webupd8team/java

# Accept Java TOS
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

apt-get update #> /dev/null
apt-get install -y \
  oracle-java8-installer \
  git \
  postgresql-9.4 \
  postgresql-contrib-9.4 \
  mongodb-org \
  redis-server #\

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.deb.sh | bash

apt-get autoremove -y

# Add leinigen
curl --silent --output $LEIN_BIN $LEIN_URL
chmod 755 $LEIN_BIN

echo 'Bootstrap complete'
