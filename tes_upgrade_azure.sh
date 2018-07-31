#!/bin/bash

###################################################################################################################################
ZIPFILE=thingserver-8.3.2-b626.zip
URL1=http://localhost:2019/ExperienceService
URL2=http://localhost:8080
##################################
service thingserver stop
set -e 
echo -n "What's the Upgrade Version?  "
read ver
mkdir /appl/tes_$ver
cp /home/ftashev/$ZIPFILE /appl/tes_$ver
cd /appl/tes_$ver && unzip $ZIPFILE && rm -rf $ZIPFILE 
mv /appl/tes_$ver/configuration.json /appl/tes_$ver/configuration.json_old && cp /appl/tes/configuration.json /appl/tes_$ver
cp -a  /appl/tes/stores /appl/tes_$ver/
npm install
chown -R twadmin.twadmin /appl/tes_$ver
rm -rf /appl/tes && ln -s /appl/tes_$ver /appl/tes
service thingserver start
systemctl stop tomcat
systemctl status tomcat 
systemctl start tomcat 
systemctl status tomcat
service thingserver status

if curl --output /dev/null --silent --head --fail "$URL1"; then
  echo "Studio URL is UP and Running, Great Job!!!"
  else
    echo "Studio URL is DOWN!" 
fi





#######################################################################################################################################
