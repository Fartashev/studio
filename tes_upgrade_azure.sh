#!/bin/bash

###################################################################################################################################

service thingserver stop
echo -n "What's the Upgrade Version?  "
read ver
mkdir /appl/tes_$ver
cp /home/ftashev/thingserver-8.3.0-b588.zip /appl/tes_$ver
cd /appl/tes_$ver && unzip thingserver-8.3.0-b588.zip && rm -rf thingserver-8.3.0-b588.zip
mv /appl/tes_$ver/configuration.json /appl/tes_$ver/configuration.json_old && cp /appl/tes/configuration.json /appl/tes_$ver
cp -a  /appl/tes/stores /appl/tes_$ver/
npm install
chown -R twadmin.twadmin /appl/tes_$ver
rm -rf /appl/tes && ln -s /appl/tes_$ver /appl/tes
cd /appl/thingworxData && mv license.bin license.bin_old_issue
cp /home/ftashev/license.bin /appl/thingworxData/
service thingserver start
systemctl stop tomcat
systemctl status tomcat 
systemctl start tomcat 
systemctl status tomcat
service thingserver status

echo "Testing TES URL"
###########################################
curl http://localhost:2019/ExperienceService
##########################################
echo "Testing TWX URL"
curl curl http://localhost:8080
cat tes/configuration.json |grep defaultDomainName  

echo /appl/tes_$ver/stores/projects
#######################################################################################################################################
