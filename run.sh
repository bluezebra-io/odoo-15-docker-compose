#!/bin/bash
DESTINATION=$1
PORT=$2
CHAT=$3
# clone Odoo directory
git clone --depth=1 https://github.com/bluezebra-io/odoo-14-docker-compose $DESTINATION
rm -rf $DESTINATION/.git
# set permission
mkdir -p $DESTINATION/postgresql
sudo chmod -R 777 $DESTINATION
# enterprise
cd $DESTINATION
git clone -b 14.0 https://github.com/odoo/enterprise.git
cd ..
# config
if grep -qF "fs.inotify.max_user_watches" /etc/sysctl.conf; then echo $(grep -F "fs.inotify.max_user_watches" /etc/sysctl.conf); else echo "fs.inotify.max_user_watches = 524288" | sudo tee -a /etc/sysctl.conf; fi
sudo sysctl -p
sed -i'.original' -e 's/10014/'$PORT'/g' $DESTINATION/docker-compose.yml
sed -i'.original' -e 's/20014/'$CHAT'/g' $DESTINATION/docker-compose.yml
# run Odoo
docker-compose -f $DESTINATION/docker-compose.yml up -d

echo 'Started Odoo @ http://localhost:'$PORT' | Live chat port: '$CHAT
