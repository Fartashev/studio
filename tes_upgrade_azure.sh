#!/bin/bash

###################################################################################################################################

service thingserver stop
echo -n "What's the Upgrade Version?  "
read ver
mkdir /appl/tes_$ver
cp /home/ftashev/thingserver-8.2.3-b576.zip /appl/tes_$ver
cd /appl/tes_$ver && unzip thingserver-8.2.3-b576.zip && rm -rf thingserver-8.2.3-b576.zip
mv /appl/tes_$ver/configuration.json /appl/tes_$ver/configuration.json_old && cp /appl/tes/configuration.json /appl/tes_$ver
cp -a /appl/tes/stores/projects /appl/tes_$ver/stores
npm install
chown -R twadmin.twadmin /appl/tes_$ver
rm -rf /appl/tes && ln -s /appl/tes_$ver /appl/tes
service thingserver start
systemctl stop tomcat
systemctl status tomcat 
systemctl start tomcat 
systemctl status tomcat
service thingserver status  

#######################################################################################################################################
