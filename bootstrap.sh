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

apt-get update > /dev/null
apt-get install --yes python-software-properties

# Add repositories
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.0.list
add-apt-repository --yes "deb http://ftp.heanet.ie/pub/ubuntu/ trusty  main"
add-apt-repository --yes "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse"
add-apt-repository --yes "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main"
add-apt-repository --yes ppa:serge-hallyn/userns-natty
apt-add-repository --yes ppa:andrei-pozolotin/maven3
add-apt-repository --yes ppa:webupd8team/java
add-apt-repository --yes ppa:cwchien/gradle

# Accept Java TOS
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

apt-get update > /dev/null
apt-get install -y \
  sshfs \
  btrfs-tools \
  lxc \
  maven3 \
  ant \
  oracle-java8-installer \
  git \
  tree \
  postgresql-9.4 \
  postgresql-contrib-9.4 \
  mongodb-org \
  gradle \
  gnupg-agent \
  redis-server \
  nsexec \
  uidmap
apt-get remove -y command-not-found

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.deb.sh | bash

apt-get autoremove -y

modprobe btrfs # start btrfs kernel module

# Add leinigen
curl --silent --output $LEIN_BIN $LEIN_URL
chmod 755 $LEIN_BIN

echo 'Creating BTRFS volume'

mkdir /volume/
dd if=/dev/zero of=/volume/btrfs count=2 bs=1G
losetup /dev/loop0 /volume/btrfs
mkfs.btrfs /dev/loop0
mkdir /mnt/btrfs

echo 'Bootstrap complete'
